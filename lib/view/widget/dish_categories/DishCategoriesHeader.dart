import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../core/constant/AppTheme.dart';

class DishCategoriesHeader extends StatelessWidget {
  final VoidCallback onAddPressed;

  const DishCategoriesHeader({Key? key, required this.onAddPressed})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 600;

        if (isMobile) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'manage_dish_categories'.tr,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'dish_categories_desc'.tr,
                style: TextStyle(
                  fontSize: 13,
                  color: colors.subtitleColor,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onAddPressed,
                  icon: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add_rounded, color: Colors.white, size: 16),
                  ),
                  label: Text(
                    'add_new_category'.tr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryPurple,
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Title & Description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'manage_dish_categories'.tr,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'dish_categories_desc'.tr,
                    style: TextStyle(
                      fontSize: 14,
                      color: colors.subtitleColor,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Add New Button
            ElevatedButton.icon(
              onPressed: onAddPressed,
              icon: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add_rounded, color: Colors.white, size: 16),
              ),
              label: Text(
                'add_new_category'.tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primaryPurple,
                elevation: 0,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
