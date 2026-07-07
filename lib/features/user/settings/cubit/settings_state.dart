part of 'settings_cubit.dart';

@immutable
sealed class SettingsState {}

final class SettingsInitial extends SettingsState {}

final class SettingsLoadingState extends SettingsState {}

final class SettingsLogoutedState extends SettingsState {}
