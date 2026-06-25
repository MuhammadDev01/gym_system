import 'package:flutter/material.dart';
import 'package:gym_management_app/features/user/subscription/data/subscription_history_model.dart';

@immutable
sealed class SubscriptionHistoryState {}

final class SubscriptionHistoryInitial extends SubscriptionHistoryState {}

final class SubscriptionHistoryLoading extends SubscriptionHistoryState {}

final class SubscriptionHistoryLoaded extends SubscriptionHistoryState {
  final List<SubscriptionHistoryModel> records;
  SubscriptionHistoryLoaded({required this.records});
}

final class SubscriptionHistoryError extends SubscriptionHistoryState {
  final String message;
  SubscriptionHistoryError(this.message);
}
