import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/features/auth/data/auth_repo.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authRepo) : super(AuthInitial());
  final AuthRepo _authRepo;

  bool isAdmin = false;
  bool obscurePassword = true;
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Future<void> close() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }

  void toggleAdmin(bool? value) {
    isAdmin = value ?? false;
    emit(AuthAdminToggleState());
  }

  void toggleObscurePassword() {
    obscurePassword = !obscurePassword;
    emit(AuthAdminToggleState());
  }

  Future<void> memberLogin() async {
    emit(AuthLoadingState());
    try {
      await _authRepo.memberLogin(
        userName: nameController.text.trim(),
        userPhone: phoneController.text.trim(),
      );

      emit(AuthSccessState());
    } catch (e) {
      emit(AuthErrorState(_formatError(e)));
    }
  }

  Future<void> adminLogin() async {
    emit(AuthLoadingState());
    try {
      await _authRepo.adminLogin(
        email: emailController.text,
        password: passwordController.text,
      );
      emailController.clear();
      passwordController.clear();
      emit(AuthSccessState());
    } catch (e) {
      emit(AuthErrorState(_formatError(e)));
    }
  }

  Future<void> logout() async {
    emit(AuthLoadingState());
    await _authRepo.logout();
    emit(AuthLogoutedState());
  }

  String _formatError(Object e) {
    final msg = e.toString();
    return msg.startsWith('Exception: ') ? msg.substring(11) : msg;
  }
}
