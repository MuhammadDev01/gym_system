part of 'admin_cubit.dart';

@immutable
sealed class AdminState {}

final class MemberInitial extends AdminState {}

final class MemberFormChangedState extends AdminState {}

final class MemberLoadingState extends AdminState {}

final class MemberAddedState extends AdminState {}

final class MemberErrorState extends AdminState {
  final String message;
  MemberErrorState(this.message);
}

final class MembersLoadingState extends AdminState {}

final class MembersLoadedState extends AdminState {
  final List<UserModel> members;
  MembersLoadedState({required this.members});
}

final class MembersErrorState extends AdminState {
  final String message;
  MembersErrorState(this.message);
}
