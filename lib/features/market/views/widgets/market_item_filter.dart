import 'package:flutter/material.dart';
import 'package:gym_management_app/core/theme/app_colors.dart';

class ItemFilter extends StatelessWidget {
  const ItemFilter({
    super.key,
    this.selectedFilter = FilterType.all,
    this.onFilterChanged,
  });
  final FilterType selectedFilter;
  final void Function(FilterType)? onFilterChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: _FilterButton(
              title: "الكل",
              selected: selectedFilter == FilterType.all,
              onTap: () => onFilterChanged?.call(FilterType.all),
            ),
          ),
          Expanded(
            child: _FilterButton(
              title: "المكملات",
              selected: selectedFilter == FilterType.supplements,
              onTap: () => onFilterChanged?.call(FilterType.supplements),
            ),
          ),
          Expanded(
            child: _FilterButton(
              title: "الأدوات",
              selected: selectedFilter == FilterType.tools,
              onTap: () => onFilterChanged?.call(FilterType.tools),
            ),
          ),
        ],
      ),
    );
  }
}

enum FilterType { all, supplements, tools }

class _FilterButton extends StatelessWidget {
  const _FilterButton({
    required this.title,
    required this.selected,
    this.onTap,
  });
  final String title;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        height: 45,
        decoration: BoxDecoration(
          color: selected ? AppColors.gold : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: selected ? Colors.black : Colors.white70,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
