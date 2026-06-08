import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'root_state.dart';

class RootCubit extends Cubit<RootState> {
  RootCubit() : super(RootInitial());

  int currentIndex = 0;

  void changePage(int index) {
    currentIndex = index;

    emit(RootSuccess());
  }
}
