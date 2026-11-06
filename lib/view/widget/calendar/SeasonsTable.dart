import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/CalendarController.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../core/constant/AppTheme.dart';
import 'CalendarFormDialog.dart';

class SeasonsTable extends StatelessWidget {
  const SeasonsTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    final isArabic = Get.locale?.languageCode == 'ar';
    final CalendarController ctrl = Get.find();

    if (MediaQuery.of(context).size.width < 600) {
      return _buildMobile(context, ctrl, theme, colors);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Clean Header ──
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              const Icon(
                Icons.list_alt_rounded,
                color: AppColor.primaryPurple,
                size: 22,
              ),
              const SizedBox(width: 12),
              Text(
                'seasons_overview'.tr,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        
        Obx(() {
          if (ctrl.allDates.isEmpty) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40),
              decoration: BoxDecoration(
                color: colors.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.borderColor),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.event_note_rounded,
                    size: 48,
                    color: colors.subtitleColor.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'no_data'.tr,
                    style: TextStyle(
                      color: colors.subtitleColor,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            );
          }

          return Container(
            decoration: BoxDecoration(
              color: colors.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.borderColor),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: ctrl.allDates.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                thickness: 1,
                color: colors.borderColor.withOpacity(0.5),
              ),
              itemBuilder: (context, index) {
                final item = ctrl.allDates[index];
                final isSeason = item['type'] == 'special_period';

                final name = isSeason
                    ? (item['nameKey'] != ''
                          ? item['nameKey'].toString().tr
                          : item['nameCustom'].toString())
                    : item['title'].toString();

                final period = isSeason
                    ? (item['periodKey'] != ''
                          ? item['periodKey'].toString().tr
                          : item['periodCustom'].toString())
                    : item['date'].toString();

                final perfText = isSeason ? ctrl.getSeasonPerformance(item) : '';
                final perfColor = _getPerformanceColor(perfText);
                final accentColor = isSeason ? AppColor.primaryPurple : Colors.orange;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                    children: [
                      // Clean Circular Icon
                      Container(
                        height: 44,
                        width: 44,
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isSeason ? Icons.date_range_rounded : Icons.star_rounded,
                          color: accentColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      
                      // Text Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              period,
                              style: TextStyle(
                                fontSize: 13,
                                color: colors.subtitleColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Performance Badge
                      if (isSeason) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: perfColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20), // Pill shape
                          ),
                          child: Text(
                            perfText,
                            style: TextStyle(
                              color: perfColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                      
                      // Simple Action Icons
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () {
                              ctrl.setEditData(item);
                              Get.dialog(
                                CalendarFormDialog(ctrl: ctrl),
                                barrierDismissible: true,
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.edit_outlined,
                                color: AppColor.primaryPurple,
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () {
                              ctrl.deleteSpecialDate(item['uuid']);
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.delete_outline_rounded,
                                color: Colors.redAccent,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }),
      ],
    );
  }

  // ═══════════════════════════════════════
  // Phone layout
  // ═══════════════════════════════════════

  String _itemName(Map<String, dynamic> item, bool isSeason) => isSeason
      ? (item['nameKey'] != ''
            ? item['nameKey'].toString().tr
            : item['nameCustom'].toString())
      : item['title'].toString();

  String _itemPeriod(Map<String, dynamic> item, bool isSeason) => isSeason
      ? (item['periodKey'] != ''
            ? item['periodKey'].toString().tr
            : item['periodCustom'].toString())
      : item['date'].toString();

  Widget _buildMobile(
    BuildContext context,
    CalendarController ctrl,
    ThemeData theme,
    AppColors colors,
  ) {
    return Obx(() {
      final items = ctrl.allDates.toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Header: title + counters ──
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColor.primaryPurple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.insights_rounded,
                  color: AppColor.primaryPurple,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'seasons_overview'.tr,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          if (items.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 32),
              decoration: BoxDecoration(
                color: colors.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.borderColor),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.event_note_rounded,
                    size: 40,
                    color: colors.subtitleColor.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'no_data'.tr,
                    style: TextStyle(color: colors.subtitleColor, fontSize: 14),
                  ),
                ],
              ),
            )
          else
            ...items.map((item) => _mobileCard(context, ctrl, item, theme, colors)),
        ],
      );
    });
  }


  Widget _mobileCard(
    BuildContext context,
    CalendarController ctrl,
    Map<String, dynamic> item,
    ThemeData theme,
    AppColors colors,
  ) {
    final isSeason = item['type'] == 'special_period';
    final accent = isSeason ? AppColor.primaryPurple : Colors.orange;
    final perfText = isSeason ? ctrl.getSeasonPerformance(item) : '';
    final perfColor = _getPerformanceColor(perfText);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.borderColor),
        boxShadow: [
          BoxShadow(
            color: colors.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Color strip: season / special day
            Container(width: 5, color: accent),
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 4, 12),
                child: Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isSeason ? Icons.date_range_rounded : Icons.star_rounded,
                        color: accent,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _itemName(item, isSeason),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_rounded,
                                size: 13,
                                color: colors.subtitleColor,
                              ),
                              const SizedBox(width: 5),
                              Flexible(
                                child: Text(
                                  _itemPeriod(item, isSeason),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colors.subtitleColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (isSeason && perfText.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: perfColor.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.trending_up_rounded,
                                      size: 14,
                                      color: perfColor,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      perfText,
                                      style: TextStyle(
                                        color: perfColor,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    // Actions
                    PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert_rounded, color: colors.subtitleColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      onSelected: (value) {
                        if (value == 'edit') {
                          ctrl.setEditData(item);
                          Get.dialog(
                            CalendarFormDialog(ctrl: ctrl),
                            barrierDismissible: true,
                          );
                        } else if (value == 'delete') {
                          ctrl.deleteSpecialDate(item['uuid']);
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              const Icon(Icons.edit_outlined,
                                  size: 18, color: AppColor.primaryPurple),
                              const SizedBox(width: 10),
                              Text('edit'.tr),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              const Icon(Icons.delete_outline_rounded,
                                  size: 18, color: Colors.redAccent),
                              const SizedBox(width: 10),
                              Text('delete'.tr,
                                  style: const TextStyle(color: Colors.redAccent)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getPerformanceColor(String perf) {
    if (perf == 'excellent'.tr) return Colors.green.shade600;
    if (perf == 'average'.tr) return Colors.blue.shade600;
    if (perf == 'below_average'.tr) return Colors.orange.shade600;
    if (perf == 'bad'.tr) return Colors.red.shade600;
    return Colors.grey.shade600;
  }
}
