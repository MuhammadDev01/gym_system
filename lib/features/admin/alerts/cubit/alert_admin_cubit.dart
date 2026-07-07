import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/features/admin/alerts/data/alert_model.dart';
import 'package:gym_management_app/features/admin/alerts/cubit/alert_admin_state.dart';
import 'package:gym_management_app/features/admin/alerts/data/alert_repo.dart';

class AlertAdminCubit extends Cubit<AlertAdminState> {
  AlertAdminCubit(this._alertRepo) : super(AlertInitial());
  final AlertRepo _alertRepo;

  @override
  Future<void> close() {
    alertController.dispose();
    editMessageController.dispose();
    return super.close();
  }

  Future<void> addAlert() async {
    emit(AlertLoadingState());
    try {
      await _alertRepo.addAlert(
        message: alertController.text.trim(),
        durationDays: alertDays,
      );
      alertController.clear();
      alertDays = 7;
      await getAlerts();
      emit(AlertAddedState());
    } catch (e) {
      final msg = e.toString();
      emit(
        AlertErrorState(
          msg.startsWith('Exception: ') ? msg.substring(11) : msg,
        ),
      );
    }
  }

  int alertDays = 7;
  final alertController = TextEditingController();

  void setAlertDays(int days) {
    alertDays = days;
    emit(AlertFormChangedState());
  }

  String alertId = '';
  final editMessageController = TextEditingController();
  int editExtendDays = 0;
  DateTime? alertStartDate;
  DateTime? alertEndDate;

  //* GET
  List<AlertModel> _alerts = [];
  Future<void> getAlerts({bool refresh = false}) async {
    try {
      if (!refresh && _alerts.isNotEmpty) {
        emit(AlertsLoaded(alerts: _alerts));
        return;
      }
      emit(AlertLoadingState());
      _alerts = await _alertRepo.getAllAlerts();
      if (isClosed) return;
      emit(AlertsLoaded(alerts: _alerts));
    } catch (e) {
      final msg = e.toString();
      emit(
        AlertErrorState(
          msg.startsWith('Exception: ') ? msg.substring(11) : msg,
        ),
      );
    }
  }

  void startEdit(AlertModel alert) {
    alertId = alert.id;
    editMessageController.text = alert.message;
    alertStartDate = alert.createdAt;
    alertEndDate = alert.expiresAt;
  }

  void setEditExtendDays(int days) {
    editExtendDays = days;
    emit(AlertFormChangedState());
  }

  //* DELETE
  Future<void> deleteAlert() async {
    emit(AlertLoadingState());
    try {
      await _alertRepo.deleteAlert(alertId);
      if (isClosed) return;
      emit(AlertDeletedState());
      await getAlerts(refresh: true);
    } catch (e) {
      final msg = e.toString();
      emit(
        AlertErrorState(
          msg.startsWith('Exception: ') ? msg.substring(11) : msg,
        ),
      );
    }
  }

  //* UPDATE
  Future<void> updateAlert() async {
    emit(AlertLoadingState());
    try {
      await _alertRepo.updateAlert(
        docId: alertId,
        message: editMessageController.text.trim(),
        extendDays: editExtendDays,
      );
      if (isClosed) return;
      alertId = '';
      editMessageController.clear();
      editExtendDays = 0;
      emit(AlertUpdatedState());
      await getAlerts(refresh: true);
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
