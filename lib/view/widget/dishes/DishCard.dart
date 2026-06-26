import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../core/constant/AppTheme.dart';
import '../../../data/model/DishModel.dart';

class DishCard extends StatelessWidget {
  final DishModel item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const DishCard({
    Key? key,
    required this.item,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;

    final title = item.name.toString();
    final imageUrl = item.image.toString();
    final isMobile = MediaQuery.of(context).size.width < 600;

    if (isMobile) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colors.cardColor,
          gradient: LinearGradient(
            colors: [
              colors.cardColor,
              AppColor.primaryPurple.withOpacity(0.04),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: AppColor.primaryPurple.withOpacity(0.15),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColor.primaryPurple.withOpacity(0.08),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Row(
          children: [
            // Floating 3D Image
            Container(
              width: 115,
              height: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(4, 6),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child:
                  imageUrl != null &&
                      imageUrl.isNotEmpty &&
                      !imageUrl.startsWith('http') &&
                      File(imageUrl).existsSync()
                  ? Image.file(File(imageUrl), fit: BoxFit.cover)
                  : Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: AppColor.purpleGradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.flatware_rounded,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                    ),
            ),
            const SizedBox(width: 16),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: theme.colorScheme.onSurface,
                      letterSpacing: 0.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  // Premium Glowing Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildWowIconButton(
                        icon: Icons.edit_rounded,
                        gradient: const LinearGradient(
                          colors: AppColor.purpleGradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shadowColor: AppColor.primaryPurple.withOpacity(0.4),
                        onTap: onEdit,
                      ),
                      const SizedBox(width: 12),
                      _buildWowIconButton(
                        icon: Icons.delete_outline_rounded,
                        gradient: LinearGradient(
                          colors: [
                            Colors.redAccent.shade200,
                            Colors.red.shade700,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shadowColor: Colors.redAccent.withOpacity(0.4),
                        onTap: onDelete,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    // Desktop Layout
    return Container(
      decoration: BoxDecoration(
        color: colors.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: colors.shadowColor,
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          imageUrl != null &&
                  imageUrl.isNotEmpty &&
                  !imageUrl.startsWith('http') &&
                  File(imageUrl).existsSync()
              ? Image.file(
                  File(imageUrl),
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
              : Container(
                  height: 180,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: AppColor.purpleGradient),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.flatware_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),

          // Content Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Title
                  Expanded(
                    child: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Actions Row
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          Icons.edit_outlined,
                          color: colors.subtitleColor,
                          size: 18,
                        ),
                        onPressed: onEdit,
                        tooltip: 'edit_btn'.tr,
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          color: Colors.redAccent,
                          size: 18,
                        ),
                        onPressed: onDelete,
                        tooltip: 'delete'.tr,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWowIconButton({
    required IconData icon,
    required Gradient gradient,
    required Color shadowColor,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
        ),
      ),
    );
  }
}
