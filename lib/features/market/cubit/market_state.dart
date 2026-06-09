import 'package:flutter/material.dart';

@immutable
sealed class MarketState {}

final class MarketInitial extends MarketState {}

final class MarketLoaded extends MarketState {}
