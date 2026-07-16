import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/core/constants/app_constants.dart';
import 'package:gym_management_app/core/service/local/image_picker_service.dart';
import 'package:gym_management_app/features/admin/market/cubit/market_admin_state.dart';
import 'package:gym_management_app/features/data/market_item_model.dart';
import 'package:gym_management_app/features/data/market_repo.dart';
import 'package:gym_management_app/features/user/market/views/widgets/market_item_filter.dart';

class MarketAdminCubit extends Cubit<MarketAdminState> {
  MarketAdminCubit(this._marketRepo) : super(MarketAdminInitial());
  final MarketRepo _marketRepo;
  final nameController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();
  final kiloPriceController = TextEditingController();
  final piecePriceController = TextEditingController();
  String selectedType = AppConstants.supplement;
  String? imageBase64;
  bool isInStock = true;
  bool sellByKilo = false;
  bool sellByPiece = false;
  @override
  Future<void> close() async {
    nameController.dispose();
    descController.dispose();
    priceController.dispose();
    kiloPriceController.dispose();
    piecePriceController.dispose();
    super.close();
  }

  void toggleStock() {
    isInStock = !isInStock;
    emit(MarketAdminStockToggled());
  }

  void toggleSellByKilo() {
    sellByKilo = !sellByKilo;
    if (!sellByKilo) kiloPriceController.clear();
    emit(MarketAdminKiloToggled());
  }

  void toggleSellByPiece() {
    sellByPiece = !sellByPiece;
    if (!sellByPiece) piecePriceController.clear();
    emit(MarketAdminKiloToggled());
  }

  void resetValues() {
    nameController.clear();
    descController.clear();
    priceController.clear();
    kiloPriceController.clear();
    piecePriceController.clear();
    imageBase64 = null;
    selectedType = AppConstants.supplement;
    isInStock = true;
    sellByKilo = false;
    sellByPiece = false;
  }

  Future<void> pickImage() async {
    final file = await ImagePickerService.pickImageFromGallery();
    if (isClosed) return;
    if (file == null) {
      emit(MarketAdminInitial());
      return;
    }
    final bytes = await File(file.path).readAsBytes();
    if (isClosed) return;

    imageBase64 = base64Encode(bytes);
    emit(MarketAdminImagePicked());
  }

  void setType(String? v) {
    if (v != null) selectedType = v;
    emit(MarketAdmintypeChange());
  }

  List<MarketItemModel> allProducts = [];
  //*GET
  Future<void> getProducts({bool refresh = false}) async {
    try {
      emit(MarketAdminLoading());
      if (allProducts.isNotEmpty && !refresh) {
        emit(MarketAdminLoaded(products: allProducts));
        return;
      }
      allProducts = await _marketRepo.getAllProducts();
      if (isClosed) return;
      filterByType(selectedFilter);
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
        isInStock: isInStock,
        sellByKilo: sellByKilo,
        kiloPrice: sellByKilo
            ? int.tryParse(kiloPriceController.text.trim())
            : null,
      );
      resetValues();
      if (isClosed) return;
      emit(MarketAdminAdded());
    } catch (e) {
      if (isClosed) return;
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
    if (item.sellByKilo && item.kiloPrice != null) {
      kiloPriceController.text = item.kiloPrice.toString();
    }
    if (item.sellByPiece && item.piecePrice != null) {
      piecePriceController.text = item.piecePrice.toString();
    }
    itemId = item.id;
    itemImage = item.image;
    imageBase64 = null;
    selectedType = item.type == ItemType.tool
        ? AppConstants.tool
        : AppConstants.supplement;
    isInStock = item.isInStock;
    sellByKilo = item.sellByKilo;
    sellByPiece = item.sellByPiece;
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
        isInStock: isInStock,
        sellByKilo: sellByKilo,
        kiloPrice: sellByKilo
            ? int.tryParse(kiloPriceController.text.trim())
            : null,
        sellByPiece: sellByPiece,
        piecePrice: sellByPiece
            ? int.tryParse(piecePriceController.text.trim())
            : null,
      );
      if (isClosed) return;
      resetValues();
      emit(MarketAdminUpdated());
      await getProducts(refresh: true);
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
      if (isClosed) return;
      emit(MarketAdminDeleted());
      await getProducts(refresh: true);
    } catch (e) {
      final msg = e.toString();
      emit(
        MarketAdminError(
          msg.startsWith('Exception: ') ? msg.substring(11) : msg,
        ),
      );
    }
  }

  //* FILTER PRODUCT
  FilterType selectedFilter = FilterType.all;
  List<MarketItemModel> filteredProducts = [];

  void filterByType(FilterType filter) {
    selectedFilter = filter;
    if (filter == FilterType.all) {
      filteredProducts = List.from(allProducts);
    } else {
      filteredProducts = allProducts.where((item) {
        return filter == FilterType.tools
            ? item.type == ItemType.tool
            : item.type == ItemType.supplement;
      }).toList();
    }
    emit(MarketAdminLoaded(products: filteredProducts));
  }
}
