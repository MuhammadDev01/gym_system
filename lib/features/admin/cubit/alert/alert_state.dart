import 'package:flutter/material.dart';
import 'package:gym_management_app/core/models/announcement_model.dart';

@immutable
sealed class AlertState {}

final class AlertInitial extends AlertState {}

final class AlertFormChangedState extends AlertState {}

final class AlertLoadingState extends AlertState {}

final class AlertAddedState extends AlertState {}

final class AlertErrorState extends AlertState {
  final String message;
  AlertErrorState(this.message);
}

final class AlertSuccessState extends AlertState {
  final List<AlertModel> alerts;
  AlertSuccessState({required this.alerts});
}

final class AlertUpdatedState extends AlertState {}
