import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/features/auth/cubit/user_cubit.dart';

part 'root_state.dart';

class RootCubit extends Cubit<RootState> {
  RootCubit() : super(RootInitial());
  final bool isLogin = false;
  Future<bool> checkAuth() async {
    emit(RootLoading());
    final hasUser = await UserCubit.hasCachedUser();
    if (hasUser) {
      await UserCubit().restoreFromCache().then((v) {
        if (v) {
          emit(RootSuccessLogin());

          return true;
        } else {
          emit(RootFailLogin());
          return false;
        }
      });
    }
    emit(RootFailLogin());
    return isLogin;
  }
}
