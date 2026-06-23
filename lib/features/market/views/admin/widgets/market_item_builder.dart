// ignore_for_file: avoid_unnecessary_containers

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_management_app/core/components/app_dialog.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/components/glass_widget.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';
import 'package:gym_management_app/features/market/cubit/admin/market_admin_cubit.dart';
import 'package:gym_management_app/features/market/data/market_item_model.dart';
import 'package:gym_management_app/features/market/views/admin/widgets/edit_item_market_dialog_content.dart';

class MarketItemBuilder extends StatelessWidget {
  const MarketItemBuilder({super.key, required this.item});
  final MarketItemModel item;
  @override
  Widget build(BuildContext context) {
    return GlassWidget(
      borderRaduis: 16,
      child: ListTile(
        leading: item.image.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(
                  base64Decode(item.image),
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              )
            : Icon(Icons.shopping_bag, color: AppColors.gold),
        title: CustomText(text: item.name),
        subtitle: CustomText(text: '${item.price} ج.م', fontSize: 13),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: AppColors.gold),
              onPressed: () {
                context.read<MarketAdminCubit>().startEdit(item);
                _showEditDialog(context);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: AppColors.error),
              onPressed: () => showDeleteConfirm(
                context,
                title: 'هل تريد حذف المنتج بشكل نهائي؟',
                onConfirm: () {
                  context.read<MarketAdminCubit>().deleteProduct(item.id);
                  context.pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showEditDialog(BuildContext context) async {
    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: AppColors.background.withValues(alpha: 0.8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: EditItemMarketDialogContent(
            cubit: context.read<MarketAdminCubit>(),
            formkey: formKey,
          ),
        );
      },
    );
  }
}
