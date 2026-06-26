import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../core/constant/AppTheme.dart';

class ReservationsHeader extends StatelessWidget {
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onAddReservation;
  final VoidCallback? onFilter;
  final VoidCallback? onClearFilter;
  final VoidCallback? onExport;
  final TextEditingController? searchController;
  final bool isFilterActive;

  const ReservationsHeader({
    super.key,
    this.onSearchChanged,
    this.onAddReservation,
    this.onFilter,
    this.onClearFilter,
    this.onExport,
    this.searchController,
    this.isFilterActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 900;
        if (isMobile) {
          return _buildMobileHeader(context);
        }
        return _buildDesktopHeader(context);
      },
    );
  }

  Widget _buildDesktopHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    final textColor = theme.colorScheme.onSurface;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'reservations_management'.tr,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'view_all_current_and_future_reservations'.tr,
              style: TextStyle(fontSize: 14, color: colors.subtitleColor),
            ),
          ],
        ),

        Expanded(
          child: Wrap(
            alignment: WrapAlignment.end,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 12,
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
                  textAlign: TextAlign.right,
                  style: TextStyle(color: textColor, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'search_reservations'.tr,
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
              ElevatedButton.icon(
                onPressed: onAddReservation,
                icon: const Icon(Icons.add, size: 18),
                label: Text(
                  'add_reservation'.tr,
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
        ),
      ],
    );
  }

  Widget _buildMobileHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    final textColor = theme.colorScheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'reservations_management'.tr,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: colors.inputFillColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: onSearchChanged,
                  textAlign: TextAlign.right,
                  style: TextStyle(color: textColor, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'search_reservations'.tr,
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
            ),
            const SizedBox(width: 12),
            InkWell(
              onTap: onAddReservation,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColor.primaryPurple,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.add_rounded, color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }

}
