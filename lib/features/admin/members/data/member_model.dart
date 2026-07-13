import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_management_app/core/constants/app_constants.dart';

class MemberModel {
  final String id;
  final String name;
  final String phone;
  final String role;
  final int subscriptionMonths;
  final String subscriptionType;
  final DateTime? subscriptionStart;
  final DateTime? subscriptionEnd;
  final DateTime? lastAttendance;
  final DateTime? createdAt;

  MemberModel({
    required this.id,
    required this.name,
    required this.phone,
    this.role = AppConstants.member,
    this.subscriptionMonths = 0,
    this.subscriptionType = '',
    this.subscriptionStart,
    this.subscriptionEnd,
    this.lastAttendance,
    this.createdAt,
  });

  bool get attendedToday {
    if (lastAttendance == null) return false;
    final now = DateTime.now();
    return lastAttendance!.day == now.day &&
        lastAttendance!.month == now.month &&
        lastAttendance!.year == now.year;
  }

  factory MemberModel.fromJson(Map<String, dynamic> json, String docId) {
    return MemberModel(
      id: docId,
      name: json[AppConstants.name] as String? ?? '',
      phone: json[AppConstants.phone] as String? ?? '',
      role: json[AppConstants.role] as String? ?? AppConstants.member,
      subscriptionMonths: json[AppConstants.subscriptionMonths] as int? ?? 0,
      subscriptionType: json[AppConstants.subscriptionType] as String? ?? '',
      subscriptionStart: (json[AppConstants.subscriptionStart] as Timestamp?)
          ?.toDate(),
      subscriptionEnd: (json[AppConstants.subscriptionEnd] as Timestamp?)
          ?.toDate(),
      lastAttendance: (json['lastAttendance'] as Timestamp?)?.toDate(),
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      AppConstants.name: name,
      AppConstants.phone: phone,
      AppConstants.role: role,
      AppConstants.subscriptionMonths: subscriptionMonths,
      AppConstants.subscriptionType: subscriptionType,
      if (subscriptionStart != null)
        AppConstants.subscriptionStart: Timestamp.fromDate(subscriptionStart!),
      if (subscriptionEnd != null)
        AppConstants.subscriptionEnd: Timestamp.fromDate(subscriptionEnd!),
      if (lastAttendance != null)
        'lastAttendance': Timestamp.fromDate(lastAttendance!),
      if (createdAt != null) 'createdAt': Timestamp.fromDate(createdAt!),
    };
  }

  bool get isAdmin => role == AppConstants.admin;

  MemberModel copyWith({
    String? name,
    String? phone,
    int? subscriptionMonths,
    String? subscriptionType,
    DateTime? subscriptionStart,
    DateTime? subscriptionEnd,
    DateTime? lastAttendance,
  }) {
    return MemberModel(
      id: id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      role: role,
      subscriptionMonths: subscriptionMonths ?? this.subscriptionMonths,
      subscriptionType: subscriptionType ?? this.subscriptionType,
      subscriptionStart: subscriptionStart ?? this.subscriptionStart,
      subscriptionEnd: subscriptionEnd ?? this.subscriptionEnd,
      lastAttendance: lastAttendance ?? this.lastAttendance,
      createdAt: createdAt,
    );
  }
}
