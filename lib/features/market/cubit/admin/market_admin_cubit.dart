import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/core/service/local/image_picker_service.dart';
import 'package:gym_management_app/features/market/cubit/admin/market_admin_state.dart';
import 'package:gym_management_app/features/market/data/market_item_model.dart';
import 'package:gym_management_app/features/market/data/market_repo.dart';

class MarketAdminCubit extends Cubit<MarketAdminState> {
  MarketAdminCubit(this._marketRepo) : super(MarketAdminInitial());
  final MarketRepo _marketRepo;
  final nameController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();
  String selectedType = 'supplement';
  String? imageBase64;
  @override
  Future<void> close() async {
    nameController.dispose();
    descController.dispose();
    priceController.dispose();
    super.close();
  }

  void resetValues() {
    nameController.clear();
    descController.clear();
    priceController.clear();
    imageBase64 = null;
    selectedType = 'supplement';
  }

  List<MarketItemModel> allProducts = [];

  Future<void> pickImage() async {
    emit(MarketAdminLoading());
    final file = await ImagePickerService.pickImageFromGallery();
    if (file == null) {
      emit(MarketAdminInitial());
      return;
    }
    final bytes = await File(file.path).readAsBytes();
    imageBase64 = base64Encode(bytes);
    emit(MarketAdminImagePicked());
  }

  void setType(String? v) {
    if (v != null) selectedType = v;
    emit(MarketAdmintypeChange());
  }

  //*GET
  Future<void> getProducts() async {
    emit(MarketAdminLoading());
    try {
      allProducts = await _marketRepo.getAllProducts();
      emit(MarketAdminLoaded(products: allProducts));
      resetValues();
    } catch (e) {
      final msg = e.toString();
      emit(
        MarketAdminError(
          msg.startsWith('Exception: ') ? msg.substring(11) : msg,
        ),
      );
    }
  }

  //* ADD
  Future<void> addProduct() async {
    emit(MarketAdminLoading());
    try {
      await _marketRepo.addProduct(
        name: nameController.text.trim(),
        description: descController.text.trim(),
        image: imageBase64 ?? '',
        price: int.tryParse(priceController.text.trim()) ?? 0,
        type: selectedType,
      );
      emit(MarketAdminAdded());
      resetValues();
      await getProducts();
    } catch (e) {
      final msg = e.toString();
      emit(
        MarketAdminError(
          msg.startsWith('Exception: ') ? msg.substring(11) : msg,
        ),
      );
    }
  }

  String? itemImage;
  String? itemId;
  void startEdit(MarketItemModel item) {
    nameController.text = item.name;
    descController.text = item.description;
    priceController.text = item.price.toString();
    itemId = item.id;
    itemImage = item.image;
    imageBase64 = null;
    selectedType = item.type == ItemType.tool ? 'tool' : 'supplement';
  }

  //*UPDATE
  Future<void> updateProduct() async {
    emit(MarketAdminLoading());
    try {
      await _marketRepo.updateProduct(
        docId: itemId!,
        name: nameController.text.trim(),
        description: descController.text.trim(),
        image: imageBase64 ?? itemImage!,
        price: int.parse(priceController.text.trim()),
        type: selectedType,
      );
      emit(MarketAdminUpdated());
      resetValues();
      await getProducts();
    } catch (e) {
      final msg = e.toString();
      emit(
        MarketAdminError(
          msg.startsWith('Exception: ') ? msg.substring(11) : msg,
        ),
      );
    }
  }

  //*Delete
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
