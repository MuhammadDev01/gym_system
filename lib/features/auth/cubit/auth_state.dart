part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoadingState extends AuthState {}

final class AuthLogoutedState extends AuthState {}

final class AuthLoggedState extends AuthState {}

final class AuthAdminToggleState extends AuthState {}

final class AuthSccessState extends AuthState {
  // final UserModel user;
  // AuthSccessState({required this.user});
}

final class AuthErrorState extends AuthState {
  final String message;
  AuthErrorState(this.message);
}
