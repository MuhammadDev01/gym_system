import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/core/models/member_model.dart';
import 'package:gym_management_app/features/admin/cubit/member/member_state.dart';
import 'package:gym_management_app/features/admin/data/members_repo.dart';

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
    } catch (e) {
      final msg = e.toString();
      emit(
        MemberErrorState(
          msg.startsWith('Exception: ') ? msg.substring(11) : msg,
        ),
      );
    }
  }

  List<MemberModel> _allMembers = [];

  Future<void> getAllMembers() async {
    emit(MemberLoadingState());
    try {
      _allMembers = await _memberRepo.getAllMembers();
      emit(MemberLoadedState(members: _allMembers));
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
      emit(MemberLoadedState(members: _allMembers));
      return;
    }
    final filtered = _allMembers.where((m) {
      return m.name.contains(query) || m.phone.contains(query);
    }).toList();
    emit(MemberLoadedState(members: filtered));
  }

  MemberModel? editTarget;
  final editNameController = TextEditingController();
  final editPhoneController = TextEditingController();
  int editMonths = 1;
  String editType = 'gym';

  void startEdit(MemberModel member) {
    editTarget = member;
    editNameController.text = member.name;
    editPhoneController.text = member.phone;
    editMonths = member.subscriptionMonths;
    editType = member.subscriptionType;
    emit(MemberEditFormState());
  }

  void cancelEdit() {
    editTarget = null;
    editNameController.clear();
    editPhoneController.clear();
    editMonths = 1;
    editType = 'gym';
    emit(MemberLoadedState(members: _allMembers));
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
      );
      cancelEdit();
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
