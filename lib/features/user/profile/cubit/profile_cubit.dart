import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gym_management_app/core/constants/app_constants.dart';
import 'package:gym_management_app/core/DI/service_locator.dart';
import 'package:gym_management_app/core/service/local/local_cache_service.dart';
import 'package:gym_management_app/features/members/data/member_model.dart';
import 'package:gym_management_app/features/members/data/members_repo.dart';
part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial()) {
    _init();
  }

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  String? imageBase64;
  MemberModel? _member;

  Future<void> _init() async {
    emit(ProfileLoading());
    try {
      final phone = LocalCacheService.getString(AppConstants.token);
      if (phone == null || phone.isEmpty) {
        emit(ProfileError('لم يتم العثور على المستخدم'));
        return;
      }
      final member = await getIt<MemberRepo>().getMemberByPhone(phone);
      if (member == null) {
        emit(ProfileError('لم يتم العثور على المشترك'));
        return;
      }
      _member = member;
      nameController.text = member.name;
      phoneController.text = member.phone;
      imageBase64 = member.image.isNotEmpty ? member.image : null;
      emit(ProfileLoaded(member: member));
    } catch (e) {
      final msg = e.toString();
      emit(
        ProfileError(msg.startsWith('Exception: ') ? msg.substring(11) : msg),
      );
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) {
      final bytes = await File(image.path).readAsBytes();
      imageBase64 = base64Encode(bytes);
      emit(ProfileLoaded(member: _member!));
    }
  }

  Future<void> updateProfile() async {
    if (_member == null) return;
    emit(ProfileLoading());
    try {
      await getIt<MemberRepo>().updateMemberProfile(
        docId: _member!.id,
        name: nameController.text.trim(),
        image: imageBase64,
      );
      _member = _member!.copyWith(
        name: nameController.text.trim(),
        image: imageBase64,
      );
      emit(ProfileUpdated());
    } catch (e) {
      final msg = e.toString();
      emit(
        ProfileError(msg.startsWith('Exception: ') ? msg.substring(11) : msg),
      );
    }
  }

  @override
  Future<void> close() {
    nameController.dispose();
    phoneController.dispose();
    return super.close();
  }
}
