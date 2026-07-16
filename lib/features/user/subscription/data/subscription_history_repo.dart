import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_management_app/core/service/network/firebase_exceptions.dart';
import 'package:gym_management_app/core/service/network/firebase_service.dart';
import 'package:gym_management_app/features/user/subscription/data/subscription_history_model.dart';

class SubscriptionHistoryRepo {
  SubscriptionHistoryRepo(this._firebaseService);
  final FirebaseService _firebaseService;

  static const _collection = 'subscription_history';

  Future<void> addRecord(SubscriptionHistoryModel record) async {
    try {
      await _firebaseService.addDocument(
        collection: _collection,
        data: record.toJson(),
      );
    } on FirebaseException catch (e) {
      throw Exception(FirebaseExceptionMessages.getFirestoreMessage(e));
    }
  }

  Future<void> updateRecord(SubscriptionHistoryModel record) async {
    try {
      await _firebaseService.updateDocument(
        collection: _collection,
        docId: record.id,
        data: record.toJson(),
      );
    } on FirebaseException catch (e) {
      throw Exception(FirebaseExceptionMessages.getFirestoreMessage(e));
    }
  }

  Future<List<SubscriptionHistoryModel>> getHistoryByUser(String userId) async {
    try {
      final result = await _firebaseService.queryCollection(
        collection: _collection,
        field: 'userId',
        isEqualTo: userId,
      );
      final records = result.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return SubscriptionHistoryModel.fromJson(data, doc.id);
      }).toList();
      records.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return records;
    } on FirebaseException catch (e) {
      throw Exception(FirebaseExceptionMessages.getFirestoreMessage(e));
    }
  }

  Future<List<SubscriptionHistoryModel>> getAllHistory() async {
    try {
      final result = await _firebaseService.getCollection(
        collection: _collection,
      );
      final records = result.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return SubscriptionHistoryModel.fromJson(data, doc.id);
      }).toList();
      records.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return records;
    } on FirebaseException catch (e) {
      throw Exception(FirebaseExceptionMessages.getFirestoreMessage(e));
    }
  }

  Future<void> deleteRecord(String docId) async {
    try {
      await _firebaseService.deleteDocument(
        collection: _collection,
        docId: docId,
      );
    } on FirebaseException catch (e) {
      throw Exception(FirebaseExceptionMessages.getFirestoreMessage(e));
    }
  }

  Future<void> deleteAllRecords() async {
    try {
      final result = await _firebaseService.getCollection(
        collection: _collection,
      );
      final batch = FirebaseFirestore.instance.batch();
      for (final doc in result.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    } on FirebaseException catch (e) {
      throw Exception(FirebaseExceptionMessages.getFirestoreMessage(e));
    }
  }

  Future<void> deleteOldRecords({int months = 3}) async {
    try {
      final cutoff = DateTime.now().subtract(Duration(days: months * 30));
      final result = await _firebaseService.getCollection(
        collection: _collection,
      );
      final batch = FirebaseFirestore.instance.batch();
      for (final doc in result.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final createdAt = (data['createdAt'] as Timestamp?)?.toDate();
        if (createdAt != null && createdAt.isBefore(cutoff)) {
          batch.delete(doc.reference);
        }
      }
      await batch.commit();
    } on FirebaseException catch (e) {
      throw Exception(FirebaseExceptionMessages.getFirestoreMessage(e));
    }
  }

  Future<void> deleteAllHistoryByUserId(String userId) async {
    try {
      final result = await _firebaseService.queryCollection(
        collection: _collection,
        field: 'userId',
        isEqualTo: userId.trim(),
      );
      final batch = FirebaseFirestore.instance.batch();
      for (final doc in result.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    } on FirebaseException catch (e) {
      throw Exception(FirebaseExceptionMessages.getFirestoreMessage(e));
    }
  }

  Future<void> deleteRecordsByIds(List<String> docIds) async {
    try {
      final batch = FirebaseFirestore.instance.batch();
      for (final id in docIds) {
        batch.delete(FirebaseFirestore.instance.collection(_collection).doc(id));
      }
      await batch.commit();
    } on FirebaseException catch (e) {
      throw Exception(FirebaseExceptionMessages.getFirestoreMessage(e));
    }
  }
}
