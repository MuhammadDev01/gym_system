import 'package:flutter/material.dart';
import 'package:gym_management_app/features/alerts/data/alert_model.dart';
import 'package:gym_management_app/features/members/data/member_model.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeLoaded extends HomeState {
  final MemberModel member;
  final List<AlertModel> alerts;
  final int remainingDays;

  HomeLoaded({
    required this.member,
    required this.alerts,
    required this.remainingDays,
  });
}

final class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
