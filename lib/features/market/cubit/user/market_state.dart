import 'package:flutter/material.dart';

@immutable
sealed class MarketState {}

final class MarketInitial extends MarketState {}

final class MarketLoaded extends MarketState {}

final class MarketLoading extends MarketState {}

final class MarketItemAdded extends MarketState {}

final class MarketItemUpdated extends MarketState {}

final class MarketItemDeleted extends MarketState {}

final class MarketError extends MarketState {
  final String? message;

  MarketError({required this.message});
}
