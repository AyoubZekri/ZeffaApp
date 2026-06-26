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

  Color _getPerformanceColor(String perf) {
    if (perf == 'excellent'.tr) return Colors.green.shade600;
    if (perf == 'average'.tr) return Colors.blue.shade600;
    if (perf == 'below_average'.tr) return Colors.orange.shade600;
    if (perf == 'bad'.tr) return Colors.red.shade600;
    return Colors.grey.shade600;
  }
}
