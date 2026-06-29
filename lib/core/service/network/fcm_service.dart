import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;
import 'package:gym_management_app/core/service/network/firebase_service.dart';

class FcmService {
  final FirebaseService _firebaseService;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static const String _projectId = 'gym-system-5e7e5';
  auth.ServiceAccountCredentials? _credentials;

  FcmService(this._firebaseService);

  Future<auth.ServiceAccountCredentials?> _getCredentials() async {
    if (_credentials != null) return _credentials!;
    try {
      final jsonStr = await rootBundle.loadString('assets/cloud_messages.json');
      final json = jsonDecode(jsonStr) as Map<String, dynamic>;
      _credentials = auth.ServiceAccountCredentials.fromJson(json);
      return _credentials!;
    } catch (_) {
      return null;
    }
  }

  Future<String?> _getAccessToken() async {
    final creds = await _getCredentials();
    if (creds == null) return null;
    final client = http.Client();
    try {
      final credsWithToken = await auth.obtainAccessCredentialsViaServiceAccount(
        creds,
        ['https://www.googleapis.com/auth/firebase.messaging'],
        client,
      );
      return credsWithToken.accessToken.data;
    } finally {
      client.close();
    }
  }

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
    try {
      final accessToken = await _getAccessToken();
      if (accessToken == null) return;
      final response = await http.post(
        Uri.parse(
          'https://fcm.googleapis.com/v1/projects/$_projectId/messages:send',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'message': {
            'topic': 'allMembers',
            'notification': {
              'title': title,
              'body': body,
            },
            'data': {
              'type': 'alert',
            },
          },
        }),
      );
      if (response.statusCode != 200) {
        // ignore: avoid_print
        print('FCM Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      // ignore: avoid_print
      print('FCM Exception: $e');
    }
  }
}
