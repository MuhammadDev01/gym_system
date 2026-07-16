import 'package:flutter/material.dart';

@immutable
sealed class PricesState {}

final class PricesLoaded extends PricesState {
  final int gym;
  final int fitness;
  final int private;

  PricesLoaded({
    required this.gym,
    required this.fitness,
    required this.private,
  });
}
