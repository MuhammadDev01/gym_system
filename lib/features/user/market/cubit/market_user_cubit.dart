import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/core/DI/service_locator.dart';
import 'package:gym_management_app/features/user/market/cubit/marke_user_state.dart';
import 'package:gym_management_app/features/data/market_item_model.dart';
import 'package:gym_management_app/features/data/market_repo.dart';
import 'package:gym_management_app/features/user/market/views/widgets/market_item_filter.dart';

class MarketUserCubit extends Cubit<MarketUserState> {
  MarketUserCubit() : super(MarketInitial());

  List<MarketItemModel> _allItems = [];

  FilterType selectedFilter = FilterType.all;
  List<MarketItemModel> filteredItems = [];

  Future<void> getProducts() async {
    emit(MarketLoading());
    try {
      _allItems = await getIt<MarketRepo>().getAllProducts();
      if (isClosed) return;
      filteredItems = List.from(_allItems);

      emit(MarketLoaded());
    } catch (e) {
      final msg = e.toString();
      emit(
        MarketError(
          message: msg.startsWith('Exception: ') ? msg.substring(11) : msg,
        ),
      );
    }
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
