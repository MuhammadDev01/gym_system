import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    emit(MemberFormChangedState());
  }

  void setType(String type) {
    selectedType = type;
    emit(MemberFormChangedState());
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

  Future<void> getMember() async {
    emit(MemberLoadingState());
    try {
      final member = await _memberRepo.getMember();
      emit(MemberLoadedState(member: member));
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
    return super.close();
  }
}
