import 'package:flutter/material.dart';

@immutable
sealed class AlertUserState {}

final class AlertInitial extends AlertUserState {}

final class AlertLoadingState extends AlertUserState {}

final class AlertSuccessState extends AlertUserState {}

final class AlertErrorState extends AlertUserState {
  final String message;
  AlertErrorState(this.message);
}
