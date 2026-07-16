import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/features/user/subscription/cubit/subscription_history_state.dart';
import 'package:gym_management_app/features/user/subscription/data/subscription_history_repo.dart';
import 'package:gym_management_app/features/user/subscription/data/subscription_history_model.dart';

class SubscriptionHistoryCubit extends Cubit<SubscriptionHistoryState> {
  SubscriptionHistoryCubit(this._repo) : super(SubscriptionHistoryInitial());

  final SubscriptionHistoryRepo _repo;
  final phoneController = TextEditingController();
  final searchController = TextEditingController();
  List<SubscriptionHistoryModel>? records;

  @override
  Future<void> close() {
    phoneController.dispose();
    searchController.dispose();
    return super.close();
  }

  void init() {
    phoneController.clear();
    searchController.clear();
    emit(SubscriptionHistoryInitial());
  }

  Future<void> searchByNameOrPhone() async {
    final query = searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      emit(SubscriptionHistoryInitial());
      return;
    }
    emit(SubscriptionHistoryLoading());
    try {
      final all = await _repo.getAllHistory();
      final filtered = all.where((r) {
        return r.userName.toLowerCase().contains(query) ||
            r.userPhone.contains(query);
      }).toList();
      filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      if (isClosed) return;
      emit(SubscriptionHistoryLoaded(records: filtered));
    } catch (e) {
      final msg = e.toString();
      emit(
        SubscriptionHistoryError(
          msg.startsWith('Exception: ') ? msg.substring(11) : msg,
        ),
      );
    }
  }

  final Set<String> expandedMonths = {};

  void toggleMonthExpanded(String monthKey) {
    if (expandedMonths.contains(monthKey)) {
      expandedMonths.remove(monthKey);
    } else {
      expandedMonths.add(monthKey);
    }
    emit(SubscriptionHistorytoggled());
  }

  List<SubscriptionHistoryModel> _records = [];
  Future<void> loadAllHistory({bool refresh = false}) async {
    emit(SubscriptionHistoryLoading());
    try {
      if (_records.isNotEmpty && !refresh) {
        emit(SubscriptionHistoryLoaded(records: _records));
        return;
      }
      _records = await _repo.getAllHistory();
      if (isClosed) return;
      emit(SubscriptionHistoryLoaded(records: _records));
    } catch (e) {
      final msg = e.toString();
      emit(
        SubscriptionHistoryError(
          msg.startsWith('Exception: ') ? msg.substring(11) : msg,
        ),
      );
    }
  }

  Future<void> deleteRecord(String docId) async {
    try {
      emit(SubscriptionHistoryLoading());
      await _repo.deleteRecord(docId);
      records?.removeWhere((r) => r.id == docId);
      if (isClosed) return;
      emit(SubscriptionHistoryDeleted());
      await loadAllHistory(refresh: true);
    } catch (e) {
      final msg = e.toString();
      emit(
        SubscriptionHistoryError(
          msg.startsWith('Exception: ') ? msg.substring(11) : msg,
        ),
      );
    }
  }

  Future<void> deleteAll() async {
    emit(SubscriptionHistoryLoading());
    try {
      await _repo.deleteAllRecords();
      _records = [];
      emit(SubscriptionHistoryLoaded(records: []));
    } catch (e) {
      final msg = e.toString();
      emit(
        SubscriptionHistoryError(
          msg.startsWith('Exception: ') ? msg.substring(11) : msg,
        ),
      );
    }
  }

  Future<void> deleteRecordsByIds(List<String> docIds) async {
    try {
      await _repo.deleteRecordsByIds(docIds);
      _records.removeWhere((r) => docIds.contains(r.id));
      if (isClosed) return;
      emit(SubscriptionHistoryLoaded(records: _records));
    } catch (e) {
      final msg = e.toString();
      emit(
        SubscriptionHistoryError(
          msg.startsWith('Exception: ') ? msg.substring(11) : msg,
        ),
      );
    }
  }
}
