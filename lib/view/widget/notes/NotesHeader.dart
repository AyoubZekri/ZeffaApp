import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../core/constant/AppTheme.dart';

class NotesHeader extends StatelessWidget {
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onAddPressed;
  final TextEditingController? searchController;

  const NotesHeader({
    super.key,
    this.onSearchChanged,
    this.onAddPressed,
    this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    final textColor = theme.colorScheme.onSurface;
    final isMobile = MediaQuery.of(context).size.width < 600;

    final titleSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'notes_management'.tr,
          style: TextStyle(
            fontSize: isMobile ? 20 : 24,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'manage_your_notes'.tr,
          style: TextStyle(fontSize: 14, color: colors.subtitleColor),
        ),
      ],
    );

    final searchField = Container(
      width: isMobile ? null : 250,
      decoration: BoxDecoration(
        color: colors.inputFillColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: searchController,
        onChanged: onSearchChanged,
        textAlign: TextAlign.right,
        style: TextStyle(color: textColor, fontSize: 13),
        decoration: InputDecoration(
          hintText: 'search_notes'.tr,
          hintStyle: TextStyle(
            fontSize: 12,
            color: colors.subtitleColor,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: colors.subtitleColor,
            size: 20,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 16,
          ),
        ),
      ),
    );

    final addButton = isMobile
        ? InkWell(
            onTap: onAddPressed,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColor.primaryPurple,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.add_rounded, color: Colors.white),
            ),
          )
        : ElevatedButton.icon(
            onPressed: onAddPressed,
            icon: const Icon(Icons.add, size: 18),
            label: Text(
              'add_note'.tr,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primaryPurple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
          );

    final actionsSection = isMobile
        ? Row(
            children: [
              Expanded(child: searchField),
              const SizedBox(width: 12),
              addButton,
            ],
          )
        : Row(
            children: [
              searchField,
              const SizedBox(width: 16),
              addButton,
            ],
          );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleSection,
          const SizedBox(height: 16),
          actionsSection,
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        titleSection,
        actionsSection,
      ],
    );
  }
}
