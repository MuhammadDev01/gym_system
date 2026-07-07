import 'package:gym_management_app/core/DI/service_locator.dart';
import 'package:gym_management_app/core/constants/app_constants.dart';
import 'package:gym_management_app/core/service/local/local_cache_service.dart';
import 'package:gym_management_app/features/admin/alerts/data/alert_model.dart';
import 'package:gym_management_app/features/admin/alerts/data/alert_repo.dart';
import 'package:gym_management_app/features/admin/members/data/member_model.dart';
import 'package:gym_management_app/features/admin/members/data/members_repo.dart';

class HomeRepo {
  Future<MemberModel?> getMemberDetails() async {
    final phone = LocalCacheService.getString(AppConstants.token);
    if (phone == null || phone.isEmpty) {
      throw Exception("لم يتم العثور على المشترك");
    }
    try {
      final member = await getIt<MemberRepo>().getMemberByPhone(phone);
      return member;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<AlertModel>> getAlerts() async {
    final List<AlertModel>? allAlerts;
    try {
      allAlerts = await getIt<AlertRepo>().getAllAlerts();
      final List<AlertModel> alerts = allAlerts
          .where((a) => !a.isExpired)
          .toList();

      return alerts;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
