import 'package:flutter/material.dart';
import 'package:gym_management_app/features/admin/members/data/member_model.dart';

@immutable
sealed class SubscriptionState {}

final class SubscriptionInitial extends SubscriptionState {}

final class SubscriptionLoading extends SubscriptionState {}

final class SubscriptionLoaded extends SubscriptionState {
  final MemberModel member;

  SubscriptionLoaded({required this.member});

  bool get isSubscribed {
    if (member.subscriptionEnd == null) return false;
    return member.subscriptionEnd!.isAfter(DateTime.now());
  }

  int get remainingDays {
    if (member.subscriptionEnd == null) return 0;
    final diff = member.subscriptionEnd!.difference(DateTime.now());
    return diff.inDays < 0 ? 0 : diff.inDays;
  }
}

final class SubscriptionError extends SubscriptionState {
  final String message;
  SubscriptionError(this.message);
}
