import 'package:flutter/material.dart';
import 'package:gym_management_app/core/models/member_model.dart';

@immutable
sealed class MemberState {}

final class MemberInitial extends MemberState {}

final class MemberSelectedState extends MemberState {}

final class MemberLoadingState extends MemberState {}

final class MemberAddedState extends MemberState {}

final class MemberUpdatedState extends MemberState {}

final class MemberDeletedState extends MemberState {}

final class MemberErrorState extends MemberState {
  final String message;
  MemberErrorState(this.message);
}

final class MemberLoadedState extends MemberState {
  final List<MemberModel> members;
  MemberLoadedState({required this.members});
}

final class MemberEditFormState extends MemberState {}
