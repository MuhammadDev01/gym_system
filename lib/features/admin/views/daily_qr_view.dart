import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:gym_management_app/core/components/app_background.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/glass_appbar.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';

class DailyQrView extends StatefulWidget {
  const DailyQrView({super.key});

  @override
  State<DailyQrView> createState() => _DailyQrViewState();
}

class _DailyQrViewState extends State<DailyQrView> {
  late Timer _timer;
  String _dateStr = '';

  @override
  void initState() {
    super.initState();
    _updateDate();
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day + 1);
    _timer = Timer.periodic(
      Duration(seconds: midnight.difference(now).inSeconds),
      (_) => _updateDate(),
    );
  }

  void _updateDate() {
    final now = DateTime.now();
    setState(() {
      _dateStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final qrData = 'attendance:$_dateStr';

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: GlassAppBar(title: 'باركود تسجيل الحضور'),
        body: Center(
          child: GlassWidget(
            borderRaduis: 24,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CustomText(text: 'قم بمسح الباركود لتسجيل الحضور', fontSize: 16),
                const Gap(20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: QrImageView(
                    data: qrData,
                    version: QrVersions.auto,
                    size: 250,
                    eyeStyle: const QrEyeStyle(
                      eyeShape: QrEyeShape.square,
                      color: Colors.black,
                    ),
                    dataModuleStyle: const QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.square,
                      color: Colors.black,
                    ),
                  ),
                ),
                const Gap(16),
                CustomText(text: 'تاريخ اليوم: $_dateStr', fontSize: 14, color: AppColors.gray),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
