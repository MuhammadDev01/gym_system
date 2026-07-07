import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_management_app/core/service/network/firebase_exceptions.dart';
import 'package:gym_management_app/core/service/network/firebase_service.dart';
import 'package:gym_management_app/features/data/market_item_model.dart';

class MarketRepo {
  MarketRepo(this._firebaseService);
  final FirebaseService _firebaseService;

  Future<List<MarketItemModel>> getAllProducts() async {
    try {
      final result = await _firebaseService.getCollection(
        collection: 'products',
      );
      return result.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return MarketItemModel.fromJson(data, doc.id);
      }).toList();
    } on FirebaseException catch (e) {
      throw Exception(FirebaseExceptionMessages.getFirestoreMessage(e));
    }
  }

  Future<void> addProduct({
    required String name,
    required String description,
    required String image,
    required int price,
    required String type,
    bool isInStock = true,
  }) async {
    try {
      await _firebaseService.addDocument(
        collection: 'products',
        data: {
          'name': name.trim(),
          'description': description.trim(),
          'image': image,
          'price': price,
          'type': type,
          'isInStock': isInStock,
        },
      );
    } on FirebaseException catch (e) {
      throw Exception(FirebaseExceptionMessages.getFirestoreMessage(e));
    }
  }

  Future<void> updateProduct({
    required String docId,
    required String name,
    required String description,
    required String image,
    required int price,
    required String type,
    bool isInStock = true,
  }) async {
    try {
      await _firebaseService.setDocument(
        collection: 'products',
        docId: docId,
        data: {
          'name': name.trim(),
          'description': description.trim(),
          'image': image,
          'price': price,
          'type': type,
          'isInStock': isInStock,
        },
      );
    } on FirebaseException catch (e) {
      throw Exception(FirebaseExceptionMessages.getFirestoreMessage(e));
    }
  }

  Future<void> deleteProduct(String docId) async {
    try {
      await _firebaseService.deleteDocument(
        collection: 'products',
        docId: docId,
      );
    } on FirebaseException catch (e) {
      throw Exception(FirebaseExceptionMessages.getFirestoreMessage(e));
    }
  }
}
