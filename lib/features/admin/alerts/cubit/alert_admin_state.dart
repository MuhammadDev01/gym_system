import 'package:flutter/material.dart';
import 'package:gym_management_app/features/admin/alerts/data/alert_model.dart';

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

final class AlertsLoaded extends AlertAdminState {
  final List<AlertModel> alerts;
  AlertsLoaded({required this.alerts});
}

final class AlertUpdatedState extends AlertAdminState {}

final class AlertDeletedState extends AlertAdminState {}
