import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/core/DI/service_locator.dart';
import 'package:gym_management_app/core/constants/app_constants.dart';
import 'package:gym_management_app/features/admin/members/data/member_model.dart';
import 'package:gym_management_app/features/admin/members/cubit/member_state.dart';
import 'package:gym_management_app/features/admin/members/data/members_repo.dart';
import 'package:gym_management_app/features/user/subscription/data/subscription_history_model.dart';
import 'package:gym_management_app/features/user/subscription/data/subscription_history_repo.dart';
import 'package:gym_management_app/features/admin/settings/cubit/prices_cubit.dart';

enum MemberFilter { all, active, expired }

class MemberCubit extends Cubit<MemberState> {
  MemberCubit(this._memberRepo) : super(MemberInitial());
  final MemberRepo _memberRepo;
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final editNameController = TextEditingController();
  final editPhoneController = TextEditingController();
  int selectedMonths = 1;
  String selectedType = AppConstants.gym;
  MemberModel? selectedMember;
  final formKeyEdit = GlobalKey<FormState>();
  //int editMonths = 1;
  DateTime? editStartDate;
  DateTime? editEndDate;

  MemberFilter _filterType = MemberFilter.all;
  String _searchQuery = '';

  MemberFilter get filterType => _filterType;

  @override
  Future<void> close() {
    nameController.dispose();
    phoneController.dispose();
    editNameController.dispose();
    editPhoneController.dispose();
    attendanceSearchController.dispose();
    return super.close();
  }

  int _pricePerMonth(String type) {
    return getIt<PricesCubit>().getPrice(type);
  }

  void init() {
    nameController.clear();
    phoneController.clear();
    setMonths(1);
    setType(AppConstants.gym);
  }

  void setMonths(int months) {
    selectedMonths = months;
    emit(MemberSelectedState());
  }

  void setType(String type) {
    selectedType = type;
    emit(MemberSelectedState());
  }

  //* ADD
  Future<void> addMember() async {
    emit(MemberLoadingState());
    try {
      await _memberRepo.addMember(
        username: nameController.text.trim(),
        userPhone: phoneController.text.trim(),
        subscriptionMonths: selectedMonths,
        subscriptionType: selectedType,
      );

      final now = DateTime.now();
      final end = DateTime(now.year, now.month + selectedMonths, now.day);
      final record = SubscriptionHistoryModel(
        id: '',
        userId: phoneController.text.trim(),
        userName: nameController.text.trim(),
        userPhone: phoneController.text.trim(),
        months: selectedMonths,
        type: selectedType,
        price: _pricePerMonth(selectedType) * selectedMonths,
        startDate: now,
        endDate: end,
        createdAt: now,
      );
      await getIt<SubscriptionHistoryRepo>().addRecord(record);
      if (isClosed) return;
      emit(MemberAddedState());
    } catch (e) {
      final msg = e.toString();
      emit(
        MemberErrorState(
          msg.startsWith('Exception: ') ? msg.substring(11) : msg,
        ),
      );
    }
  }

  List<MemberModel> _members = [];

  Future<void> getAllMembers({bool forceRefresh = false}) async {
    try {
      emit(MemberLoadingState());
      if (!forceRefresh && _members.isNotEmpty) {
        _emitFiltered();
        return;
      }

      _members = await _memberRepo.getAllMembers();
      if (isClosed) return;

      _emitFiltered();
    } catch (e) {
      final msg = e.toString();
      emit(
        MemberErrorState(
          msg.startsWith('Exception: ') ? msg.substring(11) : msg,
        ),
      );
    }
  }

  void setFilter(MemberFilter filter) {
    _filterType = filter;
    _emitFiltered();
  }

  void searchMembers(String query) {
    _searchQuery = query;
    _emitFiltered();
  }

  void _emitFiltered() {
    var filtered = List<MemberModel>.from(_members);

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((m) {
        return m.name.contains(_searchQuery) || m.phone.contains(_searchQuery);
      }).toList();
    }

    if (_filterType == MemberFilter.active) {
      filtered = filtered
          .where(
            (m) =>
                m.subscriptionEnd != null &&
                !DateTime.now().isAfter(m.subscriptionEnd!),
          )
          .toList();
    } else if (_filterType == MemberFilter.expired) {
      filtered = filtered
          .where(
            (m) =>
                m.subscriptionEnd == null ||
                DateTime.now().isAfter(m.subscriptionEnd!),
          )
          .toList();
    }

    emit(MemberLoadedState(members: filtered));
  }

  void startEdit(MemberModel member) {
    selectedMember = member;
    selectedType = member.subscriptionType;
    editNameController.text = member.name;
    editPhoneController.text = member.phone;
    editStartDate = member.subscriptionStart;
    editEndDate = member.subscriptionEnd;
    emit(MemberEditFormState());
  }

  void setEditStartDate(DateTime date) {
    editStartDate = date;
    emit(MemberEditFormState());
  }

  void setEditEndDate(DateTime date) {
    editEndDate = date;
    emit(MemberEditFormState());
  }

  //* UPDATE
  Future<void> updateMember() async {
    emit(MemberLoadingState());
    try {
      final member = selectedMember!;
      await _memberRepo.updateMember(
        docId: member.id,
        name: editNameController.text.trim(),
        phone: editPhoneController.text.trim(),
        subscriptionType: selectedType,
        subscriptionStart: editStartDate,
        subscriptionEnd: editEndDate,
      );

      final datesChanged =
          member.subscriptionStart != editStartDate ||
          member.subscriptionEnd != editEndDate;

      if (datesChanged) {
        final now = DateTime.now();
        final record = SubscriptionHistoryModel(
          id: '',
          userId: member.id,
          userName: editNameController.text.trim(),
          userPhone: editPhoneController.text.trim(),
          months: 1,
          type: selectedType,
          price: _pricePerMonth(selectedType),
          startDate: editStartDate ?? now,
          endDate: editEndDate ?? now,
          createdAt: now,
        );
        await getIt<SubscriptionHistoryRepo>().addRecord(record);
      }

      await getAllMembers(forceRefresh: true);
      if (!isClosed) emit(MemberUpdatedState());
    } catch (e) {
      final msg = e.toString();
      emit(
        MemberErrorState(
          msg.startsWith('Exception: ') ? msg.substring(11) : msg,
        ),
      );
    }
  }

  //* DELETE
  Future<void> deleteMember() async {
    emit(MemberLoadingState());
    try {
      final memberId = selectedMember!.id;
      await _memberRepo.deleteAllAttendanceByUserPhone(memberId);
      await getIt<SubscriptionHistoryRepo>().deleteAllHistoryByUserId(memberId);
      await _memberRepo.deleteMember(memberId);
      if (isClosed) return;
      emit(MemberDeletedState());
      await getAllMembers(forceRefresh: true);
    } catch (e) {
      final msg = e.toString();
      emit(
        MemberErrorState(
          msg.startsWith('Exception: ') ? msg.substring(11) : msg,
        ),
      );
    }
  }

  Future<void> getMemberByPhone() async {
    try {
      emit(MemberLoadingState());
      final member = await _memberRepo.getMemberByPhone(phoneController.text);
      if (member != null) {
        emit(MemberFoundState(member: member));
      } else {
        emit(
          MemberNotFoundState(message: "لم يتم العثور على مشترك بهذا الرقم"),
        );
      }
    } catch (e) {
      final msg = e.toString();
      emit(
        MemberErrorState(
          msg.startsWith('Exception: ') ? msg.substring(11) : msg,
        ),
      );
    }
  }

  //* ATTENDANCE
  Future<void> markAttendanceWithTime(MemberModel member) async {
    emit(MemberLoadingState());
    try {
      if (member.subscriptionEnd != null &&
          DateTime.now().isAfter(member.subscriptionEnd!)) {
        emit(MemberErrorState('تم انتهاء اشتراك المشترك'));
        return;
      }
      final alreadyAttended = await _memberRepo.hasAttendedToday(member.phone);
      if (isClosed) return;
      if (alreadyAttended) {
        emit(MemberErrorState('تم تسجيل حضور هذا المشترك مسبقاً اليوم'));
        return;
      }
      await _memberRepo.recordAttendance(
        userId: member.id,
        userName: member.name,
        userPhone: member.phone,
      );
      await _memberRepo.cleanupOldAttendance();
      final now = DateTime.now();
      final idx = _members.indexWhere((m) => m.id == member.id);
      if (idx != -1) {
        _members[idx] = member.copyWith(lastAttendance: now);
        _emitFiltered();
      }
      if (isClosed) return;
      emit(MemberScannedState(member: member));
      phoneController.clear();
    } catch (e) {
      final msg = e.toString();
      emit(
        MemberErrorState(
          msg.startsWith('Exception: ') ? msg.substring(11) : msg,
        ),
      );
    }
  }

  final attendanceSearchController = TextEditingController();

  Future<void> getAttendanceHistory() async {
    emit(MemberLoadingState());
    try {
      final query = attendanceSearchController.text.trim().toLowerCase();
      if (query.isEmpty) {
        emit(AttendanceHistoryLoaded(records: []));
        return;
      }
      final all = await _memberRepo.getAllAttendance();
      final filtered = all.where((r) {
        return r.userName.contains(query) || r.userPhone.contains(query);
      }).toList();
      filtered.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      if (isClosed) return;
      emit(AttendanceHistoryLoaded(records: filtered));
    } catch (e) {
      final msg = e.toString();
      emit(
        MemberErrorState(
          msg.startsWith('Exception: ') ? msg.substring(11) : msg,
        ),
      );
    }
  }

  Future<void> deleteAttendanceRecord(String docId) async {
    try {
      emit(MemberLoadingState());
      await _memberRepo.deleteAttendanceRecord(docId);
      final query = attendanceSearchController.text.trim().toLowerCase();
      if (query.isEmpty) {
        emit(AttendanceHistoryLoaded(records: []));
        return;
      }
      final all = await _memberRepo.getAllAttendance();
      final filtered = all.where((r) {
        return r.userName.contains(query) || r.userPhone.contains(query);
      }).toList();
      filtered.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      if (isClosed) return;
      emit(AttendanceHistoryLoaded(records: filtered));
    } catch (e) {
      final msg = e.toString();
      emit(
        MemberErrorState(
          msg.startsWith('Exception: ') ? msg.substring(11) : msg,
        ),
      );
    }
  }

  Future<void> lookupMemberByPhone(String phone) async {
    emit(MemberLoadingState());
    try {
      final member = await _memberRepo.getMemberByPhone(phone);
      if (member == null) {
        emit(
          MemberNotFoundState(message: "لم يتم العثور على مشترك بهذا الرقم"),
        );
        return;
      }
      emit(MemberFoundState(member: member));
    } catch (e) {
      final msg = e.toString();
      emit(
        MemberErrorState(
          msg.startsWith('Exception: ') ? msg.substring(11) : msg,
        ),
      );
    }
  }

  Future<void> toggleAttendance(MemberModel member) async {
    try {
      await _memberRepo.toggleAttendance(
        member.id,
        attended: !member.attendedToday,
      );
      await getAllMembers(forceRefresh: true);
    } catch (e) {
      final msg = e.toString();
      emit(
        MemberErrorState(
          msg.startsWith('Exception: ') ? msg.substring(11) : msg,
        ),
      );
    }
  }
}
