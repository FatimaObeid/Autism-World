import 'package:autism_world/screens/settings_provider.dart';
import 'package:autism_world/screens/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../screens/login.dart';

import 'edit_profile.dart';
import 'change_password.dart';

class SettingsPage extends StatefulWidget {
  final String role;

  const SettingsPage({super.key, required this.role});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    // Fetch fresh profile data from Laravel API when entering the page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SettingsProvider>(context, listen: false).fetchUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final l10n = AppLocalizations.of(context)!;

    final isDark = settings.darkMode;
    final isArabic = settings.locale.languageCode == 'ar';

    final backgroundColor = isDark
        ? const Color(0xFF0F172A)
        : const Color(0xFFF5F7FA);
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final subtitleColor = isDark ? Colors.white70 : Colors.grey;

    // Loading State
    if (settings.isLoading && settings.userData == null) {
      return Scaffold(
        backgroundColor: backgroundColor,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // Read live values from Laravel payload or fallback to local defaults if null
    final userName = settings.userData?['name'] ?? "User";
    final userEmail = settings.userData?['email'] ?? "email@example.com";
    final displayedRole = settings.userData?['role'] ?? widget.role;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(l10n.appTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: textColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // PROFILE CARD DISPLAY
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _getGradient(displayedRole),
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: Icon(
                      _getIcon(displayedRole),
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          userEmail,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            displayedRole,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // ERROR FEEDBACK IF SERVER CALL FAILS
            if (settings.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Text(
                  settings.errorMessage!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

            // ACCOUNT CONTROLS SECTION
            Align(
              alignment: isArabic
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Text(
                isArabic ? "الحساب" : "Account Settings",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade400,
                ),
              ),
            ),
            const SizedBox(height: 10),
            _card(cardColor, [
              _tile(
                Icons.person_outline,
                isArabic ? "تعديل الملف الشخصي" : "Edit Profile",
                textColor,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EditProfilePage(role: displayedRole.toLowerCase()),
                    ),
                  );
                },
              ),
              const Divider(height: 1),
              _tile(
                Icons.lock_outline,
                isArabic ? "تغيير كلمة المرور" : "Change Password",
                textColor,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChangePasswordPage(),
                    ),
                  );
                },
              ),
            ]),
            const SizedBox(height: 25),

            // INTERFACE SYSTEM CONTROLS
            Align(
              alignment: isArabic
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Text(
                isArabic ? "النظام" : "App Preferences",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade400,
                ),
              ),
            ),
            const SizedBox(height: 10),
            _card(cardColor, [
              // DARK MODE TOGGLE ROW
              SwitchListTile(
                secondary: const Icon(
                  Icons.dark_mode_outlined,
                  color: Colors.blue,
                ),
                title: Text(
                  isArabic ? "الوضع الداكن" : "Dark Mode",
                  style: TextStyle(color: textColor),
                ),
                value: settings.darkMode,
                onChanged: (bool value) {
                  settings.toggleDarkMode(value);
                },
              ),
              const Divider(height: 1),
              // LANGUAGE ROTATION ROW
              ListTile(
                leading: const Icon(Icons.language, color: Colors.blue),
                title: Text(
                  isArabic ? "اللغة" : "Language",
                  style: TextStyle(color: textColor),
                ),
                trailing: Text(
                  isArabic ? "العربية" : "English",
                  style: TextStyle(
                    color: subtitleColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  if (settings.locale.languageCode == 'en') {
                    settings.setLocale(const Locale('ar'));
                  } else {
                    settings.setLocale(const Locale('en'));
                  }
                },
              ),
            ]),
            const SizedBox(height: 35),

            // SIGN OUT BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  // 1. Wipe Sanctum tokens out of local disk storage
                  await SettingsStorage.clearAuthData();

                  if (!context.mounted) return;

                  // 2. Erase routing loops and redirect back to LoginPage
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  isArabic ? "تسجيل الخروج" : "Log Out",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card(Color color, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(children: children),
    );
  }

  Widget _tile(
    IconData icon,
    String title,
    Color textColor, {
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title, style: TextStyle(color: textColor)),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }

  List<Color> _getGradient(String role) {
    switch (role.toLowerCase()) {
      case "parent":
        return [Colors.blue, Colors.indigo];
      case "specialist":
        return [Colors.teal, Colors.green];
      case "volunteer":
        return [Colors.orange, Colors.deepOrange];
      default:
        return [Colors.blue, Colors.indigo];
    }
  }

  IconData _getIcon(String role) {
    switch (role.toLowerCase()) {
      case "parent":
        return Icons.family_restroom;
      case "specialist":
        return Icons.health_and_safety;
      case "volunteer":
        return Icons.volunteer_activism;
      default:
        return Icons.person;
    }
  }
}
