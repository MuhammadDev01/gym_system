part of 'gerenal_cubit.dart';

@immutable
sealed class GerenalState {}

final class GerenalInitial extends GerenalState {}

final class GerenalSuccess extends GerenalState {}

final class GerenalError extends GerenalState {}
