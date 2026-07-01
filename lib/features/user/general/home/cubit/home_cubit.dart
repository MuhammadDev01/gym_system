import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/features/alerts/data/alert_model.dart';
import 'package:gym_management_app/features/members/data/member_model.dart';
import 'package:gym_management_app/features/user/general/home/cubit/home_state.dart';
import 'package:gym_management_app/features/user/general/home/data/home_repo.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(HomeRepo homeRepo) : _homeRepo = homeRepo, super(HomeInitial());

  final HomeRepo _homeRepo;
  int? remainingDays;
  MemberModel? member;
  List<AlertModel>? alerts;
  HomeDataLoaded? data;
  void getHomeData() async {
    emit(HomeLoading());
    if (member != null && alerts != null && remainingDays != null) {
      log("message");
      emit(HomeDataLoaded());
      return;
    }
    try {
      member = await _homeRepo.getMemberDetails();
      alerts = await _homeRepo.getAlerts();
      remainingDays = _calcRemainingDays(member?.subscriptionEnd);
      log("message2");

      if (isClosed) return;
      emit(HomeDataLoaded());
    } catch (e) {
      final msg = e.toString();
      emit(HomeError(msg.startsWith('Exception: ') ? msg.substring(11) : msg));
    }
  }

  int _calcRemainingDays(DateTime? subscriptionEnd) {
    if (subscriptionEnd == null) return 0;
    final diff = subscriptionEnd.difference(DateTime.now());
    return diff.inDays < 0 ? 0 : diff.inDays;
  }
}
