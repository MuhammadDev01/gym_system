import 'package:flutter/material.dart';

extension NavigatorExtension on BuildContext {
  /// Push a named route
  Future<dynamic> pushNamed(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamed(routeName, arguments: arguments);
  }

  /// Push and replace the current route
  Future<dynamic> pushReplacementNamed(String routeName, {Object? arguments}) {
    return Navigator.of(
      this,
    ).pushReplacementNamed(routeName, arguments: arguments);
  }

  /// Push and remove all previous routes
  Future<dynamic> pushNamedAndRemoveUntil(
    String routeName,
    RoutePredicate predicate, {
    Object? arguments,
  }) {
    return Navigator.of(
      this,
    ).pushNamedAndRemoveUntil(routeName, predicate, arguments: arguments);
  }

  /// Pop the current route
  void pop<T extends Object?>([T? result]) {
    Navigator.of(this).pop<T>(result);
  }

  /// Pop until a specific route
  void popUntil(RoutePredicate predicate) {
    Navigator.of(this).popUntil(predicate);
  }

  /// Check if can pop
  bool canPop() {
    return Navigator.of(this).canPop();
  }

  /// Push a widget as a new route
  Future<dynamic> push(Route route) {
    return Navigator.of(this).push(route);
  }

  /// Push and replace current route with a widget
  Future<dynamic> pushReplacement(Route route) {
    return Navigator.of(this).pushReplacement(route);
  }

  /// Pop all routes and push a new one
  Future<dynamic> pushAndRemoveUntil(Route route, RoutePredicate predicate) {
    return Navigator.of(this).pushAndRemoveUntil(route, predicate);
  }

  /// Maybepop to handle system back button
  Future<bool> maybePop<T extends Object?>([T? result]) {
    return Navigator.of(this).maybePop<T>(result);
  }
}
