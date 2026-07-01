import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gym_management_app/core/DI/service_locator.dart';
import 'package:gym_management_app/features/members/data/member_model.dart';
import 'package:gym_management_app/features/members/data/members_repo.dart';
part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());
  String? imageBase64;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (isClosed) return;

    if (image != null) {
      final bytes = await File(image.path).readAsBytes();
      if (isClosed) return;
      imageBase64 = base64Encode(bytes);
      emit(ProfileLoaded());
    }
  }

  Future<void> updateProfileImage(MemberModel member) async {
    emit(ProfileLoading());
    try {
      await getIt<MemberRepo>().updateMemberProfile(
        docId: member.id,
        image: imageBase64,
      );
      if (isClosed) return;
      emit(ProfileUpdated(imageBase64: imageBase64));
    } catch (e) {
      final msg = e.toString();
      emit(
        ProfileError(msg.startsWith('Exception: ') ? msg.substring(11) : msg),
      );
    }
  }
}
