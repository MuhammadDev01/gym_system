import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/core/DI/service_locator.dart';
import 'package:gym_management_app/features/user/market/cubit/marke_user_state.dart';
import 'package:gym_management_app/features/data/market_item_model.dart';
import 'package:gym_management_app/features/data/market_repo.dart';
import 'package:gym_management_app/features/user/market/views/widgets/market_item_filter.dart';

class MarketUserCubit extends Cubit<MarketUserState> {
  MarketUserCubit() : super(MarketInitial());

  StreamSubscription? _subscription;
  List<MarketItemModel> _allItems = [];

  FilterType selectedFilter = FilterType.all;
  List<MarketItemModel> filteredItems = [];

  void getProducts() {
    emit(MarketLoading());
    _subscription = getIt<MarketRepo>().streamProducts().listen(
      (items) {
        _allItems = items;
        if (isClosed) return;
        _applyFilter();
      },
      onError: (e) {
        if (isClosed) return;
        final msg = e.toString();
        emit(
          MarketError(
            message: msg.startsWith('Exception: ') ? msg.substring(11) : msg,
          ),
        );
      },
    );
  }

  void filterByType(FilterType filter) {
    selectedFilter = filter;
    _applyFilter();
  }

  void _applyFilter() {
    if (selectedFilter == FilterType.all) {
      filteredItems = List.from(_allItems);
    } else {
      filteredItems = _allItems.where((item) {
        return selectedFilter == FilterType.tools
            ? item.type == ItemType.tool
            : item.type == ItemType.supplement;
      }).toList();
    }
    emit(MarketLoaded());
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
