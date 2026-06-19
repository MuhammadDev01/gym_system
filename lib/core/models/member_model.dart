import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_management_app/core/constants/app_constants.dart';

class MemberModel {
  final String id;
  final String name;
  final String phone;
  final String image;
  final String role;
  final int subscriptionMonths;
  final String subscriptionType;
  final DateTime? subscriptionStart;
  final DateTime? subscriptionEnd;
  final DateTime? createdAt;

  MemberModel({
    required this.id,
    required this.name,
    required this.phone,
    this.image = '',
    this.role = AppConstants.member,
    this.subscriptionMonths = 0,
    this.subscriptionType = '',
    this.subscriptionStart,
    this.subscriptionEnd,
    this.createdAt,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json, String docId) {
    return MemberModel(
      id: docId,
      name: json[AppConstants.name] as String? ?? '',
      phone: json[AppConstants.phone] as String? ?? '',
      image: json[AppConstants.image] as String? ?? '',
      role: json[AppConstants.role] as String? ?? AppConstants.member,
      subscriptionMonths: json[AppConstants.subscriptionMonths] as int? ?? 0,
      subscriptionType: json[AppConstants.subscriptionType] as String? ?? '',
      subscriptionStart: (json[AppConstants.subscriptionStart] as Timestamp?)
          ?.toDate(),
      subscriptionEnd: (json[AppConstants.subscriptionEnd] as Timestamp?)
          ?.toDate(),
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      AppConstants.name: name,
      AppConstants.phone: phone,
      AppConstants.image: image,
      AppConstants.role: role,
      AppConstants.subscriptionMonths: subscriptionMonths,
      AppConstants.subscriptionType: subscriptionType,
      if (subscriptionStart != null)
        AppConstants.subscriptionStart: Timestamp.fromDate(subscriptionStart!),
      if (subscriptionEnd != null)
        AppConstants.subscriptionEnd: Timestamp.fromDate(subscriptionEnd!),
      if (createdAt != null) 'createdAt': Timestamp.fromDate(createdAt!),
    };
  }

  bool get isAdmin => role == AppConstants.admin;
}
