import 'package:firebase_auth/firebase_auth.dart';

class FirebaseExceptionMessages {
  static String getMessage(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'user-not-found':
        return 'ليس لديك حساب';
      case 'wrong-password':
        return 'اسم المستخدم أو رقم الهاتف غير صحيح';
      case 'invalid-credential':
        return 'اسم المستخدم أو رقم الهاتف غير صحيح';
      case 'email-already-in-use':
        return 'رقم الهاتف مستخدم بالفعل';
      case 'weak-password':
        return 'كلمة المرور ضعيفة جداً';
      case 'invalid-email':
        return 'رقم الهاتف غير صالح';
      case 'too-many-requests':
        return 'طلبات كثيرة جداً، حاول لاحقاً';
      case 'user-disabled':
        return 'هذا الحساب معطل';
      case 'network-request-failed':
        return 'خطأ في الاتصال، تحقق من الإنترنت';
      default:
        return exception.message.toString();
    }
  }

  static String getFirestoreMessage(FirebaseException exception) {
    switch (exception.code) {
      case 'permission-denied':
        return 'ليس لديك صلاحية للقيام بهذه العملية';
      case 'unauthenticated':
        return 'غير مصرح لك، يرجى تسجيل الدخول أولاً';
      case 'not-found':
        return 'البيانات المطلوبة غير موجودة';
      case 'already-exists':
        return 'هذه البيانات موجودة بالفعل';
      case 'aborted':
        return 'تم إلغاء العملية، حاول مرة أخرى';
      case 'invalid-argument':
        return 'البيانات المدخلة غير صالحة';
      case 'deadline-exceeded':
        return 'انتهت مهلة الاتصال، حاول مرة أخرى';
      case 'internal':
        return 'خطأ داخلي في الخادم، حاول لاحقاً';
      case 'unavailable':
        return 'الخدمة غير متاحة حالياً، حاول لاحقاً';
      case 'resource-exhausted':
        return 'تم تجاوز الحد المسموح، حاول لاحقاً';
      default:
        return exception.message.toString();
    }
  }
}
