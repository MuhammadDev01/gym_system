import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:gym_management_app/core/components/app_background.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/glass_appbar.dart';
import 'package:gym_management_app/core/helper/app_snackbar.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/members/cubit/member_cubit.dart';
import 'package:gym_management_app/features/members/cubit/member_state.dart';

class ScanMemberView extends StatefulWidget {
  const ScanMemberView({super.key});

  @override
  State<ScanMemberView> createState() => _ScanMemberViewState();
}

class _ScanMemberViewState extends State<ScanMemberView> {
  final _scannerController = MobileScannerController();
  bool _processing = false;

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
    context.read<MemberCubit>().markAttendanceByPhone(phone);
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: GlassAppBar(title: 'مسح العضو'),
        body: BlocConsumer<MemberCubit, MemberState>(
          listener: (_, state) {
            if (state is MemberAttendanceMarked) {
              appSnackbar(
                context,
                'تم تسجيل الحضور بنجاح',
                color: AppColors.success,
              );
              _processing = false;
              _scannerController.start();
            } else if (state is MemberErrorState) {
              appSnackbar(context, state.message);
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
    );
  }
}
