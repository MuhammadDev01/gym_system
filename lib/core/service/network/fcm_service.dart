import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:gym_management_app/core/constants/app_constants.dart';
import 'package:gym_management_app/core/service/network/firebase_service.dart';

class FcmService {
  final FirebaseService _firebaseService;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  FcmService(this._firebaseService);

  Future<void> initialize() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    final token = await _messaging.getToken();
    if (token != null) {
      await _subscribeToTopic(token);
    }
    _messaging.onTokenRefresh.listen((token) async {
      await _subscribeToTopic(token);
    });
  }

  Future<void> _subscribeToTopic(String token) async {
    try {
      await _messaging.subscribeToTopic('allMembers');
    } catch (_) {}
  }

  Future<void> saveToken(String userId) async {
    try {
      final token = await _messaging.getToken();
      if (token != null) {
        await _firebaseService.setDocument(
          collection: 'users',
          docId: userId,
          data: {'fcmToken': token},
        );
      }
    } catch (_) {}
  }

  Future<void> sendNotification({
    required String title,
    required String body,
  }) async {
    final serverKey = AppConstants.fcmServerKey;
    if (serverKey.isEmpty) return;

    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
        body: jsonEncode({
          'to': '/topics/allMembers',
          'notification': {
            'title': title,
            'body': body,
          },
          'data': {
            'type': 'alert',
          },
        }),
      );
    } catch (_) {}
  }
}
