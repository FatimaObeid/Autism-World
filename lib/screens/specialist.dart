import 'package:autism_world/specialist/community_events.dart';
import 'package:autism_world/specialist/myclientsPage.dart';
import 'package:autism_world/specialist/upcoming_appt.dart';
import 'package:flutter/material.dart';
import 'package:autism_world/l10n/app_localizations.dart';
import 'pending_requests_page.dart';

class SpecialistPage extends StatelessWidget {
  const SpecialistPage({super.key});

  // Consistent app colors matching ParentPage
  static const Color primaryBlue = Color(0xFF1E88E5);
  static const Color primaryDarkBlue = Color(0xFF1565C0); // For the gradient
  static const Color accentOrange = Color(0xFFFF9800);
  static const Color accentPurple = Color(0xFF9C27B0);
  static const Color accentTeal = Color(0xFF00897B);
  static const Color accentPink = Color(0xFFE91E63);
  static const Color backgroundLight = Color(0xFFF5F7FA);

  static const _headerStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // In a real app, these would come from user data.
    final doctorName = "John";
    final appointmentCount = "3";

    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(
        title: Text(
          l10n.appTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none, color: Colors.black54),
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
                      const Icon(Icons.favorite, color: Colors.white, size: 28),
                      const SizedBox(width: 12),
                      Text(
                        l10n.welcomeSpecialist(doctorName),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
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
            Text(l10n.upNextSpecialist, style: _headerStyle),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
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
                      const Text(
                        "10:00 AM",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
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
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      const Text(
                        "Sarah Smith",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
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
            Text(l10n.practiceOverview, style: _headerStyle),
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
                ),
                _buildMenuCard(
                  context: context,
                  title: l10n.todayAppointmentsButton,
                  icon: Icons.calendar_today_rounded,
                  color: primaryBlue,
                  page: const UpcomingAppointmentsPage(),
                ),
                _buildMenuCard(
                  context: context,
                  title: l10n.myClientsButton,
                  icon: Icons.people_alt_rounded,
                  color: accentPurple,
                  page: const MyClientsPage(),
                ),
                _buildMenuCard(
                  context: context,
                  title: l10n.communityEventsButton,
                  icon: Icons.event_rounded,
                  color: accentPink,
                  page: const CommunityEventsPage(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Styled exactly like the ParentPage menu cards
  Widget _buildMenuCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required Widget page,
  }) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => page),
      ),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
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
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
