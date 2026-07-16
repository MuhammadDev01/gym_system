import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_management_app/core/constants/app_constants.dart';

class SubscriptionHistoryModel {
  final String id;
  final String userId;
  final String userName;
  final String userPhone;
  final int months;
  final String type;
  final int price;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;

  SubscriptionHistoryModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userPhone,
    required this.months,
    required this.type,
    required this.price,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
  });

  String get planLabel {
    switch (type) {
      case AppConstants.fitness:
        return 'باقة الفتنس - $months شهر';
      case AppConstants.private:
        return 'باقة برايفت - $months شهر';
      default:
        return 'باقة الجيم - $months شهر';
    }
  }

  String get typeLabel {
    switch (type) {
      case AppConstants.fitness:
        return 'فتنس';
      case AppConstants.private:
        return 'برايفت';
      default:
        return 'جيم';
    }
  }

  factory SubscriptionHistoryModel.fromJson(
    Map<String, dynamic> json,
    String docId,
  ) {
    return SubscriptionHistoryModel(
      id: docId,
      userId: json['userId'] as String? ?? '',
      userName: json['userName'] as String? ?? '',
      userPhone: json['userPhone'] as String? ?? '',
      months: json['months'] as int? ?? 0,
      type: json['type'] as String? ?? 'gym',
      price: json['price'] as int? ?? 0,
      startDate: (json['startDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      endDate: (json['endDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'userPhone': userPhone,
      'months': months,
      'type': type,
      'price': price,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
