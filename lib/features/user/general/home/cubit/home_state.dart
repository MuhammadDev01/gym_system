import 'package:flutter/material.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeDataLoaded extends HomeState {}

final class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
