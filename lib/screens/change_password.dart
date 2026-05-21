import 'package:autism_world/l10n/app_localizations.dart';
import 'package:autism_world/settings/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    final l10n = AppLocalizations.of(context)!;

    final isDark = settings.darkMode;

    final backgroundColor = isDark
        ? const Color(0xFF0F172A)
        : const Color(0xFFF5F7FA);

    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;

    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        title: Text(
          settings.locale.languageCode == 'ar'
              ? 'تغيير كلمة المرور'
              : 'Change Password',
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: textColor,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20),
          ),

          child: Column(
            children: [
              _buildField(
                controller: currentPasswordController,
                label: settings.locale.languageCode == 'ar'
                    ? 'كلمة المرور الحالية'
                    : 'Current Password',
                icon: Icons.lock_outline,
                textColor: textColor,
              ),

              const SizedBox(height: 20),

              _buildField(
                controller: newPasswordController,
                label: settings.locale.languageCode == 'ar'
                    ? 'كلمة المرور الجديدة'
                    : 'New Password',
                icon: Icons.lock,
                textColor: textColor,
              ),

              const SizedBox(height: 20),

              _buildField(
                controller: confirmPasswordController,
                label: settings.locale.languageCode == 'ar'
                    ? 'تأكيد كلمة المرور'
                    : 'Confirm Password',
                icon: Icons.verified_user,
                textColor: textColor,
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          settings.locale.languageCode == 'ar'
                              ? 'تم تحديث كلمة المرور'
                              : 'Password Updated',
                        ),
                      ),
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),

                  child: Text(
                    settings.locale.languageCode == 'ar' ? 'حفظ' : 'Save',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color textColor,
  }) {
    return TextField(
      controller: controller,
      obscureText: true,

      style: TextStyle(color: textColor),

      decoration: InputDecoration(
        labelText: label,

        labelStyle: TextStyle(color: textColor),

        prefixIcon: Icon(icon),

        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
