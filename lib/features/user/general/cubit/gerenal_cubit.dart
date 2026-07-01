import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/features/market/views/user/market_user_view.dart';
import 'package:gym_management_app/features/user/general/home/views/home_view.dart';
import 'package:gym_management_app/features/user/profile/views/profile_view.dart';
import 'package:gym_management_app/features/user/settings/views/settings_view.dart';
import 'package:gym_management_app/features/user/subscription/views/subscription_view.dart';

part 'gerenal_state.dart';

class GerenalCubit extends Cubit<GerenalState> {
  GerenalCubit() : super(GerenalInitial());

  int currentIndex = 0;

  void changePage(int index) {
    currentIndex = index;

    emit(GerenalSuccess());
  }

  final views = const [
    HomeView(),
    SubscriptionView(),
    ProfileView(),
    MarketUserView(),
    SettingsView(),
  ];
}
