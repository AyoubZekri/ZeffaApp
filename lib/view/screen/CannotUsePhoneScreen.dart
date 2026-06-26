import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../core/constant/AppTheme.dart';
import '../../../core/constant/routes.dart';
import '../../../core/services/Services.dart';

class CannotUsePhoneScreen extends StatelessWidget {
  const CannotUsePhoneScreen({super.key});

  Future<void> _launchWhatsApp() async {
    const phoneNumber = '+213673628801';
    final Uri url = Uri.parse('https://wa.me/$phoneNumber');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      Get.snackbar(
        'error'.tr,
        'could_not_launch_whatsapp'.tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _launchEmail() async {
    final Uri url = Uri(
      scheme: 'mailto',
      path: 'codedev39@gmail.com',
      query: 'subject=استفسار حول استخدام الحساب على الهاتف',
    );
    if (!await launchUrl(url)) {
      Get.snackbar(
        'error'.tr,
        'could_not_launch_email'.tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _logout() {
    Myservices myServices = Get.find();
    myServices.sharedPreferences!.clear();
    Get.offAllNamed(Approutes.Login);
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Get.isDarkMode;
    final theme = isDark ? AppTheme.darkTheme : AppTheme.lightTheme;
    final colors = theme.extension<AppColors>()!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Illustration or Icon
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.phonelink_erase_rounded,
                    size: 80,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 32),

                // Title
                Text(
                  'cannot_use_phone_title'.tr,
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
                  'cannot_use_phone_desc'.tr,
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
                const SizedBox(height: 32),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _logout,
                    icon: const Icon(Icons.login_rounded, color: Colors.white),
                    label: Text(
                      'go_to_login'.tr,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? color.withOpacity(0.1) : color.withOpacity(0.05),
          border: Border.all(color: color.withOpacity(0.3), width: 1.5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
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
                    ),
                    textDirection: TextDirection.ltr,
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: color, size: 20),
          ],
        ),
      ),
    );
  }
}
