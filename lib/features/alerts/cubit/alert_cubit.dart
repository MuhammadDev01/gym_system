import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/features/alerts/cubit/alert_state.dart';
import 'package:gym_management_app/features/alerts/data/alert_repo.dart';

class AlertCubit extends Cubit<AlertState> {
  AlertCubit(this._alertRepo) : super(AlertInitial());
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

  String editAlertId = '';
  final editMessageController = TextEditingController();
  int editExtendDays = 0;

  Future<void> getAlerts() async {
    emit(AlertLoadingState());
    try {
      final list = await _alertRepo.getAllAlerts();
      emit(AlertSuccessState(alerts: list));
    } catch (e) {
      final msg = e.toString();
      emit(
        AlertErrorState(
          msg.startsWith('Exception: ') ? msg.substring(11) : msg,
        ),
      );
    }
  }

  void startEdit({
    required String id,
    required String message,
    required int extendDays,
  }) {
    editAlertId = id;
    editMessageController.text = message;
    editExtendDays = extendDays;
  }

  void setEditExtendDays(int days) {
    editExtendDays = days;
    emit(AlertFormChangedState());
  }

  Future<void> updateAlert() async {
    emit(AlertLoadingState());
    try {
      await _alertRepo.updateAlert(
        docId: editAlertId,
        message: editMessageController.text.trim(),
        extendDays: editExtendDays,
      );
      editAlertId = '';
      editMessageController.clear();
      editExtendDays = 0;
      emit(AlertUpdatedState());
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
