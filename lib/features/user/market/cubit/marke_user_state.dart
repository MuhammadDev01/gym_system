import 'package:flutter/material.dart';

@immutable
sealed class MarketUserState {}

final class MarketInitial extends MarketUserState {}

final class MarketLoaded extends MarketUserState {}

final class MarketLoading extends MarketUserState {}

final class MarketItemAdded extends MarketUserState {}

final class MarketItemUpdated extends MarketUserState {}

final class MarketItemDeleted extends MarketUserState {}

final class MarketError extends MarketUserState {
  final String message;

  MarketError({required this.message});
}
