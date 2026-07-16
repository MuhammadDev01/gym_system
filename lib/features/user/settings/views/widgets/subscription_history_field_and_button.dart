import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/core/components/custom_button.dart';
import 'package:gym_management_app/core/components/custom_text_field.dart';
import 'package:gym_management_app/features/user/subscription/cubit/subscription_history_cubit.dart';

class SubscriptionHistoryFieldAndButton extends StatefulWidget {
  const SubscriptionHistoryFieldAndButton({super.key});

  @override
  State<SubscriptionHistoryFieldAndButton> createState() =>
      _SubscriptionHistoryFieldAndButtonState();
}

class _SubscriptionHistoryFieldAndButtonState
    extends State<SubscriptionHistoryFieldAndButton> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Row(
        spacing: 8,
        children: [
          Expanded(
            child: CustomTextField(
              hintText: 'بحث بالاسم أو رقم الهاتف',
              controller: context
                  .read<SubscriptionHistoryCubit>()
                  .searchController,
              prefixIcon: Icons.search,
              validator: (p0) =>
                  p0 == null || p0.trim().isEmpty ? 'أدخل بيانات البحث' : null,
            ),
          ),
          CustomButton(
            text: 'بحث',
            size: const Size(80, 40),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await context
                    .read<SubscriptionHistoryCubit>()
                    .searchByNameOrPhone();
              }
            },
          ),
        ],
      ),
    );
  }
}
