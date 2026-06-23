import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/features/members/data/member_model.dart';
import 'package:gym_management_app/features/members/cubit/member_state.dart';
import 'package:gym_management_app/features/members/data/members_repo.dart';

class MemberCubit extends Cubit<MemberState> {
  MemberCubit(this._memberRepo) : super(MemberInitial());
  final MemberRepo _memberRepo;
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  int selectedMonths = 1;
  String selectedType = 'gym';

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

  List<MemberModel> members = [];

  Future<void> getAllMembers() async {
    emit(MemberLoadingState());
    try {
      members = await _memberRepo.getAllMembers();
      emit(MemberLoadedState(members: members));
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
      emit(MemberLoadedState(members: members));
      return;
    }
    final filtered = members.where((m) {
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
