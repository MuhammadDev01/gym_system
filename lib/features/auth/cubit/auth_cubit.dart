import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/core/service/local/image_picker_service.dart';
import 'package:gym_management_app/core/service/local/qr_service.dart';
import 'package:gym_management_app/features/auth/data/auth_repo.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._imagePickerService, this._authRepo, this._qrService)
    : super(AuthInitial());
  final ImagePickerService _imagePickerService;
  final AuthRepo _authRepo;
  final QrService _qrService;
  bool login = true;
  String? image;
  bool _isPicking = false;
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  @override
  Future<void> close() {
    nameController.dispose();
    phoneController.dispose();
    return super.close();
  }

  void changeField() {
    nameController.clear();
    phoneController.clear();
    login = !login;
    emit(AuthChangeFieldState());
  }

  //pick-image
  Future<void> pickImage() async {
    if (_isPicking) return;
    _isPicking = true;

    try {
      final picked = await _imagePickerService.pickImageFromGallery();
      emit(LoadingPickState());
      if (picked != null) {
        image = await compute(_encodeImage, picked.path);
      }
      emit(ImagePickedState());
    } finally {
      _isPicking = false;
    }
  }

  //register
  Future<void> memeberRegister() async {
    emit(AuthLoadingState());

    try {
      final data = await _qrService.createQR(
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
        image: image!,
      );
      await _authRepo.addMember(
        username: nameController.text.trim(),
        phone: phoneController.text.trim(),
        qrData: data,
        image: image!,
      );
      emit(AuthSccessState());
    } catch (e) {
      emit(AuthErrorState(_formatError(e)));
    }
  }

  Future<void> memberLogin() async {
    emit(AuthLoadingState());
    try {
      await _authRepo.memberLogin(
        userName: nameController.text.trim(),
        userPhone: phoneController.text.trim(),
      );
      emit(AuthSccessState());
    } catch (e) {
      emit(AuthErrorState(_formatError(e)));
    }
  }

  Future<void> logout() async {
    emit(AuthLoadingState());

    await _authRepo.logout();

    emit(AuthLogoutedState());
  }

  String _formatError(Object e) {
    final msg = e.toString();
    return msg.startsWith('Exception: ') ? msg.substring(11) : msg;
  }
}

String _encodeImage(String path) => base64Encode(File(path).readAsBytesSync());
