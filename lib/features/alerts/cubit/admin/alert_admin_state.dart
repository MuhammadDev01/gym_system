import 'package:flutter/material.dart';

@immutable
sealed class AlertAdminState {}

final class AlertInitial extends AlertAdminState {}

final class AlertFormChangedState extends AlertAdminState {}

final class AlertLoadingState extends AlertAdminState {}

final class AlertAddedState extends AlertAdminState {}

final class AlertErrorState extends AlertAdminState {
  final String message;
  AlertErrorState(this.message);
}

final class AlertSuccessState extends AlertAdminState {}

final class AlertUpdatedState extends AlertAdminState {}

final class AlertDeletedState extends AlertAdminState {}
