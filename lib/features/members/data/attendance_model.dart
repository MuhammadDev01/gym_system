import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceRecord {
  final String id;
  final String userId;
  final String userName;
  final String userPhone;
  final DateTime timestamp;
  final String date;

  AttendanceRecord({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userPhone,
    required this.timestamp,
    required this.date,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json, String docId) {
    final ts = json['timestamp'] as dynamic;
    return AttendanceRecord(
      id: docId,
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      userPhone: json['userPhone'] ?? '',
      timestamp: (ts as Timestamp?)?.toDate() ?? DateTime.now(),
      date: json['date'] ?? '',
    );
  }
}
