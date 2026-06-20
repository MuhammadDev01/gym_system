import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:gym_management_app/core/components/app_background.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/helper/app_snackbar.dart';
import 'package:gym_management_app/core/models/member_model.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/admin/data/members_repo.dart';

class ScanMemberView extends StatefulWidget {
  const ScanMemberView({super.key});

  @override
  State<ScanMemberView> createState() => _ScanMemberViewState();
}

class _ScanMemberViewState extends State<ScanMemberView> {
  bool _paused = false;

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_paused) return;
    final barcode = capture.barcodes.firstOrNull;
    final rawValue = barcode?.rawValue;
    if (rawValue == null || rawValue.isEmpty) return;

    _paused = true;

    String phone = rawValue;
    try {
      final json = jsonDecode(rawValue) as Map<String, dynamic>;
      phone = json['phone'] as String? ?? rawValue;
    } catch (_) {}

    try {
      final repo = GetIt.I<MemberRepo>();
      final member = await repo.getMemberByPhone(phone);
      if (!mounted) return;
      if (member != null) {
        _showMemberDialog(member);
      } else {
        appSnackbar(context, 'لم يتم العثور على مشترك بهذا الرقم');
        _resumeScanning();
      }
    } catch (e) {
      if (!mounted) return;
      appSnackbar(context, e.toString());
      _resumeScanning();
    }
  }

  void _resumeScanning() {
    _paused = false;
  }

  Future<void> _toggleAttendance(MemberModel member) async {
    try {
      final repo = GetIt.I<MemberRepo>();
      final attended = !member.attendedToday;
      await repo.toggleAttendance(member.id, attended: attended);
      if (!mounted) return;
      Navigator.pop(context);
      appSnackbar(
        context,
        attended ? 'تم تسجيل الحضور' : 'تم إلغاء الحضور',
        color: AppColors.success,
      );
    } catch (e) {
      if (!mounted) return;
      appSnackbar(context, e.toString());
    }
  }

  void _showMemberDialog(MemberModel member) {
    final typeLabel = switch (member.subscriptionType) {
      'fitness' => 'فتنس',
      'gym' => 'جيم',
      'private' => 'برايفت',
      _ => member.subscriptionType,
    };
    final endDate = member.subscriptionEnd != null
        ? '${member.subscriptionEnd!.day}/${member.subscriptionEnd!.month}/${member.subscriptionEnd!.year}'
        : '—';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: AppColors.background,
          content: GlassWidget(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.gold.withAlpha(38),
                    borderRadius: BorderRadius.circular(20),
                    image: member.image.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(member.image),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: member.image.isEmpty
                      ? Icon(Icons.person, color: AppColors.gold, size: 36)
                      : null,
                ),
                const Gap(12),
                CustomText(
                  text: member.name,
                  fontSize: 20,
                  color: AppColors.gold,
                ),
                const Gap(4),
                CustomText(
                  text: member.phone,
                  fontSize: 14,
                  color: Colors.white70,
                ),
                const Gap(16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: 'النوع:',
                      fontSize: 13,
                      color: Colors.white54,
                    ),
                    CustomText(text: typeLabel, fontSize: 13),
                  ],
                ),
                const Gap(8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: 'المدة:',
                      fontSize: 13,
                      color: Colors.white54,
                    ),
                    CustomText(
                      text: '${member.subscriptionMonths} شهر',
                      fontSize: 13,
                    ),
                  ],
                ),
                const Gap(8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: 'ينتهي:',
                      fontSize: 13,
                      color: Colors.white54,
                    ),
                    CustomText(text: endDate, fontSize: 13),
                  ],
                ),
                const Gap(8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: 'الحضور:',
                      fontSize: 13,
                      color: Colors.white54,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: member.attendedToday
                            ? AppColors.success
                            : Colors.white12,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: CustomText(
                        text: member.attendedToday ? 'حاضر' : 'غائب',
                        fontSize: 12,
                        color: member.attendedToday
                            ? Colors.black
                            : Colors.white54,
                      ),
                    ),
                  ],
                ),
                const Gap(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _resumeScanning();
                      },
                      child: CustomText(
                        text: 'إلغاء',
                        color: AppColors.snackError,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _toggleAttendance(member),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.gold,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.check_circle, size: 20),
                      label: CustomText(
                        text: member.attendedToday
                            ? 'إلغاء الحضور'
                            : 'تسجيل الحضور',
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const CustomText(text: 'مسح الباركود'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.white70),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: MobileScanner(
          onDetect: _onDetect,
          fit: BoxFit.cover,
          overlayBuilder: (ctx, constraints) => Container(
            alignment: Alignment.center,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.gold, width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
