import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:gym_management_app/core/constants/app_constants.dart";
import "package:gym_management_app/core/service/local/local_cache_service.dart";
import "package:gym_management_app/core/service/network/firebase_exceptions.dart";
import "package:gym_management_app/core/service/network/firebase_service.dart";

class AuthRepo {
  AuthRepo(this._firebaseService);
  final FirebaseService _firebaseService;

  //*Register
  Future<void> addMember({
    required String username,
    required String phone,
    required String image,
    required String qrData,
  }) async {
    try {
      final docRef = await _firebaseService.addDocument(
        collection: 'users',
        data: {
          'name': username,
          'phone': phone,
          'imageBase64': image,
          'qrData': qrData,
          'createdAt': FieldValue.serverTimestamp(),
        },
      );
      String userId = docRef.id;

      await LocalCacheService.setString(AppConstants.token, userId);
      await LocalCacheService.setString(AppConstants.name, username);
      await LocalCacheService.setString(AppConstants.phone, phone);
      await LocalCacheService.setString('user_image_base64', image);
    } on FirebaseAuthException catch (e) {
      throw (FirebaseExceptionMessages.getMessage(e));
    }
  }

  //*Login
  Future<void> memberLogin({
    required String userName,
    required String userPhone,
  }) async {
    try {
      final result = await _firebaseService.queryCollection(
        collection: 'users',
        field: 'phone',
        isEqualTo: userPhone,
      );

      if (result.docs.isEmpty) {
        throw Exception('ليس لديك حساب يرجى تسجيل حساب أولًا');
      }

      final doc = result.docs.first;
      final data = doc.data() as Map<String, dynamic>;

      final storedName = data['name'] as String;

      if (storedName.trim() != userName.trim()) {
        throw Exception('الاسم خطأ');
      }

      await LocalCacheService.setString(AppConstants.token, doc.id);

      await LocalCacheService.setString(AppConstants.name, storedName);

      await LocalCacheService.setString(AppConstants.phone, userPhone);
    } catch (_) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await LocalCacheService.clear();
  }
}
