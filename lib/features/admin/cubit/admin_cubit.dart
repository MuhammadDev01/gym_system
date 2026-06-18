import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/features/admin/data/admin_repo.dart';

part 'admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  AdminCubit(this._adminRepo) : super(MemberInitial());

  final AdminRepo _adminRepo;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  Future<void> close() {
    nameController.dispose();
    phoneController.dispose();
    return super.close();
  }

  Future<void> addMember() async {
    emit(MemberLoadingState());
    try {
      await _adminRepo.addMember(
        username: nameController.text.trim(),
        userPhone: phoneController.text.trim(),
      );
      nameController.clear();
      phoneController.clear();
      emit(MemberAddedState());
    } catch (e) {
      final msg = e.toString();
      emit(MemberErrorState(
        msg.startsWith('Exception: ') ? msg.substring(11) : msg,
      ));
    }
  }
}
