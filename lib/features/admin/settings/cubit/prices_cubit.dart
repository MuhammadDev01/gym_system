import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/core/DI/service_locator.dart';
import 'package:gym_management_app/core/constants/app_constants.dart';
import 'package:gym_management_app/core/service/network/firebase_service.dart';
import 'package:gym_management_app/features/admin/settings/cubit/prices_state.dart';

class PricesCubit extends Cubit<PricesState> {
  PricesCubit()
      : _firebaseService = getIt<FirebaseService>(),
        super(PricesLoaded(gym: 300, fitness: 400, private: 500)) {
    _loadFromFirestore();
  }

  final FirebaseService _firebaseService;

  static const _collection = 'settings';
  static const _document = 'subscription_prices';

  Future<void> _loadFromFirestore() async {
    try {
      final doc = await _firebaseService.getDocument(
        collection: _collection,
        docId: _document,
      );
      if (doc.exists) {
        emit(PricesLoaded(
          gym: doc['gym'] as int? ?? 300,
          fitness: doc['fitness'] as int? ?? 400,
          private: doc['private'] as int? ?? 500,
        ));
      }
    } catch (_) {}
  }

  Future<void> updatePrices({
    required int gym,
    required int fitness,
    required int private,
  }) async {
    await _firebaseService.setDocument(
      collection: _collection,
      docId: _document,
      data: {'gym': gym, 'fitness': fitness, 'private': private},
    );
    emit(PricesLoaded(gym: gym, fitness: fitness, private: private));
  }

  int getPrice(String type) {
    final s = state;
    if (s is PricesLoaded) {
      switch (type) {
        case AppConstants.fitness:
          return s.fitness;
        case AppConstants.private:
          return s.private;
        default:
          return s.gym;
      }
    }
    return 300;
  }
}
