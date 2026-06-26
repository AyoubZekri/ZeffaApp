import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constant/Colorapp.dart';
import '../../../../controller/NotificationsController.dart';
import '../../../../core/functions/dialogDelete.dart';

class NotificationHeader extends StatelessWidget {
  const NotificationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final controller = Get.find<NotificationsController>();
    final isMobile = MediaQuery.of(context).size.width < 600;

    final titleSection = Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColor.primaryPurple, Color(0xFF9D63F1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppColor.primaryPurple.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.notifications_active_rounded,
            color: Colors.white,
            size: 28,
          ),
        ),
        const SizedBox(width: 16),
        Text(
          "الإشعارات",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: isDark ? Colors.white : const Color(0xFF1E1E1E),

            letterSpacing: -0.5,
          ),
        ),
      ],
    );
    final actionsSection = Row(
      children: [
        Expanded(
          child: _buildHeaderAction(
            context,
            icon: Icons.done_all_rounded,
            label: isMobile ? "مقروء".tr : "mark_all_read".tr,
            color: Colors.green,
            onTap: () => controller.markAllAsRead(),
            isMobile: isMobile,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildHeaderAction(
            context,
            icon: Icons.delete_sweep_rounded,
            label: isMobile ? "حذف".tr : "delete_all".tr,
            color: Colors.red,
            onTap: () {
              dialogDelete(
                title: 'delete_confirm_btn'.tr,
                content: '',
                onConfirm: () {
                  controller.deleteAllNotifications();
                  Get.back();
                },
              );
            },
            isMobile: isMobile,
          ),
        ),
      ],
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [titleSection, const SizedBox(height: 16), actionsSection],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        titleSection,
        SizedBox(width: 320, child: actionsSection),
      ],
    );
  }

  Widget _buildHeaderAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    bool isMobile = false,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 8 : 20,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: color.withValues(alpha: isDark ? 0.1 : 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w700,
                    fontSize: isMobile ? 12 : 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
