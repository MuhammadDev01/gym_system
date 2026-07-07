import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:gym_management_app/core/components/custom_button.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/helper/app_snackbar.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/user/general/home/cubit/home_cubit.dart';

class QrIcon extends StatelessWidget {
  const QrIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      child: GestureDetector(
        onTap: () => _showQrDialog(context),
        child: Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.gold.withValues(alpha: .2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.gold.withValues(alpha: .3)),
          ),
          child: Icon(Icons.qr_code_2, color: AppColors.gold, size: 28),
        ),
      ),
    );
  }

  void _showQrDialog(BuildContext context) {
    final boundaryKey = GlobalKey();
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RepaintBoundary(
                key: boundaryKey,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: QrImageView(
                    data: context.read<HomeCubit>().member!.phone,
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
              ),
              const Gap(12),
              CustomText(
                text: 'امسح الباركود للوصول لبيانات العضوية',
                fontSize: 12,
                color: Colors.black,
              ),
              const Gap(16),
              CustomButton(
                onPressed: () async {
                  try {
                    final member = context.read<HomeCubit>().member!;
                    final renderBox = boundaryKey.currentContext!
                        .findRenderObject() as RenderRepaintBoundary;
                    final image = await renderBox.toImage(pixelRatio: 3.0);
                    final byteData =
                        await image.toByteData(format: ui.ImageByteFormat.png);
                    if (byteData == null) return;

                    final tempDir = await getTemporaryDirectory();
                    final file = File(
                      '${tempDir.path}/qr_${member.phone}.png',
                    );
                    await file.writeAsBytes(byteData.buffer.asUint8List());

                    if (!context.mounted) return;
                    await SharePlus.instance.share(
                      ShareParams(
                        files: [XFile(file.path)],
                        text: 'QR Code - ${member.name}',
                      ),
                    );
                  } catch (e) {
                    if (context.mounted) {
                      appSnackbar(context, 'حدث خطأ أثناء تحميل الباركود');
                    }
                  }
                },
                text: 'تحميل الباركود',
                icon: const Icon(Icons.download_outlined),
                size: const Size(double.infinity, 44),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
