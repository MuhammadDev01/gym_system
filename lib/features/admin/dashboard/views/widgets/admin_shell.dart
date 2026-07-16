import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/core/DI/service_locator.dart';
import 'package:gym_management_app/features/admin/alerts/cubit/alert_admin_cubit.dart';
import 'package:gym_management_app/features/admin/market/cubit/market_admin_cubit.dart';
import 'package:gym_management_app/features/admin/members/cubit/member_cubit.dart';
import 'package:gym_management_app/features/user/subscription/cubit/subscription_history_cubit.dart';
import 'package:gym_management_app/features/admin/settings/cubit/prices_cubit.dart';

class AdminShell extends StatelessWidget {
  final Widget child;
  const AdminShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<MemberCubit>()..getAllMembers()),
        BlocProvider(create: (_) => getIt<AlertAdminCubit>()),
        BlocProvider(create: (_) => getIt<MarketAdminCubit>()..getProducts()),
        BlocProvider(create: (_) => getIt<SubscriptionHistoryCubit>()),
        BlocProvider(create: (_) => getIt<PricesCubit>()),
      ],
      child: child,
    );
  }
}
