import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gym_management_app/core/constants/app_constants.dart';
import 'package:gym_management_app/features/admin/members/data/member_model.dart';
import 'package:gym_management_app/features/admin/members/data/attendance_model.dart';
import 'package:gym_management_app/core/service/network/firebase_exceptions.dart';
import 'package:gym_management_app/core/service/network/firebase_service.dart';

class MemberRepo {
  MemberRepo(this._firebaseService);
  final FirebaseService _firebaseService;

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

  Future<void> updateMember({
    required String docId,
    required String name,
    required String phone,
    required String subscriptionType,
    DateTime? subscriptionStart,
    DateTime? subscriptionEnd,
  }) async {
    try {
      final data = <String, dynamic>{
        AppConstants.name: name.trim(),
        AppConstants.phone: phone.trim(),
        AppConstants.subscriptionType: subscriptionType,
      };
      if (subscriptionStart != null) {
        data[AppConstants.subscriptionStart] = Timestamp.fromDate(
          subscriptionStart,
        );
      }
      if (subscriptionEnd != null) {
        data[AppConstants.subscriptionEnd] = Timestamp.fromDate(
          subscriptionEnd,
        );
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

  Future<void> deleteMember(String docId) async {
    try {
      await _firebaseService.deleteDocument(collection: 'users', docId: docId);
    } on FirebaseException catch (e) {
      throw Exception(FirebaseExceptionMessages.getFirestoreMessage(e));
    }
  }

  Future<void> deleteAllAttendanceByUserPhone(String phone) async {
    try {
      final result = await _firebaseService.queryCollection(
        collection: 'attendance',
        field: 'userPhone',
        isEqualTo: phone.trim(),
      );
      final batch = FirebaseFirestore.instance.batch();
      for (final doc in result.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    } on FirebaseException catch (e) {
      throw Exception(FirebaseExceptionMessages.getFirestoreMessage(e));
    }
  }

  Future<void> recordAttendance({
    required String userId,
    required String userName,
    required String userPhone,
  }) async {
    try {
      final now = DateTime.now();
      final dateStr =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      await _firebaseService.addDocument(
        collection: 'attendance',
        data: {
          'userId': userId,
          'userName': userName,
          'userPhone': userPhone,
          'timestamp': Timestamp.fromDate(now),
          'date': dateStr,
        },
      );
      await _firebaseService.updateDocument(
        collection: 'users',
        docId: userId,
        data: {'lastAttendance': Timestamp.fromDate(now)},
      );
    } on FirebaseException catch (e) {
      throw Exception(FirebaseExceptionMessages.getFirestoreMessage(e));
    }
  }

  Future<bool> hasAttendedToday(String phone) async {
    try {
      final now = DateTime.now();
      final dateStr =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      final result = await _firebaseService.queryCollection(
        collection: 'attendance',
        field: 'date',
        isEqualTo: dateStr,
      );
      return result.docs.any((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return data['userPhone'] == phone.trim();
      });
    } on FirebaseException catch (e) {
      throw Exception(FirebaseExceptionMessages.getFirestoreMessage(e));
    }
  }

  Future<void> deleteAttendanceRecord(String docId) async {
    try {
      await _firebaseService.deleteDocument(
        collection: 'attendance',
        docId: docId,
      );
    } on FirebaseException catch (e) {
      throw Exception(FirebaseExceptionMessages.getFirestoreMessage(e));
    }
  }

  Future<List<AttendanceRecord>> getAttendanceByPhone(String phone) async {
    try {
      final result = await _firebaseService.queryCollection(
        collection: 'attendance',
        field: 'userPhone',
        isEqualTo: phone.trim(),
      );
      return result.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return AttendanceRecord.fromJson(data, doc.id);
      }).toList();
    } on FirebaseException catch (e) {
      throw Exception(FirebaseExceptionMessages.getFirestoreMessage(e));
    }
  }

  Future<List<AttendanceRecord>> getAllAttendance() async {
    try {
      final result = await _firebaseService.getCollection(
        collection: 'attendance',
      );
      return result.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return AttendanceRecord.fromJson(data, doc.id);
      }).toList();
    } on FirebaseException catch (e) {
      throw Exception(FirebaseExceptionMessages.getFirestoreMessage(e));
    }
  }

  Future<void> cleanupOldAttendance() async {
    try {
      final cutoff = DateTime.now().subtract(const Duration(days: 60));
      final result = await _firebaseService.queryCollectionLessThan(
        collection: 'attendance',
        field: 'timestamp',
        isLessThan: Timestamp.fromDate(cutoff),
      );
      for (final doc in result.docs) {
        await _firebaseService.deleteDocument(
          collection: 'attendance',
          docId: doc.id,
        );
      }
    } on FirebaseException catch (e) {
      throw Exception(FirebaseExceptionMessages.getFirestoreMessage(e));
    }
  }

  Future<void> markAttendance(String docId, DateTime time) async {
    try {
      await _firebaseService.updateDocument(
        collection: 'users',
        docId: docId,
        data: {'lastAttendance': Timestamp.fromDate(time)},
      );
    } on FirebaseException catch (e) {
      throw Exception(FirebaseExceptionMessages.getFirestoreMessage(e));
    }
  }

  Future<void> toggleAttendance(String docId, {required bool attended}) async {
    try {
      if (attended) {
        final now = DateTime.now();
        await _firebaseService.updateDocument(
          collection: 'users',
          docId: docId,
          data: {'lastAttendance': Timestamp.fromDate(now)},
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
