part of 'root_cubit.dart';

@immutable
sealed class RootState {}

final class RootInitial extends RootState {}

final class RootLoading extends RootState {}

final class RootSuccessLogin extends RootState {}

final class RootFailLogin extends RootState {}
