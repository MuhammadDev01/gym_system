import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gym_management_app/core/constants/app_constants.dart';
import 'package:gym_management_app/core/service/local/local_cache_service.dart';
import 'package:gym_management_app/core/service/network/firebase_exceptions.dart';
import 'package:gym_management_app/core/service/network/firebase_service.dart';

class AdminRepo {
  AdminRepo(this._firebaseService);
  final FirebaseService _firebaseService;

  Future<void> addMember({
    required String username,
    required String userPhone,
  }) async {
    try {
      final adminEmail = LocalCacheService.getString(AppConstants.adminEmail);
      final adminPassword = LocalCacheService.getString(AppConstants.adminPassword);

      final email = '${userPhone.trim()}@gmail.com';
      final password = username.trim();

      await _firebaseService.signUp(email: email, password: password);

      final uid = FirebaseAuth.instance.currentUser!.uid;

      await _firebaseService.setDocument(
        collection: 'users',
        docId: uid,
        data: {
          AppConstants.name: username.trim(),
          AppConstants.phone: userPhone.trim(),
          AppConstants.role: AppConstants.member,
          AppConstants.image: '',
          'createdAt': FieldValue.serverTimestamp(),
        },
      );

      if (adminEmail != null && adminPassword != null) {
        await _firebaseService.signIn(
          email: adminEmail,
          password: adminPassword,
        );
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(FirebaseExceptionMessages.getMessage(e));
    } on FirebaseException catch (e) {
      throw Exception('خطأ (${e.code}): ${e.message}');
    }
  }
}
