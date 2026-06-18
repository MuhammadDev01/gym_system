import "package:firebase_auth/firebase_auth.dart";
import "package:gym_management_app/core/constants/app_constants.dart";
import "package:gym_management_app/core/models/user_model.dart";
import "package:gym_management_app/core/service/local/local_cache_service.dart";
import "package:gym_management_app/core/service/network/firebase_exceptions.dart";
import "package:gym_management_app/core/service/network/firebase_service.dart";

class AuthRepo {
  AuthRepo(this._firebaseService);
  final FirebaseService _firebaseService;

  //*Member Login (name + phone)
  Future<UserModel> memberLogin({
    required String userName,
    required String userPhone,
  }) async {
    try {
      final email = userPhone.trim();
      final password = userName.trim();

      await _firebaseService.signIn(email: email, password: password);

      final uid = FirebaseAuth.instance.currentUser!.uid;
      final doc = await _firebaseService.getDocument(
        collection: 'users',
        docId: uid,
      );
      final UserModel data = UserModel.fromJson(
        doc.data() as Map<String, dynamic>,
        uid,
      );

      // if (data == null) {
      //   await _firebaseService.signOut();
      //   throw Exception('لم يتم العثور على البيانات');
      // }

      if (data.name != userName.trim()) {
        await _firebaseService.signOut();
        throw Exception('اسم المستخدم أو رقم الهاتف غير صحيح');
      }

      await LocalCacheService.setString(AppConstants.token, uid);

      return data;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'invalid-credential') {
        throw Exception('ليس لديك حساب');
      }
      throw Exception(FirebaseExceptionMessages.getMessage(e));
    } on FirebaseException catch (e) {
      throw Exception(FirebaseExceptionMessages.getFirestoreMessage(e));
    }
  }

  //*Admin Login (email + password)
  Future<UserCredential> adminLogin({
    required String email,
    required String password,
  }) async {
    try {
      final c = await _firebaseService.signIn(email: email, password: password);

      // final uid = FirebaseAuth.instance.currentUser!.uid;
      // final doc = await _firebaseService.getDocument(
      //   collection: 'users',
      //   docId: uid,
      // );
      //  final data = UserModel.fromJson(doc.data() as Map<String, dynamic>, uid);

      // if (data == null) {
      //   await _firebaseService.signOut();
      //   throw Exception('لم يتم العثور على بيانات الأدمن في قاعدة البيانات');
      // }

      // if (data[AppConstants.role] as String != AppConstants.admin) {
      //   await _firebaseService.signOut();
      //   throw Exception('ليس لديك صلاحية الدخول كمسؤول');
      // }

      //  await LocalCacheService.setString(AppConstants.token, uid);
      //  await LocalCacheService.setString('admin_email', email);
      // await LocalCacheService.setString('admin_password', password);

      return c;
    } on FirebaseAuthException catch (e) {
      throw Exception(FirebaseExceptionMessages.getMessage(e));
    } on FirebaseException catch (e) {
      throw Exception(FirebaseExceptionMessages.getFirestoreMessage(e));
    }
  }

  Future<void> logout() async {
    await _firebaseService.signOut();
    await LocalCacheService.clear();
  }
}
