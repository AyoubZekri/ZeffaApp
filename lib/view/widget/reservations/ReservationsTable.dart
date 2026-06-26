import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../core/constant/AppTheme.dart';
import '../../../data/model/ReservationModel.dart';
import '../../../core/services/Services.dart';
import 'package:url_launcher/url_launcher.dart';

class ReservationsTable extends StatelessWidget {
  final List<ReservationModel> reservations;
  final ValueChanged<ReservationModel>? onView;
  final ValueChanged<ReservationModel>? onEdit;
  final ValueChanged<ReservationModel>? onDelete;
  final ValueChanged<ReservationModel>? onPrint;
  final ValueChanged<ReservationModel>? onAddPayment;
  final ValueChanged<ReservationModel>? onEditGuests;

  const ReservationsTable({
    super.key,
    required this.reservations,
    this.onView,
    this.onEdit,
    this.onDelete,
    this.onPrint,
    this.onAddPayment,
    this.onEditGuests,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 900) {
          return _buildMobileLayout(context);
        }
        return _buildDesktopLayout(context);
      },
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (reservations.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 64),
            child: Center(
              child: Text(
                'no_reservations_found'.tr,
                style: TextStyle(color: colors.subtitleColor, fontSize: 16),
              ),
            ),
          )
        else
          Expanded(
            child: ListView.builder(
              itemCount: reservations.length,
              itemBuilder: (context, index) {
                return _buildMobileCard(context, reservations[index]);
              },
            ),
          ),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    final verticalScroll = ScrollController();
    final horizontalScroll = ScrollController();
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;

    return Container(
      height: 500,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colors.shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: Scrollbar(
              controller: horizontalScroll,
              thumbVisibility: true,
              thickness: 8,
              radius: const Radius.circular(8),
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  dragDevices: {
                    PointerDeviceKind.mouse,
                    PointerDeviceKind.touch,
                    PointerDeviceKind.stylus,
                    PointerDeviceKind.trackpad,
                  },
                ),
                child: SingleChildScrollView(
                  controller: horizontalScroll,
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: 1380,
                    child: Scrollbar(
                      controller: verticalScroll,
                      notificationPredicate: (notif) => notif.depth == 1,
                      child: SingleChildScrollView(
                        controller: verticalScroll,
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            _buildTableHeader(context),
                            const SizedBox(height: 8),
                            Divider(color: colors.borderColor, height: 1),
                            if (reservations.isEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 64,
                                ),
                                child: Center(
                                  child: Text(
                                    'no_reservations_found'.tr,
                                    style: TextStyle(
                                      color: colors.subtitleColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              )
                            else
                              ...List.generate(
                                reservations.length,
                                (index) => _buildTableRow(
                                  context,
                                  reservations[index],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final style = TextStyle(
      fontSize: 14,
      color: colors.subtitleColor,
      fontWeight: FontWeight.bold,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              'reservation_number'.tr,
              textAlign: TextAlign.right,
              style: style,
            ),
          ),
          SizedBox(
            width: 250,
            child: Text(
              'customer_name'.tr,
              textAlign: TextAlign.right,
              style: style,
            ),
          ),
          SizedBox(
            width: 180,
            child: Text(
              'phone_number'.tr,
              textAlign: TextAlign.right,
              style: style,
            ),
          ),
          SizedBox(
            width: 180,
            child: Text(
              'reservation_date'.tr,
              textAlign: TextAlign.right,
              style: style,
            ),
          ),
          SizedBox(
            width: 150,
            child: Text(
              'added_by'.tr,
              textAlign: TextAlign.right,
              style: style,
            ),
          ),
          SizedBox(
            width: 120,
            child: Center(child: Text('status'.tr, style: style)),
          ),
          const Spacer(),
          SizedBox(
            width: 280,
            child: Center(child: Text('actions'.tr, style: style)),
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(BuildContext context, ReservationModel item) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    final textColor = theme.colorScheme.onSurface;

    final myServices = Get.find<Myservices>();
    final supervisorName =
        myServices.sharedPreferences?.getString("username") ?? '';
    final addedBy = (item.addedByName != null && item.addedByName!.isNotEmpty)
        ? item.addedByName!
        : supervisorName;

    final Color statusColor;
    switch (item.statusKey) {
      case 'fully_paid':
        statusColor = Colors.green;
        break;
      case 'partially_paid':
        statusColor = Colors.orange;
        break;
      default: // unpaid
        statusColor = Colors.red;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              "#${item.numperReservation}",
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(
            width: 250,
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColor.primaryPurple.withOpacity(0.1),
                  child: Text(
                    item.avatarInitials,
                    style: const TextStyle(
                      color: AppColor.primaryPurple,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.customerName,
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.customerType ?? 'client'.tr,
                        style: TextStyle(
                          color: colors.subtitleColor,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            width: 180,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    item.phoneNumber,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.call, color: Colors.green, size: 20),
                  onPressed: () async {
                    final Uri launchUri = Uri(scheme: 'tel', path: item.phoneNumber);
                    if (await canLaunchUrl(launchUri)) {
                      await launchUrl(launchUri);
                    }
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            width: 180,
            child: Text(
              item.bookingDate,
              style: TextStyle(
                color: textColor,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          SizedBox(
            width: 150,
            child: Text(
              addedBy,
              style: TextStyle(
                color: colors.subtitleColor,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            width: 120,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  item.statusKey.tr,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),
          SizedBox(
            width: 280,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (onAddPayment != null)
                  _buildActionIcon(
                    context,
                    Icons.payments_outlined,
                    Colors.green,
                    () => onAddPayment!(item),
                  ),
                if (onEditGuests != null)
                  _buildActionIcon(
                    context,
                    Icons.group_outlined,
                    Colors.blue,
                    () => onEditGuests!(item),
                  ),
                if (onPrint != null)
                  _buildActionIcon(
                    context,
                    Icons.print_outlined,
                    Colors.grey,
                    () => onPrint!(item),
                  ),
                _buildActionIcon(
                  context,
                  Icons.visibility_outlined,
                  AppColor.primaryPurple,
                  () => onView?.call(item),
                ),
                _buildActionIcon(
                  context,
                  Icons.edit_outlined,
                  Colors.amber.shade700,
                  () => onEdit?.call(item),
                ),
                _buildActionIcon(
                  context,
                  Icons.delete_outline_rounded,
                  Colors.red,
                  () => onDelete?.call(item),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionIcon(
    BuildContext context,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colors.inputFillColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }

  Widget _buildMobileCard(BuildContext context, ReservationModel item) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    final textColor = theme.colorScheme.onSurface;
    final isDark = theme.brightness == Brightness.dark;

    final myServices = Get.find<Myservices>();
    final supervisorName =
        myServices.sharedPreferences?.getString("username") ?? '';
    final addedBy = (item.addedByName != null && item.addedByName!.isNotEmpty)
        ? item.addedByName!
        : supervisorName;

    final Color statusColor;
    switch (item.statusKey) {
      case 'fully_paid':
        statusColor = Colors.green;
        break;
      case 'partially_paid':
        statusColor = Colors.orange;
        break;
      default: // unpaid
        statusColor = Colors.red;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E24) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colors.borderColor.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: colors.shadowColor.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header: Res Number & Status ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.tag_rounded,
                      size: 16,
                      color: AppColor.primaryPurple.withOpacity(0.7),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      item.numperReservation.toString(),
                      style: const TextStyle(
                        color: AppColor.primaryPurple,
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(radius: 3, backgroundColor: statusColor),
                      const SizedBox(width: 6),
                      Text(
                        item.statusKey.tr,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: colors.borderColor.withOpacity(0.3)),

          // ── Body: Customer Info ──
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  height: 56,
                  width: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColor.primaryPurple.withOpacity(0.8),
                        AppColor.primaryPurple,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.primaryPurple.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      item.avatarInitials,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.customerName,
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.customerType ?? 'client'.tr,
                        style: TextStyle(
                          color: colors.subtitleColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: colors.inputFillColor,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(
                              Icons.phone_rounded,
                              size: 12,
                              color: colors.subtitleColor,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              item.phoneNumber,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.call, color: Colors.green, size: 20),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () async {
                              final Uri launchUri = Uri(scheme: 'tel', path: item.phoneNumber);
                              if (await canLaunchUrl(launchUri)) {
                                await launchUrl(launchUri);
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Date & Added By ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            color: isDark
                ? Colors.white.withOpacity(0.02)
                : Colors.grey.shade50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_month_rounded,
                      size: 16,
                      color: AppColor.primaryPurple,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item.bookingDate,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.person_outline_rounded,
                      size: 16,
                      color: colors.subtitleColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      addedBy,
                      style: TextStyle(
                        color: colors.subtitleColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Divider(height: 1, color: colors.borderColor.withOpacity(0.3)),

          // ── Footer: Actions ──
          Padding(
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  if (onAddPayment != null)
                    _buildMobileActionButton(
                      context,
                      Icons.payments_rounded,
                      Colors.green.shade600,
                      'add_payment'.tr,
                      () => onAddPayment!(item),
                    ),
                  if (onEditGuests != null)
                    _buildMobileActionButton(
                      context,
                      Icons.group_rounded,
                      Colors.blue.shade600,
                      'guests'.tr,
                      () => onEditGuests!(item),
                    ),
                  if (onPrint != null)
                    _buildMobileActionButton(
                      context,
                      Icons.print_rounded,
                      Colors.grey.shade600,
                      'print'.tr,
                      () => onPrint!(item),
                    ),
                  _buildMobileActionButton(
                    context,
                    Icons.visibility_rounded,
                    AppColor.primaryPurple,
                    'show'.tr,
                    () => onView?.call(item),
                  ),
                  _buildMobileActionButton(
                    context,
                    Icons.edit_rounded,
                    Colors.amber.shade700,
                    'edit'.tr,
                    () => onEdit?.call(item),
                  ),
                  _buildMobileActionButton(
                    context,
                    Icons.delete_rounded,
                    Colors.red.shade600,
                    'delete'.tr,
                    () => onDelete?.call(item),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileActionButton(
    BuildContext context,
    IconData icon,
    Color color,
    String tooltip,
    VoidCallback onTap,
  ) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: colors.inputFillColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.borderColor.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: 16),
                const SizedBox(width: 6),
                Text(
                  tooltip,
                  style: TextStyle(
                    color: color,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
