import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/features/alerts/data/alert_model.dart';
import 'package:gym_management_app/features/alerts/cubit/alert_user_state.dart';
import 'package:gym_management_app/features/alerts/data/alert_repo.dart';

class AlertUserCubit extends Cubit<AlertUserState> {
  AlertUserCubit(this._alertRepo) : super(AlertInitial());
  final AlertRepo _alertRepo;

  List<AlertModel> allAlerts = [];
  Future<void> getAlerts() async {
    emit(AlertLoadingState());
    try {
      allAlerts = await _alertRepo.getAllAlerts();
      emit(AlertSuccessState());
    } catch (e) {
      final msg = e.toString();
      emit(
        AlertErrorState(
          msg.startsWith('Exception: ') ? msg.substring(11) : msg,
        ),
      );
    }
  }
}
