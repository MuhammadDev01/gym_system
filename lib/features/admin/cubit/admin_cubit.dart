import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/core/models/user_model.dart';
import 'package:gym_management_app/features/admin/data/admin_repo.dart';

part 'admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  AdminCubit(this._adminRepo) : super(MemberInitial());

  final AdminRepo _adminRepo;
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  int selectedMonths = 1;
  String selectedType = 'gym';

  @override
  Future<void> close() {
    nameController.dispose();
    phoneController.dispose();
    return super.close();
  }

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
      await _adminRepo.addMember(
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

  Future<void> getMembers() async {
    emit(MembersLoadingState());
    try {
      final members = await _adminRepo.getMembers();
      emit(MembersLoadedState(members: members));
    } catch (e) {
      final msg = e.toString();
      emit(
        MembersErrorState(
          msg.startsWith('Exception: ') ? msg.substring(11) : msg,
        ),
      );
    }
  }
}
