import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:gym_management_app/core/components/app_background.dart';
import 'package:gym_management_app/core/components/custom_button.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/glass_appbar.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/constants/app_constants.dart';
import 'package:gym_management_app/core/helper/app_snackbar.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/admin/members/cubit/member_cubit.dart';
import 'package:gym_management_app/features/admin/members/cubit/member_state.dart';
import 'package:gym_management_app/features/admin/members/data/member_model.dart';

class ScanMemberView extends StatefulWidget {
  const ScanMemberView({super.key});

  @override
  State<ScanMemberView> createState() => _ScanMemberViewState();
}

class _ScanMemberViewState extends State<ScanMemberView> {
  final _scannerController = MobileScannerController();
  bool _processing = false;

  @override
  void initState() {
    super.initState();
    context.read<MemberCubit>().getAllMembers();
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_processing) return;
    final barcode = capture.barcodes.firstOrNull;
    final phone = barcode?.rawValue;
    if (phone == null || phone.isEmpty) return;

    _processing = true;
    _scannerController.stop();
    context.read<MemberCubit>().lookupMemberByPhone(phone);
  }

  void _showMemberDialog(MemberModel member) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: context.read<MemberCubit>(),
          child: _MemberConfirmDialog(member: member),
        );
      },
    ).then((_) {
      if (mounted) {
        _processing = false;
        _scannerController.start();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: GlassAppBar(title: 'تسجيل الحضور'),
        body: Column(
          children: [
            Expanded(
              child: BlocConsumer<MemberCubit, MemberState>(
                listener: (_, state) {
                  if (state is MemberFoundState) {
                    _showMemberDialog(state.member);
                  } else if (state is MemberScannedState) {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                    appSnackbar(
                      context,
                      'تم تسجيل الحضور بنجاح',
                      color: AppColors.success,
                    );
                    _processing = false;
                    _scannerController.start();
                  } else if (state is MemberNotFoundState ||
                      state is MemberErrorState) {
                    final msg = state is MemberNotFoundState
                        ? state.message
                        : (state as MemberErrorState).message;
                    appSnackbar(context, msg);
                    _processing = false;
                    _scannerController.start();
                  }
                },
                builder: (_, state) {
                  return Column(
                    children: [
                      Expanded(
                        child: MobileScanner(
                          controller: _scannerController,
                          onDetect: _onDetect,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(24),
                        child: const CustomText(
                          text: 'قم بتوجيه الكاميرا نحو QR code الخاص بالمشترك',
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MemberConfirmDialog extends StatelessWidget {
  final MemberModel member;
  const _MemberConfirmDialog({required this.member});

  @override
  Widget build(BuildContext context) {
    final isExpired =
        member.subscriptionEnd != null &&
        DateTime.now().isAfter(member.subscriptionEnd!);

    return BlocListener<MemberCubit, MemberState>(
      listenWhen: (_, next) =>
          next is MemberScannedState || next is MemberErrorState,
      listener: (_, state) {
        if (state is MemberScannedState) {
          Navigator.of(context).pop();
        } else if (state is MemberErrorState) {
          appSnackbar(context, state.message);
        }
      },
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: GlassWidget(
          padding: const EdgeInsets.all(24),
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(text: member.name, fontSize: 22),
              const Gap(8),
              CustomText(
                text: member.phone,
                fontSize: 16,
                color: AppColors.gold,
              ),
              const Gap(16),
              Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 4,
                children: [
                  const CustomText(
                    text: 'نوع الاشتراك:',
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                  CustomText(
                    text: _typeLabel(member.subscriptionType),
                    fontSize: 14,
                  ),
                  const CustomText(text: '|', color: AppColors.gold),
                  const CustomText(
                    text: 'تاريخ الانتهاء:',
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                  CustomText(
                    text: member.subscriptionEnd != null
                        ? (isExpired
                              ? 'منتهي'
                              : '${member.subscriptionEnd!.year}/${member.subscriptionEnd!.month}/${member.subscriptionEnd!.day}')
                        : 'غير محدد',
                    fontSize: 14,
                    color: isExpired ? AppColors.snackError : Colors.white,
                  ),
                ],
              ),
              const Gap(24),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'إلغاء',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: CustomButton(
                      text: 'تسجيل الحضور',
                      onPressed: () {
                        context.read<MemberCubit>().markAttendanceWithTime(
                          member,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _typeLabel(String type) {
  switch (type) {
    case AppConstants.fitness:
      return 'فتنس';
    case AppConstants.gym:
      return 'جيم';
    case AppConstants.private:
      return 'برايفت';
    default:
      return type;
  }
}
