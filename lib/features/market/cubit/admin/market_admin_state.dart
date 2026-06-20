import 'package:flutter/material.dart';
import 'package:gym_management_app/features/market/data/market_item_model.dart';

@immutable
sealed class MarketAdminState {}

final class MarketAdminInitial extends MarketAdminState {}

final class MarketAdminLoading extends MarketAdminState {}

final class MarketAdminLoaded extends MarketAdminState {
  final List<MarketModel> products;
  MarketAdminLoaded({required this.products});
}

final class MarketAdminAdded extends MarketAdminState {}

final class MarketAdminUpdated extends MarketAdminState {}

final class MarketAdminDeleted extends MarketAdminState {}

final class MarketAdminError extends MarketAdminState {
  final String message;
  MarketAdminError(this.message);
}
