import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    log('┌─ Bloc: ${bloc.runtimeType}');
    log('├─ CurrentState: ${change.currentState.runtimeType}');
    log('└─ NextState: ${change.nextState.runtimeType}');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    log('❌ BlocError [${bloc.runtimeType}]: $error');
  }
}
