import "package:firebase_auth/firebase_auth.dart";
import "package:gym_management_app/core/constants/app_constants.dart";
import "package:gym_management_app/features/members/data/member_model.dart";
import "package:gym_management_app/core/service/local/local_cache_service.dart";
import "package:gym_management_app/core/service/network/firebase_exceptions.dart";
import "package:gym_management_app/core/service/network/firebase_service.dart";

class AuthRepo {
  AuthRepo(this._firebaseService);
  final FirebaseService _firebaseService;

  //*Member Login (name + phone)
  Future<MemberModel> memberLogin({
    required String userName,
    required String userPhone,
  }) async {
    try {
      final phone = userPhone.trim();
      final doc = await _firebaseService.getDocument(
        collection: 'users',
        docId: phone,
      );

      if (!doc.exists) {
        throw Exception('ليس لديك حساب');
      }

      final data = doc.data() as Map<String, dynamic>;
      final member = MemberModel.fromJson(data, doc.id);
      String normalize(String s) => s.trim().replaceAll(RegExp(r'\s+'), ' ');
      if (normalize(member.name) != normalize(userName)) {
        throw Exception('اسم المستخدم أو رقم الهاتف غير صحيح');
      }
      await LocalCacheService.setString(AppConstants.role, AppConstants.member);

      await LocalCacheService.setString(AppConstants.token, phone);

      return member;
    } on FirebaseException catch (e) {
      throw Exception(FirebaseExceptionMessages.getFirestoreMessage(e));
    }
  }

  //*Admin Login (email + password)
  Future<void> adminLogin({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseService.signIn(
        email: email,
        password: password,
      );
      await LocalCacheService.setString(
        AppConstants.token,
        credential.user!.uid,
      );
      await LocalCacheService.setString(AppConstants.role, AppConstants.admin);
    } on FirebaseAuthException catch (e) {
      throw Exception(FirebaseExceptionMessages.getMessage(e));
    } on FirebaseException catch (e) {
      throw Exception(FirebaseExceptionMessages.getFirestoreMessage(e));
    }
  }

  Future<void> logoutAdmin() async {
    await _firebaseService.signOut();
    await LocalCacheService.clear();
  }

  Future<void> logoutMember() async {
    await LocalCacheService.clear();
  }
}
