import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gym_management_app/core/constants/app_constants.dart';
import 'package:gym_management_app/core/models/member_model.dart';
import 'package:gym_management_app/core/service/network/firebase_exceptions.dart';
import 'package:gym_management_app/core/service/network/firebase_service.dart';

class MemberRepo {
  MemberRepo(this._firebaseService);
  final FirebaseService _firebaseService;

  //* get by phone
  Future<MemberModel?> getMemberByPhone(String phone) async {
    try {
      final doc = await _firebaseService.getDocument(
        collection: 'users',
        docId: phone.trim(),
      );
      if (!doc.exists) return null;
      final data = doc.data() as Map<String, dynamic>;
      return MemberModel.fromJson(data, doc.id);
    } on FirebaseException catch (e) {
      throw Exception(FirebaseExceptionMessages.getFirestoreMessage(e));
    }
  }

  //* get All Members
  Future<List<MemberModel>> getAllMembers() async {
    try {
      final result = await _firebaseService.queryCollection(
        collection: 'users',
        field: AppConstants.role,
        isEqualTo: AppConstants.member,
      );
      return result.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return MemberModel.fromJson(data, doc.id);
      }).toList();
    } on FirebaseException catch (e) {
      throw Exception(FirebaseExceptionMessages.getFirestoreMessage(e));
    }
  }

  //* Add
  Future<void> updateMember({
    required String docId,
    required String name,
    required String phone,
    required int subscriptionMonths,
    required String subscriptionType,
    DateTime? subscriptionEnd,
  }) async {
    try {
      final data = <String, dynamic>{
        AppConstants.name: name.trim(),
        AppConstants.phone: phone.trim(),
        AppConstants.subscriptionMonths: subscriptionMonths,
        AppConstants.subscriptionType: subscriptionType,
      };
      if (subscriptionEnd != null) {
        data[AppConstants.subscriptionEnd] = Timestamp.fromDate(subscriptionEnd);
      }
      await _firebaseService.updateDocument(
        collection: 'users',
        docId: docId,
        data: data,
      );
    } on FirebaseException catch (e) {
      throw Exception(FirebaseExceptionMessages.getFirestoreMessage(e));
    }
  }

  Future<void> toggleAttendance(String docId, {required bool attended}) async {
    try {
      if (attended) {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        await _firebaseService.updateDocument(
          collection: 'users',
          docId: docId,
          data: {'lastAttendance': Timestamp.fromDate(today)},
        );
      } else {
        await _firebaseService.updateDocument(
          collection: 'users',
          docId: docId,
          data: {'lastAttendance': FieldValue.delete()},
        );
      }
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
      final now = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      );
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
