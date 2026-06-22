import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_alert_state.dart';

class UserAlertCubit extends Cubit<UserAlertState> {
  UserAlertCubit() : super(UserAlertInitial());
}
