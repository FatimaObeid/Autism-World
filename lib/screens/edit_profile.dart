import 'package:autism_world/settings/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Example default data
    nameController.text = "John Doe";
    emailController.text = "john@example.com";
    phoneController.text = "+961 70 123 456";
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    final isDark = settings.darkMode;

    final backgroundColor = isDark
        ? const Color(0xFF0F172A)
        : const Color(0xFFF5F7FA);

    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;

    final textColor = isDark ? Colors.white : Colors.black;

    final subtitleColor = isDark ? Colors.white70 : Colors.grey[700];

    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        title: Text(
          settings.locale.languageCode == 'ar'
              ? 'تعديل الملف الشخصي'
              : 'Edit Profile',
        ),

        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: textColor,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            /// PROFILE IMAGE
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue.withOpacity(0.15),

              child: const Icon(Icons.person, size: 50, color: Colors.blue),
            ),

            const SizedBox(height: 15),

            Text(
              settings.locale.languageCode == 'ar'
                  ? 'تعديل معلوماتك الشخصية'
                  : 'Update your personal information',

              style: TextStyle(color: subtitleColor, fontSize: 15),
            ),

            const SizedBox(height: 30),

            /// CARD
            Container(
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),

              child: Column(
                children: [
                  /// NAME
                  _buildField(
                    controller: nameController,

                    label: settings.locale.languageCode == 'ar'
                        ? 'الاسم الكامل'
                        : 'Full Name',

                    icon: Icons.person_outline,

                    textColor: textColor,
                  ),

                  const SizedBox(height: 20),

                  /// EMAIL
                  _buildField(
                    controller: emailController,

                    label: settings.locale.languageCode == 'ar'
                        ? 'البريد الإلكتروني'
                        : 'Email',

                    icon: Icons.email_outlined,

                    textColor: textColor,
                  ),

                  const SizedBox(height: 20),

                  /// PHONE
                  _buildField(
                    controller: phoneController,

                    label: settings.locale.languageCode == 'ar'
                        ? 'رقم الهاتف'
                        : 'Phone Number',

                    icon: Icons.phone_outlined,

                    textColor: textColor,
                  ),

                  const SizedBox(height: 30),

                  /// SAVE BUTTON
                  SizedBox(
                    width: double.infinity,

                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              settings.locale.languageCode == 'ar'
                                  ? 'تم تحديث الملف الشخصي'
                                  : 'Profile Updated Successfully',
                            ),
                          ),
                        );
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,

                        padding: const EdgeInsets.symmetric(vertical: 16),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),

                      child: Text(
                        settings.locale.languageCode == 'ar'
                            ? 'حفظ التغييرات'
                            : 'Save Changes',

                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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

      style: TextStyle(color: textColor),

      decoration: InputDecoration(
        labelText: label,

        labelStyle: TextStyle(color: textColor),

        prefixIcon: Icon(icon),

        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),

          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
      ),
    );
  }
}
