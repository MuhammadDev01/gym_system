import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gym_management_app/core/constants/app_constants.dart';
import 'package:gym_management_app/core/models/user_model.dart';
import 'package:gym_management_app/core/service/network/firebase_exceptions.dart';
import 'package:gym_management_app/core/service/network/firebase_service.dart';

class AdminRepo {
  AdminRepo(this._firebaseService);
  final FirebaseService _firebaseService;

  Future<List<UserModel>> getMembers() async {
    try {
      final result = await _firebaseService.queryCollection(
        collection: 'users',
        field: AppConstants.role,
        isEqualTo: AppConstants.member,
      );
      return result.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return UserModel.fromJson(data, doc.id);
      }).toList();
    } on FirebaseException catch (e) {
      throw Exception(FirebaseExceptionMessages.getFirestoreMessage(e));
    }
  }

  Future<void> addMember({
    required String username,
    required String userPhone,
    required int subscriptionMonths,
    required String subscriptionType,
  }) async {
    try {
      final now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
      final end = DateTime(now.year, now.month + subscriptionMonths, now.day);

      await _firebaseService.setDocument(
        collection: 'users',
        docId: userPhone,
        data: {
          AppConstants.name: username.trim(),
          AppConstants.phone: userPhone.trim(),
          AppConstants.role: AppConstants.member,
          AppConstants.image: '',
          AppConstants.subscriptionMonths: subscriptionMonths,
          AppConstants.subscriptionType: subscriptionType,
          AppConstants.subscriptionStart: Timestamp.fromDate(now),
          AppConstants.subscriptionEnd: Timestamp.fromDate(end),
          'createdAt': FieldValue.serverTimestamp(),
        },
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(FirebaseExceptionMessages.getMessage(e));
    } on FirebaseException catch (e) {
      throw Exception('خطأ (${e.code}): ${e.message}');
    }
  }
}
