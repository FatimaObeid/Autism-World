import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../settings/settings_provider.dart';
import 'edit_profile.dart';
import 'change_password.dart';

class SettingsPage extends StatelessWidget {
  final String role;

  const SettingsPage({super.key, required this.role});

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
    final subtitleColor = isDark ? Colors.white70 : Colors.grey;

    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        title: Text(l10n.appTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: textColor,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            /// HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: _getGradient(role)),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Icon(_getIcon(role), size: 40, color: Colors.blue),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    role,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _card(cardColor, [
                    _tile(
                      Icons.person,
                      l10n.editProfile,
                      textColor,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EditProfilePage(),
                          ),
                        );
                      },
                    ),
                    const Divider(),
                    _tile(
                      Icons.lock,
                      l10n.changePassword,
                      textColor,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ChangePasswordPage(),
                          ),
                        );
                      },
                    ),
                  ]),

                  const SizedBox(height: 20),

                  _card(cardColor, [
                    /// DARK MODE
                    SwitchListTile(
                      value: settings.darkMode,
                      onChanged: (value) {
                        settings.toggleDarkMode(value);
                      },
                      title: Text(
                        l10n.darkMode,
                        style: TextStyle(color: textColor),
                      ),
                      subtitle: Text(
                        "Enable dark mode",
                        style: TextStyle(color: subtitleColor),
                      ),
                      secondary: const Icon(Icons.dark_mode),
                    ),

                    const Divider(),

                    /// LANGUAGE
                    ListTile(
                      leading: const Icon(Icons.language, color: Colors.blue),
                      title: Text(
                        l10n.language,
                        style: TextStyle(color: textColor),
                      ),
                      subtitle: Text(
                        settings.locale.languageCode == 'ar'
                            ? "العربية"
                            : "English",
                        style: TextStyle(color: subtitleColor),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.language),
                            onPressed: () {
                              settings.setLocale(const Locale('en'));
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.translate),
                            onPressed: () {
                              settings.setLocale(const Locale('ar'));
                            },
                          ),
                        ],
                      ),
                    ),
                  ]),

                  const SizedBox(height: 30),

                  /// LOGOUT
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.all(15),
                      ),
                      icon: const Icon(Icons.logout),
                      label: Text(l10n.logout),
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

  // HELPERS
  Widget _sectionTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: color,
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
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  List<Color> _getGradient(String role) {
    switch (role) {
      case "Parent":
        return [Colors.blue, Colors.indigo];
      case "Specialist":
        return [Colors.teal, Colors.green];
      case "Volunteer":
        return [Colors.orange, Colors.deepOrange];
      default:
        return [Colors.blue, Colors.indigo];
    }
  }

  IconData _getIcon(String role) {
    switch (role) {
      case "Parent":
        return Icons.family_restroom;
      case "Specialist":
        return Icons.medical_services;
      case "Volunteer":
        return Icons.volunteer_activism;
      default:
        return Icons.person;
    }
  }
}
