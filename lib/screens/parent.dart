import 'package:autism_world/screens/Parent/bookAppointment.dart';
import 'package:autism_world/screens/SpecialistList.dart';
import 'package:autism_world/screens/childPage.dart';
import 'package:autism_world/screens/parent/dailyProgress.dart';
import 'package:autism_world/screens/parent/events.dart';
import 'package:autism_world/screens/parent/resources.dart';
import 'package:autism_world/settings/settings.dart';
import 'package:autism_world/settings/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:autism_world/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class ParentPage extends StatefulWidget {
  const ParentPage({super.key});

  @override
  State<ParentPage> createState() => _ParentPageState();
}

class _ParentPageState extends State<ParentPage> {
  static const Color primaryBlue = Color(0xFF1E88E5);
  static const Color accentOrange = Color(0xFFFF9800);
  static const Color accentPurple = Color(0xFF9C27B0);
  static const Color accentTeal = Color(0xFF00897B);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final settings = Provider.of<SettingsProvider>(context);

    final isDark = settings.darkMode;

    final backgroundColor = isDark
        ? const Color(0xFF0F172A)
        : const Color(0xFFF5F7FA);

    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;

    final textColor = isDark ? Colors.white : Colors.black87;

    final subtitleColor = isDark ? Colors.white70 : Colors.grey[600];

    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        title: Text(
          l10n.appTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),

        backgroundColor: cardColor,

        elevation: 0,

        foregroundColor: textColor,

        actions: [
          IconButton(
            onPressed: () {},

            icon: Icon(Icons.notifications_none, color: subtitleColor),
          ),

          IconButton(
            onPressed: () {
              Navigator.push(
                context,

                MaterialPageRoute(
                  builder: (context) => const SettingsPage(role: "Parent"),
                ),
              );
            },

            icon: Icon(Icons.settings, color: subtitleColor),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              /// GREETING
              Text(
                l10n.helloParent,

                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                l10n.dailySummary,

                style: TextStyle(fontSize: 16, color: subtitleColor),
              ),

              const SizedBox(height: 25),

              /// UPCOMING
              Text(
                l10n.upNext,

                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),

              const SizedBox(height: 10),

              _buildUpcomingCard(l10n),

              const SizedBox(height: 25),

              /// CHILD PROFILE
              _buildChildProfileCTA(context, l10n),

              const SizedBox(height: 30),

              /// QUICK ACTIONS
              Text(
                l10n.quickActions,

                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),

              const SizedBox(height: 15),

              GridView.count(
                shrinkWrap: true,

                physics: const NeverScrollableScrollPhysics(),

                crossAxisCount: 2,

                crossAxisSpacing: 15,

                mainAxisSpacing: 15,

                childAspectRatio: 1.1,

                children: [
                  _buildMenuCard(
                    l10n.menuBookAppointment,
                    Icons.calendar_month_rounded,
                    primaryBlue,

                    () => Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (context) => const BookAppointment(),
                      ),
                    ),

                    isDark,
                  ),

                  _buildMenuCard(
                    l10n.menuSpecialists,
                    Icons.medical_services_rounded,
                    accentTeal,

                    () => Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (context) => SpecialistListPage(),
                      ),
                    ),

                    isDark,
                  ),

                  _buildMenuCard(
                    l10n.menuDailyProgress,
                    Icons.bar_chart_rounded,
                    accentOrange,

                    () => Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (context) => const DailyProgress(),
                      ),
                    ),

                    isDark,
                  ),

                  _buildMenuCard(
                    l10n.menuResources,
                    Icons.menu_book_rounded,
                    accentPurple,

                    () => Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (context) => ResourcesScreen(),
                      ),
                    ),

                    isDark,
                  ),

                  _buildMenuCard(
                    l10n.menuCommunityEvents,
                    Icons.diversity_3_rounded,
                    const Color(0xFFE91E63),

                    () => Navigator.push(
                      context,

                      MaterialPageRoute(builder: (context) => EventsScreen()),
                    ),

                    isDark,
                  ),
                ],
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  /// CHILD PROFILE CARD
  Widget _buildChildProfileCTA(BuildContext context, AppLocalizations l10n) {
    return InkWell(
      onTap: () => Navigator.push(
        context,

        MaterialPageRoute(builder: (context) => const ChildPage()),
      ),

      borderRadius: BorderRadius.circular(20),

      child: Container(
        width: double.infinity,

        padding: const EdgeInsets.all(20),

        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 4, 91, 161),

          borderRadius: BorderRadius.circular(20),

          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 4, 91, 161).withOpacity(0.4),

              blurRadius: 15,

              offset: const Offset(0, 8),
            ),
          ],
        ),

        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(15),

              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),

                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.child_care,
                color: Colors.white,
                size: 32,
              ),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    l10n.childProfileTitle,

                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    l10n.childProfileSubtitle,

                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.all(8),

              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.arrow_forward_ios,
                color: Color.fromARGB(255, 4, 91, 161),
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// MENU CARD
  Widget _buildMenuCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
    bool isDark,
  ) {
    return InkWell(
      onTap: onTap,

      borderRadius: BorderRadius.circular(20),

      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,

          borderRadius: BorderRadius.circular(20),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),

              blurRadius: 15,

              offset: const Offset(0, 5),
            ),
          ],
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Container(
              padding: const EdgeInsets.all(12),

              decoration: BoxDecoration(
                color: color.withOpacity(0.1),

                shape: BoxShape.circle,
              ),

              child: Icon(icon, color: color, size: 28),
            ),

            const SizedBox(height: 12),

            Text(
              title,

              textAlign: TextAlign.center,

              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// UPCOMING CARD
  Widget _buildUpcomingCard(AppLocalizations l10n) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: const Color.fromARGB(102, 0, 137, 123),

        borderRadius: BorderRadius.circular(20),
      ),

      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),

            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),

              borderRadius: BorderRadius.circular(12),
            ),

            child: Column(
              children: [
                Text(
                  l10n.timeHour,

                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                Text(
                  l10n.timePeriod,

                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  l10n.upcomingTherapy,

                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  l10n.upcomingDoctor,

                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
