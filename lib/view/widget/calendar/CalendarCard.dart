import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/CalendarController.dart';
import '../../../core/constant/AppTheme.dart';
import '../../../core/constant/Colorapp.dart';

class CalendarCard extends StatelessWidget {
  final CalendarController ctrl;
  final ThemeData theme;
  final AppColors colors;
  final bool isArabic;

  const CalendarCard({
    super.key,
    required this.ctrl,
    required this.theme,
    required this.colors,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 600;
        final double spacing = isMobile ? 4.0 : 12.0;
        final double cellPadding = isMobile ? 4.0 : 10.0;
        final double cellHeight = isMobile ? 70.0 : 110.0;
        final double dayFontSize = isMobile ? 12.0 : 14.0;
        final double dateFontSize = isMobile ? 14.0 : 15.0;

        return Container(
          padding: EdgeInsets.all(isMobile ? 12 : 24),
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
          child: Obx(() {
            final _ = ctrl.seasons.length;
            final __ = ctrl.specialDays.length;

            final year = ctrl.currentYear.value;
            final month = ctrl.currentMonth.value;

            final firstDayOfMonth = DateTime(year, month, 1);
            final totalDays = DateUtils.getDaysInMonth(year, month);

            final offset = firstDayOfMonth.weekday % 7;

            final prevMonth = month == 1 ? 12 : month - 1;
            final prevYear = month == 1 ? year - 1 : year;
            final prevTotalDays = DateUtils.getDaysInMonth(prevYear, prevMonth);

            final int gridCount = offset + totalDays;
            final int rowsCount = (gridCount / 7).ceil();
            final int totalGridItems = rowsCount * 7;

            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: ctrl.previousMonth,
                      icon: Icon(
                        isArabic
                            ? Icons.chevron_right_rounded
                            : Icons.chevron_left_rounded,
                        color: AppColor.primaryPurple,
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime(year, month),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                            initialDatePickerMode: DatePickerMode.year,
                          );
                          if (picked != null) {
                            ctrl.jumpToDate(picked);
                          }
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 4,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  "${ctrl.getMonthName(month)} $year",
                                  style: TextStyle(
                                    fontSize: isMobile ? 18 : 22,
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.arrow_drop_down_rounded,
                                color: AppColor.primaryPurple,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: ctrl.nextMonth,
                      icon: Icon(
                        isArabic
                            ? Icons.chevron_left_rounded
                            : Icons.chevron_right_rounded,
                        color: AppColor.primaryPurple,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: isMobile ? 16 : 24),

                Row(
                  children:
                      [
                        'sunday'.tr,
                        'monday'.tr,
                        'tuesday'.tr,
                        'wednesday'.tr,
                        'thursday'.tr,
                        'friday'.tr,
                        'saturday'.tr,
                      ].map((dayName) {
                        final isFriday = dayName == 'friday'.tr;
                        // For mobile, maybe just show first 3 letters
                        final displayDayName = isMobile && dayName.length > 3 
                            ? dayName.substring(0, 3) 
                            : dayName;

                        return Expanded(
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: isMobile ? 4 : 8),
                              child: Text(
                                displayDayName,
                                style: TextStyle(
                                  fontSize: dayFontSize,
                                  fontWeight: FontWeight.bold,
                                  color: isFriday
                                      ? AppColor.primaryPurple
                                      : colors.subtitleColor,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),

                const Divider(),
                SizedBox(height: isMobile ? 8 : 12),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: totalGridItems,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    crossAxisSpacing: spacing,
                    mainAxisSpacing: spacing,
                    mainAxisExtent: cellHeight,
                  ),
                  itemBuilder: (context, index) {
                    if (index < offset) {
                      final prevDay = prevTotalDays - offset + index + 1;

                      return _buildEmptyCell(prevDay, colors, dateFontSize);
                    }

                    if (index < offset + totalDays) {
                      final day = index - offset + 1;

                      final currentDate = DateTime(year, month, day);

                      final isFriday = currentDate.weekday == DateTime.friday;

                      final event = ctrl.getEventForDate(currentDate);
                      return InkWell(
                        onTap: (event != null && event['type'] == 'reserved')
                            ? () => ctrl.showBookingDetails(event)
                            : null,
                        borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
                        splashColor: AppColor.primaryPurple.withOpacity(0.1),
                        child: _buildDayCell(day, isFriday, event, theme, colors, cellPadding, dateFontSize, isMobile),
                      );
                    }

                    final nextDay = index - (offset + totalDays) + 1;

                    return _buildEmptyCell(nextDay, colors, dateFontSize);
                  },
                ),

                if (month == 10 && year == 2024) ...[
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.primaryPurple.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColor.primaryPurple.withOpacity(0.2),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.wb_twilight_rounded,
                          color: AppColor.primaryPurple,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'season_autumn'.tr,
                          style: const TextStyle(
                            color: AppColor.primaryPurple,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            );
          }),
        );
      },
    );
  }

  Widget _buildEmptyCell(int day, AppColors colors, double dateFontSize) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: Center(
        child: Text(
          "$day",
          style: TextStyle(
            color: colors.subtitleColor.withOpacity(0.35),
            fontWeight: FontWeight.w500,
            fontSize: dateFontSize,
          ),
        ),
      ),
    );
  }

  Widget _buildDayCell(
    int day,
    bool isFriday,
    Map<String, dynamic>? event,
    ThemeData theme,
    AppColors colors,
    double padding,
    double dateFontSize,
    bool isMobile,
  ) {
    final isDark = theme.brightness == Brightness.dark;
    final eventType = event?['type'] ?? 'available';
    Color cellBg = colors.inputFillColor;
    Border cellBorder = Border.all(color: colors.borderColor);

    if (eventType == 'reserved') {
      final period = event?['booking_period'];
      if (period == 3) {
        cellBg = Colors.indigo.withOpacity(0.05);
        cellBorder = Border.all(color: Colors.indigo.shade300);
      } else if (period == 4) {
        cellBg = Colors.orange.withOpacity(0.05);
        cellBorder = Border.all(color: Colors.orange.shade300);
      } else {
        cellBg = Colors.redAccent.withOpacity(0.05);
        cellBorder = Border.all(color: Colors.redAccent.shade200);
      }
    } else if (eventType == 'special_day') {
      cellBg = Colors.orange.withOpacity(0.08);
      cellBorder = Border.all(color: Colors.orange);
    } else if (eventType == 'special_period') {
      cellBg = AppColor.primaryPurple.withOpacity(0.08);
      cellBorder = Border.all(color: AppColor.primaryPurple);
    } else if (isFriday) {
      cellBg = AppColor.primaryPurple.withOpacity(0.05);
      cellBorder = Border.all(color: AppColor.primaryPurple);
    }

    return Container(
      decoration: BoxDecoration(
        color: cellBg,
        borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
        border: cellBorder,
      ),
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Day number
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              "$day",
              style: TextStyle(
                fontSize: dateFontSize,
                fontWeight: FontWeight.bold,
                color: isFriday
                    ? AppColor.primaryPurple
                    : theme.colorScheme.onSurface,
              ),
            ),
          ),
          if (eventType != 'available' && !isMobile) const Spacer(),
          if (eventType != 'available' && isMobile) const SizedBox(height: 2),
          // Event details
          if (eventType == 'reserved') ...[
            if (event?['booking_period'] == 3)
              Icon(
                Icons.nights_stay_rounded,
                color: isDark ? Colors.indigo.shade300 : Colors.indigo,
                size: isMobile ? 12 : 18,
              )
            else if (event?['booking_period'] == 4)
              Icon(
                Icons.light_mode_rounded,
                color: isDark ? Colors.orange.shade300 : Colors.orange,
                size: isMobile ? 12 : 18,
              )
            else
              Icon(
                Icons.lock_outline_rounded,
                color: isDark ? Colors.red.shade300 : Colors.red,
                size: isMobile ? 12 : 18,
              ),
          ],
          if (eventType == 'special_day')
            Icon(Icons.star_rounded, color: Colors.orange, size: isMobile ? 12 : 18),
          if (eventType == 'special_period')
            Icon(
              Icons.auto_awesome_rounded,
              color: AppColor.primaryPurple,
              size: isMobile ? 12 : 18,
            ),
        ],
      ),
    );
  }
}
