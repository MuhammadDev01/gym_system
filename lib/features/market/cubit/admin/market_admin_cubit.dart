import 'dart:convert';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/core/service/local/image_picker_service.dart';
import 'package:gym_management_app/features/market/cubit/admin/market_admin_state.dart';
import 'package:gym_management_app/features/market/data/market_item_model.dart';
import 'package:gym_management_app/features/market/data/market_repo.dart';

class MarketAdminCubit extends Cubit<MarketAdminState> {
  MarketAdminCubit(this._marketRepo) : super(MarketAdminInitial());
  final MarketRepo _marketRepo;

  List<MarketModel> _allProducts = [];

  Future<String?> pickImage() async {
    final file = await ImagePickerService.pickImageFromGallery();
    if (file == null) return null;
    final bytes = await File(file.path).readAsBytes();
    return base64Encode(bytes);
  }

  Future<void> getProducts() async {
    emit(MarketAdminLoading());
    try {
      _allProducts = await _marketRepo.getAllProducts();
      emit(MarketAdminLoaded(products: _allProducts));
    } catch (e) {
      final msg = e.toString();
      emit(
        MarketAdminError(
          msg.startsWith('Exception: ') ? msg.substring(11) : msg,
        ),
      );
    }
  }

  Future<void> addProduct({
    required String name,
    required String description,
    required String image,
    required int price,
    required String type,
  }) async {
    emit(MarketAdminLoading());
    try {
      await _marketRepo.addProduct(
        name: name,
        description: description,
        image: image,
        price: price,
        type: type,
      );
      await getProducts();
      emit(MarketAdminAdded());
    } catch (e) {
      final msg = e.toString();
      emit(
        MarketAdminError(
          msg.startsWith('Exception: ') ? msg.substring(11) : msg,
        ),
      );
    }
  }

  Future<void> updateProduct({
    required String docId,
    required String name,
    required String description,
    required String image,
    required int price,
    required String type,
  }) async {
    emit(MarketAdminLoading());
    try {
      await _marketRepo.updateProduct(
        docId: docId,
        name: name,
        description: description,
        image: image,
        price: price,
        type: type,
      );
      await getProducts();
      emit(MarketAdminUpdated());
    } catch (e) {
      final msg = e.toString();
      emit(
        MarketAdminError(
          msg.startsWith('Exception: ') ? msg.substring(11) : msg,
        ),
      );
    }
  }

  Future<void> deleteProduct(String docId) async {
    emit(MarketAdminLoading());
    try {
      await _marketRepo.deleteProduct(docId);
      await getProducts();
      emit(MarketAdminDeleted());
    } catch (e) {
      final msg = e.toString();
      emit(
        MarketAdminError(
          msg.startsWith('Exception: ') ? msg.substring(11) : msg,
        ),
      );
    }
  }
}
