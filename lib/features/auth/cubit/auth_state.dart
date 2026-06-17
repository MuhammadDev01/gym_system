part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class ImagePickedState extends AuthState {}

final class LoadingPickState extends AuthState {}

final class AuthLoadingState extends AuthState {}

final class AuthLogoutedState extends AuthState {}

final class AuthChangeFieldState extends AuthState {}

final class AuthSccessState extends AuthState {}

final class AuthErrorState extends AuthState {
  final String message;
  AuthErrorState(this.message);
}
