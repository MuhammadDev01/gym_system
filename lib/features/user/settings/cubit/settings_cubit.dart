import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/features/auth/data/auth_repo.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(AuthRepo authRepo)
    : _authRepo = authRepo,
      super(SettingsInitial());

  final AuthRepo _authRepo;
  Future<void> logoutMember() async {
    emit(SettingsLoadingState());
    await _authRepo.logoutMember();
    emit(SettingsLogoutedState());
  }
}
