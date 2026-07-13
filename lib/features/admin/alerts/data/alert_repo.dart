import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:gym_management_app/features/admin/alerts/data/alert_model.dart';
import 'package:gym_management_app/core/service/network/fcm_service.dart';
import 'package:gym_management_app/core/service/network/firebase_exceptions.dart';
import 'package:gym_management_app/core/service/network/firebase_service.dart';

class AlertRepo {
  AlertRepo(this._firebaseService);
  final FirebaseService _firebaseService;

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

  Future<void> updateAlert({
    required String docId,
    required String message,
    required Duration extendDuration,
  }) async {
    try {
      final doc = await _firebaseService.getDocument(
        collection: 'Alerts',
        docId: docId,
      );
      final data = doc.data() as Map<String, dynamic>;
      final currentExpiry = (data['expiresAt'] as Timestamp).toDate();
      final newExpiry = currentExpiry.add(extendDuration);

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

  Future<void> deleteAlert(String docId) async {
    try {
      await _firebaseService.deleteDocument(collection: 'Alerts', docId: docId);
    } on FirebaseException catch (e) {
      throw Exception(FirebaseExceptionMessages.getFirestoreMessage(e));
    }
  }

  Future<void> addAlert({
    required String message,
    required Duration duration,
  }) async {
    try {
      final now = DateTime.now();
      final expiresAt = now.add(duration);
      await _firebaseService.addDocument(
        collection: 'Alerts',
        data: {
          'message': message.trim(),
          'createdAt': Timestamp.fromDate(now),
          'expiresAt': Timestamp.fromDate(expiresAt),
        },
      );
      await GetIt.I<FcmService>().sendNotification(
        title: 'عرض لفترة محدودة',
        body: message.trim(),
      );
    } on FirebaseException catch (e) {
      throw Exception(FirebaseExceptionMessages.getFirestoreMessage(e));
    }
  }
}
