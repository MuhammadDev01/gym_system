import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'gerenal_state.dart';

class GerenalCubit extends Cubit<GerenalState> {
  GerenalCubit() : super(GerenalInitial());

  int currentIndex = 0;

  void changePage(int index) {
    currentIndex = index;

    emit(GerenalSuccess());
  }
}
