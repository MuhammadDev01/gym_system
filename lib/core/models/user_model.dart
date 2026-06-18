import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_management_app/core/constants/app_constants.dart';

class UserModel {
  final String id;
  final String name;
  final String phone;
  final String image;
  final String role;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    this.image = '',
    this.role = AppConstants.member,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, String docId) {
    return UserModel(
      id: docId,
      name: json[AppConstants.name] as String? ?? '',
      phone: json[AppConstants.phone] as String? ?? '',
      image: json[AppConstants.image] as String? ?? '',
      role: json[AppConstants.role] as String? ?? AppConstants.member,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      AppConstants.name: name,
      AppConstants.phone: phone,
      AppConstants.image: image,
      AppConstants.role: role,
      if (createdAt != null) 'createdAt': Timestamp.fromDate(createdAt!),
    };
  }

  bool get isAdmin => role == AppConstants.admin;

  void operator [](String other) {}
}
