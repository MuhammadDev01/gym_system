part of 'admin_cubit.dart';

@immutable
sealed class AdminState {}

final class MemberInitial extends AdminState {}

final class MemberLoadingState extends AdminState {}

final class MemberAddedState extends AdminState {}

final class MemberErrorState extends AdminState {
  final String message;
  MemberErrorState(this.message);
}
