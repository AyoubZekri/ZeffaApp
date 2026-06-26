import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../core/constant/AppTheme.dart';

class ExpensesHeader extends StatelessWidget {
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onAddPressed;
  final TextEditingController? searchController;

  const ExpensesHeader({
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;

        if (isMobile) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'expenses_management'.tr,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'manage_daily_expenses'.tr,
                style: TextStyle(fontSize: 14, color: colors.subtitleColor),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: colors.inputFillColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: onSearchChanged,
                  textAlign: TextAlign.start,
                  style: TextStyle(color: textColor, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'search_expenses'.tr,
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
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onAddPressed,
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(
                    'add_expense'.tr,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          );
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'expenses_management'.tr,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'manage_daily_expenses'.tr,
                  style: TextStyle(fontSize: 14, color: colors.subtitleColor),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: 250,
                  decoration: BoxDecoration(
                    color: colors.inputFillColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: searchController,
                    onChanged: onSearchChanged,
                    textAlign: TextAlign.start,
                    style: TextStyle(color: textColor, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'search_expenses'.tr,
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
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: onAddPressed,
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(
                    'add_expense'.tr,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 21,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
