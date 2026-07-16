import 'package:flutter/material.dart';
import 'package:gym_management_app/core/components/custom_text.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';

enum FilterType { all, tools, supplements }

class MarketItemFilter extends StatelessWidget {
  const MarketItemFilter({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });
  final FilterType selectedFilter;
  final void Function(FilterType) onFilterChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        spacing: 12,
        children: [
          _FilterChipItem(
            label: 'الكل',
            isSelected: selectedFilter == FilterType.all,
            onTap: () => onFilterChanged(FilterType.all),
          ),
          _FilterChipItem(
            label: 'مكملات',
            isSelected: selectedFilter == FilterType.supplements,
            onTap: () => onFilterChanged(FilterType.supplements),
          ),
          _FilterChipItem(
            label: 'أدوات',
            isSelected: selectedFilter == FilterType.tools,
            onTap: () => onFilterChanged(FilterType.tools),
          ),
        ],
      ),
    );
  }
}

class _FilterChipItem extends StatelessWidget {
  const _FilterChipItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.gold : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.gold, width: 1.5),
        ),
        child: CustomText(text: label, color: AppColors.black),
      ),
    );
  }
}
