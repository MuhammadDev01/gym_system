import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gym_management_app/core/components/app_background.dart';
import 'package:gym_management_app/core/components/custom_button.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/market/data/market_item_model.dart';

class MarketItemDetailView extends StatelessWidget {
  const MarketItemDetailView({super.key, required this.item});

  final MarketItemModel item;

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              GlassWidget(
                borderRaduis: 24,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: item.image.isNotEmpty
                          ? Image.memory(
                              base64Decode(item.image),
                              width: double.infinity,
                              height: 250,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              width: double.infinity,
                              height: 250,
                              color: Colors.white12,
                              child: const Icon(
                                Icons.shopping_bag,
                                size: 64,
                                color: Colors.white38,
                              ),
                            ),
                    ),
                    const SizedBox(height: 20),
                    CustomText(text: item.name, fontSize: 22),
                    const SizedBox(height: 8),
                    Text(
                      item.description,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 14,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: item.type == ItemType.tool
                            ? AppColors.gold.withValues(alpha: 0.15)
                            : AppColors.success.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: CustomText(
                        text: item.type == ItemType.tool ? 'أداة' : 'مكمل',
                        fontSize: 13,
                        color: item.type == ItemType.tool
                            ? AppColors.gold
                            : AppColors.success,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              GlassWidget(
                borderRaduis: 20,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    const CustomText(text: 'السعر', fontSize: 16),
                    const Spacer(),
                    CustomText(text: '${item.price} ج.م', fontSize: 20),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'تواصل معنا للشراء',
                icon: Icon(Icons.chat, color: Colors.black),
                size: const Size(double.infinity, 54),
                fontSize: 16,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
