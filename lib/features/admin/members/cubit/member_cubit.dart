import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/core/DI/service_locator.dart';
import 'package:gym_management_app/core/constants/app_constants.dart';
import 'package:gym_management_app/features/admin/members/data/member_model.dart';
import 'package:gym_management_app/features/admin/members/cubit/member_state.dart';
import 'package:gym_management_app/features/admin/members/data/members_repo.dart';
import 'package:gym_management_app/features/user/subscription/data/subscription_history_model.dart';
import 'package:gym_management_app/features/user/subscription/data/subscription_history_repo.dart';

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

  @override
  Future<void> close() {
    nameController.dispose();
    phoneController.dispose();
    editNameController.dispose();
    editPhoneController.dispose();
    return super.close();
  }

  static int _pricePerMonth(String type) {
    switch (type) {
      case AppConstants.fitness:
        return 400;
      case AppConstants.private:
        return 500;
      default:
        return 300;
    }
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
      await getIt<SubscriptionHistoryRepo>().deleteOldRecords();
      if (isClosed) return;
      nameController.clear();
      phoneController.clear();
      selectedMonths = 1;
      selectedType = 'gym';
      await getAllMembers(forceRefresh: true);
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

  void startEdit(MemberModel member) {
    selectedMember = member;
    selectedType = member.subscriptionType;
    editNameController.text = member.name;
    editPhoneController.text = member.phone;
    editStartDate = member.subscriptionStart;
    editEndDate = member.subscriptionEnd;
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
      await _memberRepo.updateMember(
        docId: selectedMember!.id,
        name: editNameController.text.trim(),
        phone: editPhoneController.text.trim(),
        subscriptionType: selectedType,
        subscriptionStart: editStartDate,
        subscriptionEnd: editEndDate,
      );

      final now = DateTime.now();
      final record = SubscriptionHistoryModel(
        id: '',
        userId: selectedMember!.id,
        userName: editNameController.text.trim(),
        userPhone: editPhoneController.text.trim(),
        months: 1,
        type: selectedType,
        price: 300,
        //price: _pricePerMonth(selectedType) * editMonths,
        startDate: editStartDate ?? now,
        endDate: editEndDate ?? now,
        createdAt: now,
      );
      await getIt<SubscriptionHistoryRepo>().addRecord(record);
      await getIt<SubscriptionHistoryRepo>().deleteOldRecords();

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

  //* DELETE
  Future<void> deleteMember() async {
    emit(MemberLoadingState());
    try {
      await _memberRepo.deleteMember(selectedMember!.id);
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
      emit(MemberLoadingState());
      await _memberRepo.deleteAttendanceRecord(docId);
      final records = await _memberRepo.getAttendanceByPhone(
        phoneController.text.trim(),
      );
      if (isClosed) return;
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
      if (member.subscriptionEnd != null &&
          DateTime.now().isAfter(member.subscriptionEnd!)) {
        emit(MemberErrorState('تم انتهاء اشتراك المشترك'));
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
