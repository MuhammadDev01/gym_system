import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gym_management_app/core/service/firebase_service.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  String name = '';
  String phone = '';
  File? image;
  String? imageBase64;
  String? userId;

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
      imageQuality: 80,
    );
    if (picked != null) {
      image = File(picked.path);
      imageBase64 = base64Encode(await image!.readAsBytes());
      emit(UserImagePicked());
    }
  }

  Future<void> registerUser({
    required String userName,
    required String userPhone,
  }) async {
    emit(UserLoading());

    try {
      name = userName;
      phone = userPhone;

      if (imageBase64 == null && image != null) {
        imageBase64 = base64Encode(await image!.readAsBytes());
      }

      final qrData = jsonEncode({
        'name': name,
        'phone': phone,
        'imageBase64': imageBase64 ?? '',
      });

      final docRef = await FirebaseService.addDocument(
        collection: 'users',
        data: {
          'name': name,
          'phone': phone,
          'imageBase64': imageBase64 ?? '',
          'qrData': qrData,
          'createdAt': FieldValue.serverTimestamp(),
        },
      );
      userId = docRef.id;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_token', userId!);
      await prefs.setString('user_name', name);
      await prefs.setString('user_phone', phone);
      if (imageBase64 != null) {
        await prefs.setString('user_image_base64', imageBase64!);
      }

      emit(UserRegistered());
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> loginUser({
    required String userName,
    required String userPhone,
  }) async {
    emit(UserLoading());

    try {
      final phoneResult = await FirebaseService.queryCollection(
        collection: 'users',
        field: 'phone',
        isEqualTo: userPhone,
      );

      if (phoneResult.docs.isNotEmpty) {
        final doc = phoneResult.docs.first;
        final data = doc.data() as Map<String, dynamic>;
        final storedName = data['name'] as String?;

        if (storedName != userName) {
          emit(UserLoginFieldError('name', 'الاسم الثلاثي خطأ'));
          return;
        }

        name = userName;
        phone = userPhone;
        userId = doc.id;
        imageBase64 = data['imageBase64'] as String?;

        if (imageBase64 != null && imageBase64!.isNotEmpty) {
          final bytes = base64Decode(imageBase64!);
          final dir = Directory.systemTemp;
          final tempFile = File('${dir.path}/profile_$userId.jpg');
          await tempFile.writeAsBytes(bytes);
          image = tempFile;
        }

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_token', userId!);
        await prefs.setString('user_name', name);
        await prefs.setString('user_phone', phone);
        if (imageBase64 != null) {
          await prefs.setString('user_image_base64', imageBase64!);
        }

        emit(UserRegistered());
      } else {
        final nameResult = await FirebaseService.queryCollection(
          collection: 'users',
          field: 'name',
          isEqualTo: userName,
        );

        if (nameResult.docs.isNotEmpty) {
          emit(UserLoginFieldError('phone', 'رقم الهاتف خطأ'));
        } else {
          emit(UserLoginFieldError('none', 'لا يوجد حساب بهذه البيانات'));
        }
      }
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  static Future<bool> hasCachedUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('user_token');
  }

  Future<bool> restoreFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('user_token');
    if (token == null) return false;

    userId = token;
    name = prefs.getString('user_name') ?? '';
    phone = prefs.getString('user_phone') ?? '';
    imageBase64 = prefs.getString('user_image_base64');

    if (imageBase64 != null && imageBase64!.isNotEmpty) {
      final bytes = base64Decode(imageBase64!);
      final dir = Directory.systemTemp;
      final tempFile = File('${dir.path}/profile_$userId.jpg');
      await tempFile.writeAsBytes(bytes);
      image = tempFile;
    }

    return true;
  }

  Future<void> signOut() async {
    emit(UserLoading());
    try {
      await FirebaseService.signOut();
    } catch (_) {}

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    name = '';
    phone = '';
    image = null;
    imageBase64 = null;
    userId = null;
    emit(UserInitial());
  }
}
