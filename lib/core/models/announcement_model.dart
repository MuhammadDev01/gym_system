import 'package:cloud_firestore/cloud_firestore.dart';

class AlertModel {
  final String id;
  final String message;
  final DateTime createdAt;
  final DateTime expiresAt;

  AlertModel({
    required this.id,
    required this.message,
    required this.createdAt,
    required this.expiresAt,
  });

  factory AlertModel.fromJson(Map<String, dynamic> json, String docId) {
    return AlertModel(
      id: docId,
      message: json['message'] as String? ?? '',
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      expiresAt: (json['expiresAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
