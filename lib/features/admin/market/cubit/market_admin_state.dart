import 'package:flutter/material.dart';
import 'package:gym_management_app/features/data/market_item_model.dart';

@immutable
sealed class MarketAdminState {}

final class MarketAdminInitial extends MarketAdminState {}

final class MarketAdminLoading extends MarketAdminState {}

final class MarketAdminLoaded extends MarketAdminState {
  final List<MarketItemModel> products;
  MarketAdminLoaded({required this.products});
}

final class MarketAdmintypeChange extends MarketAdminState {}

final class MarketAdminImagePicked extends MarketAdminState {}

final class MarketAdminStockToggled extends MarketAdminState {}

final class MarketAdminAdded extends MarketAdminState {}

final class MarketAdminFiltered extends MarketAdminState {
  final List<MarketItemModel>? filteredProducts;
  MarketAdminFiltered(this.filteredProducts);
}

final class MarketAdminUpdated extends MarketAdminState {}

final class MarketAdminDeleted extends MarketAdminState {}

final class MarketAdminError extends MarketAdminState {
  final String message;
  MarketAdminError(this.message);
}
