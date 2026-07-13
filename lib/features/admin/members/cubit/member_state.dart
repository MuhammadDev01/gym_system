import 'package:flutter/material.dart';
import 'package:gym_management_app/features/admin/members/data/attendance_model.dart';
import 'package:gym_management_app/features/admin/members/data/member_model.dart';

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

final class MemberFoundState extends MemberState {
  final MemberModel member;
  MemberFoundState({required this.member});
}

final class MemberNotFoundState extends MemberState {
  final String message;
  MemberNotFoundState({required this.message});
}

final class MemberScannedState extends MemberState {
  final MemberModel member;
  MemberScannedState({required this.member});
}

final class MemberAttendanceMarked extends MemberState {}

final class AttendanceHistoryLoaded extends MemberState {
  final List<AttendanceRecord> records;
  AttendanceHistoryLoaded({required this.records});
}
