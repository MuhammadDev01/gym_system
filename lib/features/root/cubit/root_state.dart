part of 'root_cubit.dart';

@immutable
sealed class RootState {}

final class RootInitial extends RootState {}

final class RootSuccess extends RootState {}

final class RootError extends RootState {}
