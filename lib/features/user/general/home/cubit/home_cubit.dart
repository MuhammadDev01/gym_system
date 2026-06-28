import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/core/constants/app_constants.dart';
import 'package:gym_management_app/core/service/local/local_cache_service.dart';
import 'package:gym_management_app/features/alerts/data/alert_repo.dart';
import 'package:gym_management_app/features/members/data/members_repo.dart';
import 'package:gym_management_app/features/user/general/home/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(MemberRepo memberRepo, AlertRepo alertRepo)
    : _alertRepo = alertRepo,
      _memberRepo = memberRepo,
      super(HomeInitial()) {
    if (data == null) {
      _init();
    }
  }
  final MemberRepo? _memberRepo;
  final AlertRepo? _alertRepo;

  Timer? _timer;
  HomeLoaded? data;
  void _init() async {
    emit(HomeLoading());
    try {
      await _loadData();
      if (isClosed) return;
      _timer = Timer.periodic(const Duration(seconds: 30), (_) async {
        try {
          await _loadData();
        } catch (_) {}
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

    final member = await _memberRepo?.getMemberByPhone(phone);
    if (isClosed) return;
    if (member == null) {
      emit(HomeError('لم يتم العثور على المشترك'));
      return;
    }

    final allAlerts = await _alertRepo?.getAllAlerts();
    if (isClosed) return;
    final alerts = allAlerts?.where((a) => !a.isExpired).toList();

    final remainingDays = _calcRemainingDays(member.subscriptionEnd);

    emit(
      HomeLoaded(member: member, alerts: alerts!, remainingDays: remainingDays),
    );
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
      if (isClosed) return;
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
