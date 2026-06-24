import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/core/constants/app_constants.dart';
import 'package:gym_management_app/core/service/local/local_cache_service.dart';
import 'package:gym_management_app/features/alerts/data/alert_repo.dart';
import 'package:gym_management_app/features/members/data/members_repo.dart';
import 'package:gym_management_app/features/user/general/home/cubit/home_state.dart';
import 'package:gym_management_app/core/DI/service_locator.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial()) {
    _init();
  }

  Timer? _timer;

  void _init() async {
    emit(HomeLoading());
    try {
      await _loadData();
      _timer = Timer.periodic(const Duration(minutes: 1), (_) {
        if (state is HomeLoaded) {
          final loaded = state as HomeLoaded;
          final days = _calcRemainingDays(loaded.member.subscriptionEnd);
          emit(HomeLoaded(
            member: loaded.member,
            alerts: loaded.alerts,
            remainingDays: days,
          ));
        }
      });
    } catch (e) {
      final msg = e.toString();
      emit(HomeError(msg.startsWith('Exception: ') ? msg.substring(11) : msg));
    }
  }

  Future<void> _loadData() async {
    final phone = LocalCacheService.getString(AppConstants.token);
    if (phone == null || phone.isEmpty) {
      emit(HomeError('لم يتم العثور على بيانات المستخدم'));
      return;
    }

    final memberRepo = getIt<MemberRepo>();
    final member = await memberRepo.getMemberByPhone(phone);

    if (member == null) {
      emit(HomeError('لم يتم العثور على المشترك'));
      return;
    }

    final alertRepo = getIt<AlertRepo>();
    final allAlerts = await alertRepo.getAllAlerts();
    final alerts = allAlerts.where((a) => !a.isExpired).toList();

    final remainingDays = _calcRemainingDays(member.subscriptionEnd);

    emit(HomeLoaded(
      member: member,
      alerts: alerts,
      remainingDays: remainingDays,
    ));
  }

  int _calcRemainingDays(DateTime? subscriptionEnd) {
    if (subscriptionEnd == null) return 0;
    final diff = subscriptionEnd.difference(DateTime.now());
    return diff.inDays < 0 ? 0 : diff.inDays;
  }

  Future<void> reload() async {
    emit(HomeLoading());
    try {
      await _loadData();
    } catch (e) {
      final msg = e.toString();
      emit(HomeError(msg.startsWith('Exception: ') ? msg.substring(11) : msg));
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
