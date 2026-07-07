import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/core/DI/service_locator.dart';
import 'package:gym_management_app/core/constants/app_constants.dart';
import 'package:gym_management_app/core/service/local/local_cache_service.dart';
import 'package:gym_management_app/features/admin/members/data/members_repo.dart';
import 'package:gym_management_app/features/user/subscription/cubit/subscription_history_state.dart';
import 'package:gym_management_app/features/user/subscription/data/subscription_history_repo.dart';
import 'package:gym_management_app/features/user/subscription/data/subscription_history_model.dart';

class SubscriptionHistoryCubit extends Cubit<SubscriptionHistoryState> {
  SubscriptionHistoryCubit(this._repo) : super(SubscriptionHistoryInitial());

  final SubscriptionHistoryRepo _repo;
  List<SubscriptionHistoryModel>? records;
  Future<void> loadHistory() async {
    emit(SubscriptionHistoryLoading());
    try {
      final userId = LocalCacheService.getString(AppConstants.token);
      if (userId == null || userId.isEmpty) {
        emit(SubscriptionHistoryError('لم يتم العثور على المستخدم'));
        return;
      }

      final member = await getIt<MemberRepo>().getMemberByPhone(userId);
      await _repo.deleteOldRecords();
      records = await _repo.getHistoryByUser(userId);

      if (member != null &&
          member.subscriptionEnd != null &&
          member.subscriptionEnd!.isAfter(DateTime.now())) {
        final current = SubscriptionHistoryModel(
          id: 'current',
          userId: userId,
          userName: member.name,
          userPhone: member.phone,
          months: member.subscriptionMonths,
          type: member.subscriptionType.isNotEmpty
              ? member.subscriptionType
              : 'gym',
          price:
              _pricePerMonth(member.subscriptionType) *
              member.subscriptionMonths,
          startDate: member.subscriptionStart ?? DateTime.now(),
          endDate: member.subscriptionEnd!,
          createdAt: member.subscriptionStart ?? DateTime.now(),
        );
        final exists = records?.any(
          (r) =>
              r.startDate == current.startDate && r.endDate == current.endDate,
        );
        if (!exists!) {
          records?.insert(0, current);
        }
      }

      emit(SubscriptionHistoryLoaded(records: records!));
    } catch (e) {
      final msg = e.toString();
      emit(
        SubscriptionHistoryError(
          msg.startsWith('Exception: ') ? msg.substring(11) : msg,
        ),
      );
    }
  }

  int _pricePerMonth(String type) {
    switch (type) {
      case 'fitness':
        return 400;
      case 'private':
        return 500;
      default:
        return 300;
    }
  }
}
