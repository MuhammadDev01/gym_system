import 'package:firebase_auth/firebase_auth.dart';

class FirebaseExceptions {
  static String getAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'لا يوجد حساب بهذا البريد الإلكتروني';
      case 'wrong-password':
        return 'كلمة المرور غير صحيحة';
      case 'invalid-credential':
        return 'البريد الإلكتروني أو كلمة المرور غير صحيحة';
      case 'email-already-in-use':
        return 'هذا البريد الإلكتروني مستخدم بالفعل';
      case 'weak-password':
        return 'كلمة المرور ضعيفة جداً';
      case 'invalid-email':
        return 'البريد الإلكتروني غير صالح';
      case 'too-many-requests':
        return 'طلبات كثيرة جداً، حاول لاحقاً';
      case 'user-disabled':
        return 'هذا الحساب معطل';
      default:
        return 'حدث خطأ غير متوقع';
    }
  }
}
