import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/core/constants/app_constants.dart';
import 'package:gym_management_app/core/service/local/local_cache_service.dart';
import 'package:gym_management_app/features/members/data/member_model.dart';
import 'package:gym_management_app/features/members/data/members_repo.dart';
import 'package:gym_management_app/features/user/subscription/cubit/subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  SubscriptionCubit(MemberRepo memberRepo)
    : _memberRepo = memberRepo,
      super(SubscriptionInitial()) {
    if (_member == null) {
      loadSubscription();
    }
  }
  final MemberRepo _memberRepo;
  MemberModel? _member;
  Future<void> loadSubscription() async {
    emit(SubscriptionLoading());
    try {
      final phone = LocalCacheService.getString(AppConstants.token);
      if (phone == null || phone.isEmpty) {
        emit(SubscriptionError('لم يتم العثور على المستخدم'));
        return;
      }

      _member = await _memberRepo.getMemberByPhone(phone);
      if (isClosed) return;
      if (_member == null) {
        emit(SubscriptionError('لم يتم العثور على المشترك'));
        return;
      }

      emit(SubscriptionLoaded(member: _member!));
    } catch (e) {
      final msg = e.toString();
      emit(
        SubscriptionError(
          msg.startsWith('Exception: ') ? msg.substring(11) : msg,
        ),
      );
    }
  }
}
