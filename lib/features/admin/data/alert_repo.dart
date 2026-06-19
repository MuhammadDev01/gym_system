import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_management_app/core/models/announcement_model.dart';
import 'package:gym_management_app/core/service/network/firebase_exceptions.dart';
import 'package:gym_management_app/core/service/network/firebase_service.dart';

class AlertRepo {
  AlertRepo(this._firebaseService);
  final FirebaseService _firebaseService;

  //* get All
  Future<List<AlertModel>> getAllAlerts() async {
    try {
      final result = await _firebaseService.getCollection(collection: 'Alerts');
      return result.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return AlertModel.fromJson(data, doc.id);
      }).toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } on FirebaseException catch (e) {
      throw Exception(FirebaseExceptionMessages.getFirestoreMessage(e));
    }
  }

  //* update
  Future<void> updateAlert({
    required String docId,
    required String message,
    required int extendDays,
  }) async {
    try {
      final doc = await _firebaseService.getDocument(
        collection: 'Alerts',
        docId: docId,
      );
      final data = doc.data() as Map<String, dynamic>;
      final currentExpiry = (data['expiresAt'] as Timestamp).toDate();
      final newExpiry = DateTime(
        currentExpiry.year,
        currentExpiry.month,
        currentExpiry.day + extendDays,
      );

      await _firebaseService.updateDocument(
        collection: 'Alerts',
        docId: docId,
        data: {
          'message': message.trim(),
          'expiresAt': Timestamp.fromDate(newExpiry),
        },
      );
    } on FirebaseException catch (e) {
      throw Exception(FirebaseExceptionMessages.getFirestoreMessage(e));
    }
  }

  //* get active
  Stream<List<AlertModel>> getActiveAlerts() {
    return _firebaseService.streamCollection('Alerts').map((snapshot) {
      return snapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return AlertModel.fromJson(data, doc.id);
          })
          .where((a) => !a.isExpired)
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    });
  }

  //* Add
  Future<void> addAlert({
    required String message,
    required int durationDays,
  }) async {
    try {
      final now = DateTime.now();
      final expiresAt = DateTime(now.year, now.month, now.day + durationDays);
      await _firebaseService.addDocument(
        collection: 'Alerts',
        data: {
          'message': message.trim(),
          'createdAt': Timestamp.fromDate(now),
          'expiresAt': Timestamp.fromDate(expiresAt),
        },
      );
    } on FirebaseException catch (e) {
      throw Exception(FirebaseExceptionMessages.getFirestoreMessage(e));
    }
  }
}
