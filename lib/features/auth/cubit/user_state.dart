part of 'user_cubit.dart';

@immutable
sealed class UserState {}

final class UserInitial extends UserState {}

final class UserImagePicked extends UserState {}

final class UserLoading extends UserState {}

final class UserRegistered extends UserState {}

final class UserError extends UserState {
  final String message;
  UserError(this.message);
}

final class UserLoginFieldError extends UserState {
  final String field;
  final String message;
  UserLoginFieldError(this.field, this.message);
}