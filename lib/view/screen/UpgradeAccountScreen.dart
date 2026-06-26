import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../core/constant/AppTheme.dart';

class UpgradeAccountScreen extends StatelessWidget {
  const UpgradeAccountScreen({super.key});

  Future<void> _launchWhatsApp() async {
    const phoneNumber = '+213673628801';
    final Uri url = Uri.parse('https://wa.me/$phoneNumber');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      Get.snackbar('error'.tr, 'could_not_launch_whatsapp'.tr, backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> _launchEmail() async {
    final Uri url = Uri(
      scheme: 'mailto',
      path: 'codedev39@gmail.com',
      query: 'subject=طلب ترقية حساب',
    );
    if (!await launchUrl(url)) {
      Get.snackbar('error'.tr, 'could_not_launch_email'.tr, backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>() ?? AppColors.light;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Premium Icon/Illustration
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [AppColor.primaryPurple.withOpacity(0.8), AppColor.primaryPurple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.primaryPurple.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.workspace_premium_rounded,
                  size: 80,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32),
              
              // Title
              Text(
                'upgrade_account_title'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: theme.colorScheme.onSurface,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 16),
              
              // Description
              Text(
                'upgrade_account_desc'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: colors.subtitleColor,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 48),

              // Contact Buttons
              _buildContactButton(
                title: 'contact_via_whatsapp'.tr,
                subtitle: '0673628801',
                icon: Icons.chat_bubble_outline_rounded,
                color: const Color(0xFF25D366),
                onTap: _launchWhatsApp,
                isDark: isDark,
              ),
              const SizedBox(height: 16),
              _buildContactButton(
                title: 'contact_via_email'.tr,
                subtitle: 'codedev39@gmail.com',
                icon: Icons.email_outlined,
                color: const Color(0xFFEA4335),
                onTap: _launchEmail,
                isDark: isDark,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isDark ? color.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: color.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white70 : Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: color, size: 18),
          ],
        ),
      ),
    );
  }
}
