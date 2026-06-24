import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:gym_management_app/core/components/app_background.dart';
import 'package:gym_management_app/core/components/custom_button.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/glass_appbar.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/constants/app_constants.dart';
import 'package:gym_management_app/core/helper/app_snackbar.dart';
import 'package:gym_management_app/core/service/local/local_cache_service.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/members/cubit/member_cubit.dart';
import 'package:gym_management_app/features/members/cubit/member_state.dart';
import 'package:gym_management_app/features/user/general/home/cubit/home_cubit.dart';

class FailedTraining extends StatelessWidget {
  const FailedTraining({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: AlignmentGeometry.topStart,
          child: const CustomText(
            text: 'لم يتم تسجيل حضورك اليوم',
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
        const Gap(16),
        GlassWidget(
          padding: EdgeInsets.all(6),
          child: Row(
            children: [
              Icon(Icons.qr_code_scanner, color: AppColors.gold),
              const Gap(10),
              const Expanded(
                child: CustomText(text: 'سجل حضورك وابدأ التمرين'),
              ),
              const Gap(10),
              CustomButton(
                icon: FaIcon(FontAwesomeIcons.expand, size: 18),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const _MemberScannerPage(),
                      fullscreenDialog: true,
                    ),
                  );
                },
                text: 'مسح الكود',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MemberScannerPage extends StatefulWidget {
  const _MemberScannerPage();

  @override
  State<_MemberScannerPage> createState() => _MemberScannerPageState();
}

class _MemberScannerPageState extends State<_MemberScannerPage> {
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
    final raw = barcode?.rawValue;
    if (raw == null || raw.isEmpty) return;

    _processing = true;
    _scannerController.stop();

    if (!raw.startsWith('attendance:')) {
      appSnackbar(context, 'رمز غير صالح');
      _resetScanner();
      return;
    }

    final dateStr = raw.substring(11);
    final now = DateTime.now();
    final today =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    if (dateStr != today) {
      appSnackbar(context, 'هذا الكود غير صالح لليوم');
      _resetScanner();
      return;
    }

    final phone = LocalCacheService.getString(AppConstants.token);
    if (phone == null || phone.isEmpty) {
      appSnackbar(context, 'لم يتم العثور على بيانات المستخدم');
      Navigator.of(context).pop();
      return;
    }

    context.read<MemberCubit>().markAttendanceByPhone(phone);
  }

  void _resetScanner() {
    _processing = false;
    _scannerController.start();
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: GlassAppBar(title: 'مسح الكود'),
        body: BlocConsumer<MemberCubit, MemberState>(
          listener: (_, state) {
            if (state is MemberAttendanceMarked) {
              appSnackbar(
                context,
                'تم تسجيل حضورك بنجاح',
                color: AppColors.success,
              );
              context.read<HomeCubit>().reload();
              Navigator.of(context).pop();
            } else if (state is MemberErrorState) {
              appSnackbar(context, state.message);
              _resetScanner();
            }
          },
          builder: (_, _) => Column(
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
                  text: 'قم بتوجيه الكاميرا نحو QR code الخاص بالتسجيل',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
