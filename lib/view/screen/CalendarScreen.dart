import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/CalendarController.dart';
import '../../core/constant/AppTheme.dart';
import '../widget/calendar/CalendarCard.dart';
import '../widget/calendar/CalendarFormDialog.dart';
import '../widget/calendar/CalendarGuide.dart';
import '../widget/calendar/CalendarHeader.dart';
import '../widget/calendar/SeasonsTable.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    final isArabic = Get.locale?.languageCode == 'ar';

    // Inject CalendarController
    Get.delete<CalendarController>();

    final ctrl = Get.put(CalendarController());

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Directionality(
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isMobile = constraints.maxWidth < 900;
            
            return Container(
              padding: EdgeInsets.all(isMobile ? 16 : 32),
              child: Builder(
                builder: (context) {
                  if (isMobile) {
                // ── Mobile Layout ──
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CalendarHeader(
                        onAddPressed: () {
                          Get.dialog(
                            const CalendarFormDialog(),
                            barrierDismissible: true,
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      const CalendarGuide(),
                      const SizedBox(height: 32),
                      CalendarCard(
                        ctrl: ctrl,
                        theme: theme,
                        colors: colors,
                        isArabic: isArabic,
                      ),
                      const SizedBox(height: 32),
                      const SeasonsTable(),
                    ],
                  ),
                );
              }

              // ── Desktop Layout ──
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Sidebar
                  SizedBox(
                    width: 320,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          const CalendarGuide(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 32),

                  // Right Main Area
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CalendarHeader(
                            onAddPressed: () {
                              Get.dialog(
                                const CalendarFormDialog(),
                                barrierDismissible: true,
                              );
                            },
                          ),
                          const SizedBox(height: 36),
                          CalendarCard(
                            ctrl: ctrl,
                            theme: theme,
                            colors: colors,
                            isArabic: isArabic,
                          ),
                          const SizedBox(height: 36),
                          const SeasonsTable(),
                        ],
                      ),
                    ),
                  ),
                ],
              );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
