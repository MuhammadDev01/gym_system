import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/features/market/cubit/user/marke_user_state.dart';
import 'package:gym_management_app/features/market/data/market_item_model.dart';
import 'package:gym_management_app/features/market/views/user/widgets/market_item_filter.dart';

class MarketUserCubit extends Cubit<MarketState> {
  MarketUserCubit() : super(MarketInitial());

  final List<MarketItemModel> _allItems = [];

  FilterType selectedFilter = FilterType.all;
  List<MarketItemModel> filteredItems = [];

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
