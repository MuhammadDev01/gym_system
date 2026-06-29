import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/core/DI/service_locator.dart';
import 'package:gym_management_app/features/members/data/member_model.dart';
import 'package:gym_management_app/features/members/cubit/member_state.dart';
import 'package:gym_management_app/features/members/data/members_repo.dart';
import 'package:gym_management_app/features/user/subscription/data/subscription_history_model.dart';
import 'package:gym_management_app/features/user/subscription/data/subscription_history_repo.dart';

class MemberCubit extends Cubit<MemberState> {
  MemberCubit(this._memberRepo) : super(MemberInitial());
  final MemberRepo _memberRepo;
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  static int _pricePerMonth(String type) {
    switch (type) {
      case 'fitness':
        return 400;
      case 'private':
        return 500;
      default:
        return 300;
    }
  }

  int selectedMonths = 1;
  String selectedType = 'gym';

  void init() {
    nameController.clear();
    phoneController.clear();
    setMonths(1);
    setType('gym');
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
      await getIt<SubscriptionHistoryRepo>().deleteOldRecords();
      if (isClosed) return;
      nameController.clear();
      phoneController.clear();
      selectedMonths = 1;
      selectedType = 'gym';
      emit(MemberAddedState());
      await getAllMembers();
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

  Future<void> getAllMembers() async {
    emit(MemberLoadingState());
    try {
      if (_members.isNotEmpty) {
        emit(MemberLoadedState(members: _members));
        return;
      }

      _members = await _memberRepo.getAllMembers();
      if (isClosed) return;

      emit(MemberLoadedState(members: _members));
    } catch (e) {
      final msg = e.toString();
      emit(
        MemberErrorState(
          msg.startsWith('Exception: ') ? msg.substring(11) : msg,
        ),
      );
    }
  }

  void searchMembers(String query) {
    if (query.isEmpty) {
      emit(MemberLoadedState(members: _members));
      return;
    }
    final filtered = _members.where((m) {
      return m.name.contains(query) || m.phone.contains(query);
    }).toList();
    emit(MemberLoadedState(members: filtered));
  }

  MemberModel? editTarget;
  final editNameController = TextEditingController();
  final editPhoneController = TextEditingController();
  int editMonths = 1;
  String editType = 'gym';
  DateTime? editStartDate;
  DateTime? editEndDate;

  void startEdit(MemberModel member) {
    editTarget = member;
    editNameController.text = member.name;
    editPhoneController.text = member.phone;
    editMonths = member.subscriptionMonths < 1 ? 1 : member.subscriptionMonths;
    editType = ['fitness', 'gym', 'private'].contains(member.subscriptionType)
        ? member.subscriptionType
        : 'gym';
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

  void setEditMonths(int months) {
    editMonths = months;
    emit(MemberEditFormState());
  }

  void setEditType(String type) {
    editType = type;
    emit(MemberEditFormState());
  }

  Future<void> updateMember() async {
    emit(MemberLoadingState());
    try {
      await _memberRepo.updateMember(
        docId: editTarget!.id,
        name: editNameController.text.trim(),
        phone: editPhoneController.text.trim(),
        subscriptionMonths: editMonths,
        subscriptionType: editType,
        subscriptionStart: editStartDate,
        subscriptionEnd: editEndDate,
      );

      final now = DateTime.now();
      final record = SubscriptionHistoryModel(
        id: '',
        userId: editTarget!.id,
        userName: editNameController.text.trim(),
        userPhone: editPhoneController.text.trim(),
        months: editMonths,
        type: editType,
        price: _pricePerMonth(editType) * editMonths,
        startDate: editStartDate ?? now,
        endDate: editEndDate ?? now,
        createdAt: now,
      );
      await getIt<SubscriptionHistoryRepo>().addRecord(record);
      await getIt<SubscriptionHistoryRepo>().deleteOldRecords();

      await getAllMembers();
      emit(MemberUpdatedState());
    } catch (e) {
      final msg = e.toString();
      emit(
        MemberErrorState(
          msg.startsWith('Exception: ') ? msg.substring(11) : msg,
        ),
      );
    }
  }

  Future<void> deleteMember() async {
    emit(MemberLoadingState());
    try {
      await _memberRepo.deleteMember(editTarget!.id);
      emit(MemberDeletedState());
      await getAllMembers();
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
    emit(MemberLoadingState());
    try {
      final member = await _memberRepo.getMemberByPhone(phoneController.text);
      if (member != null) {
        emit(MemberFoundState(member: member));
      } else {
        emit(MemberErrorState('لم يتم العثور على مشترك بهذا الرقم'));
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

  Future<void> markAttendanceWithTime() async {
    final phone = phoneController.text.trim();
    emit(MemberLoadingState());
    try {
      final member = await _memberRepo.getMemberByPhone(phone);
      if (isClosed) return;
      if (member == null) {
        emit(MemberErrorState('لم يتم العثور على مشترك بهذا الرقم'));
        return;
      }
      final alreadyAttended = await _memberRepo.hasAttendedToday(phone);
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
      phoneController.clear();
      if (isClosed) return;
      emit(MemberScannedState(member: member));
    } catch (e) {
      final msg = e.toString();
      emit(
        MemberErrorState(
          msg.startsWith('Exception: ') ? msg.substring(11) : msg,
        ),
      );
    }
  }

  Future<void> getAttendanceHistory() async {
    emit(MemberLoadingState());
    try {
      final records = await _memberRepo.getAttendanceByPhone(
        phoneController.text.trim(),
      );
      emit(AttendanceHistoryLoaded(records: records));
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
      await _memberRepo.deleteAttendanceRecord(docId);
      final records = await _memberRepo.getAttendanceByPhone(
        phoneController.text.trim(),
      );
      emit(AttendanceHistoryLoaded(records: records));
    } catch (e) {
      final msg = e.toString();
      emit(
        MemberErrorState(
          msg.startsWith('Exception: ') ? msg.substring(11) : msg,
        ),
      );
    }
  }

  Future<void> markAttendanceByPhone(String phone) async {
    emit(MemberLoadingState());
    try {
      final member = await _memberRepo.getMemberByPhone(phone);
      if (member == null) {
        emit(MemberErrorState('لم يتم العثور على مشترك بهذا الرقم'));
        return;
      }
      final alreadyAttended = await _memberRepo.hasAttendedToday(phone);
      if (alreadyAttended) {
        emit(MemberErrorState('تم تسجيل حضور هذا المشترك مسبقاً اليوم'));
        return;
      }
      await _memberRepo.toggleAttendance(member.id, attended: true);
      emit(MemberAttendanceMarked());
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
      await getAllMembers();
    } catch (e) {
      final msg = e.toString();
      emit(
        MemberErrorState(
          msg.startsWith('Exception: ') ? msg.substring(11) : msg,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    nameController.dispose();
    phoneController.dispose();
    editNameController.dispose();
    editPhoneController.dispose();
    return super.close();
  }
}
