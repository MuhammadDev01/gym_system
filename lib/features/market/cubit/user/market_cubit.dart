import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/features/market/cubit/user/market_state.dart';
import 'package:gym_management_app/features/market/data/market_item_model.dart';
import 'package:gym_management_app/features/market/views/user/widgets/market_item_filter.dart';

class MarketCubit extends Cubit<MarketState> {
  MarketCubit() : super(MarketInitial()) {
    _loadItems();
  }

  final List<MarketModel> _allItems = [];

  FilterType selectedFilter = FilterType.all;
  List<MarketModel> filteredItems = [];

  void _loadItems() {
    filteredItems = List.from(_allItems);
    emit(MarketLoaded());
  }

  void filterByType(FilterType filter) {
    selectedFilter = filter;
    if (filter == FilterType.all) {
      filteredItems = List.from(_allItems);
    } else {
      filteredItems = _allItems.where((item) {
        return filter == FilterType.tools
            ? item.type == ItemType.tool
            : item.type == ItemType.supplement;
      }).toList();
    }
    emit(MarketLoaded());
  }
}
