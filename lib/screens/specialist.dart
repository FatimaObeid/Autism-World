import 'package:autism_world/pending_requests_page.dart';
import 'package:autism_world/screens/specialist/communityEvents.dart';
import 'package:autism_world/screens/specialist/myClientsPage.dart';
import 'package:autism_world/screens/specialist/upcoming_appt.dart';
import 'package:autism_world/settings/settings.dart';
import 'package:autism_world/settings/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:autism_world/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class SpecialistPage extends StatelessWidget {
  const SpecialistPage({super.key});

  static const Color primaryBlue = Color(0xFF1E88E5);
  static const Color primaryDarkBlue = Color(0xFF1565C0);

  static const Color accentOrange = Color(0xFFFF9800);
  static const Color accentPurple = Color(0xFF9C27B0);
  static const Color accentTeal = Color(0xFF00897B);
  static const Color accentPink = Color(0xFFE91E63);

  static const _headerStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

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

    final doctorName = "John";
    final appointmentCount = "3";

    return PopScope(
      canPop: false,

      child: Scaffold(
        backgroundColor: backgroundColor,

        appBar: AppBar(
          automaticallyImplyLeading: false,

          title: Text(
            l10n.appTitle,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),

          backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,

          elevation: 0,

          foregroundColor: textColor,

          actions: [
            IconButton(
              onPressed: () {},

              icon: Icon(
                Icons.notifications_none,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),

            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const SettingsPage(role: "Specialist"),
                  ),
                );
              },

              icon: Icon(
                Icons.settings,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ),

        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // --- WELCOME BANNER ---
              Container(
                padding: const EdgeInsets.all(24),

                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [primaryBlue, primaryDarkBlue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),

                  borderRadius: BorderRadius.circular(20),

                  boxShadow: [
                    BoxShadow(
                      color: primaryBlue.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 28,
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Text(
                            l10n.welcomeSpecialist(doctorName),

                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Text(
                      l10n.appointmentsCount(appointmentCount),

                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // --- UP NEXT SECTION ---
              Text(
                l10n.upNextSpecialist,

                style: _headerStyle.copyWith(color: textColor),
              ),

              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: cardColor,

                  borderRadius: BorderRadius.circular(20),

                  border: const Border(
                    left: BorderSide(color: accentTeal, width: 5),
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.08),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),

                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          "10:00 AM",

                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: textColor,
                          ),
                        ),

                        Text(
                          l10n.startsInMinutes("15"),

                          style: const TextStyle(
                            color: accentTeal,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(width: 20),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          "Therapy Session",

                          style: TextStyle(color: subtitleColor, fontSize: 14),
                        ),

                        Text(
                          "Sarah Smith",

                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    const Icon(Icons.person, color: accentTeal),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // --- PRACTICE OVERVIEW GRID ---
              Text(
                l10n.practiceOverview,

                style: _headerStyle.copyWith(color: textColor),
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
                    context: context,
                    title: l10n.pendingRequestsButton,
                    icon: Icons.notifications_active_rounded,
                    color: accentOrange,
                    page: const PendingRequestsPage(),
                    textColor: textColor,
                    cardColor: cardColor,
                  ),

                  _buildMenuCard(
                    context: context,
                    title: l10n.todayAppointmentsButton,
                    icon: Icons.calendar_today_rounded,
                    color: primaryBlue,
                    page: const UpcomingAppointmentsPage(),
                    textColor: textColor,
                    cardColor: cardColor,
                  ),

                  _buildMenuCard(
                    context: context,
                    title: l10n.myClientsButton,
                    icon: Icons.people_alt_rounded,
                    color: accentPurple,
                    page: const MyClientsPage(),
                    textColor: textColor,
                    cardColor: cardColor,
                  ),

                  _buildMenuCard(
                    context: context,
                    title: l10n.communityEventsButton,
                    icon: Icons.event_rounded,
                    color: accentPink,
                    page: const CommunityEventsPage(),
                    textColor: textColor,
                    cardColor: cardColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required Widget page,
    required Color textColor,
    required Color cardColor,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },

      borderRadius: BorderRadius.circular(20),

      child: Container(
        decoration: BoxDecoration(
          color: cardColor,

          borderRadius: BorderRadius.circular(20),

          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
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

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),

              child: Text(
                title,

                textAlign: TextAlign.center,

                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
