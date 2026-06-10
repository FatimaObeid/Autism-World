import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
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
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

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

  // Runtime properties loaded from backend
  String _parentName = "";
  Map<String, dynamic>? _upcomingAppointment;
  bool _isLoadingDashboard = true;

  String get baseUrl {
    if (kIsWeb) return "http://127.0.0.1:8000";
    if (Platform.isAndroid) return "http://10.0.2.2:8000";
    return "http://127.0.0.1:8000";
  }

  @override
  void initState() {
    super.initState();
    _fetchDashboardPayload();
  }

  /// Request profile metadata and active booked appointments from ParentProfileController
  Future<void> _fetchDashboardPayload() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      final response = await http.get(
        Uri.parse("$baseUrl/api/parent/dashboard"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          setState(() {
            _parentName = responseData['parent_name'] ?? "";
            _upcomingAppointment = responseData['upcoming_appointment'];
            _isLoadingDashboard = false;
          });
        }
      } else {
        setState(() => _isLoadingDashboard = false);
      }
    } catch (e) {
      setState(() => _isLoadingDashboard = false);
    }
  }

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

    // Combine localization greeting with real backend parent name safely
    final displayGreeting = _parentName.isNotEmpty
        ? "${l10n.helloParent} $_parentName"
        : l10n.helloParent;

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
      body: RefreshIndicator(
        onRefresh: _fetchDashboardPayload,
        color: primaryBlue,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// GREETING WITH REGISTERED NAME
                Text(
                  displayGreeting,
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

                /// REAL BOOKED UPCOMING SECTION
                Text(
                  l10n.upNext,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 10),

                _isLoadingDashboard
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: CircularProgressIndicator(color: primaryBlue),
                        ),
                      )
                    : _buildUpcomingCard(l10n, cardColor, textColor),

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
                          builder: (context) => const ResourcesScreen(),
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

  /// DYNAMIC UPCOMING CARD
  Widget _buildUpcomingCard(
    AppLocalizations l10n,
    Color cardColor,
    Color currentTextColor,
  ) {
    // Graceful placeholder widget if the parent doesn't have an upcoming booked session row
    if (_upcomingAppointment == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.withOpacity(0.15)),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, color: Colors.blueGrey, size: 26),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                "No upcoming appointments found.",
                style: TextStyle(
                  color: currentTextColor.withOpacity(0.6),
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Safely pull eager loaded relations (specialist -> user -> name) matching your model properties
    final typeString = _upcomingAppointment!['type'] ?? l10n.upcomingTherapy;

    String doctorName = l10n.upcomingDoctor;
    if (_upcomingAppointment!['specialist'] != null &&
        _upcomingAppointment!['specialist']['user'] != null) {
      doctorName =
          _upcomingAppointment!['specialist']['user']['name'] ??
          l10n.upcomingDoctor;
    }

    // Parse appointments timestamp
    final rawTimeStr = _upcomingAppointment!['appointment_time'];
    String formattedHour = "00:00";
    String formattedPeriod = "AM";

    if (rawTimeStr != null) {
      try {
        DateTime parsedDate = DateTime.parse(rawTimeStr.toString());
        formattedHour = DateFormat('hh:mm').format(parsedDate);
        formattedPeriod = DateFormat('a').format(parsedDate); // AM or PM
      } catch (_) {}
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF00695C), // Opaque aesthetic teal
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00695C).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  formattedHour,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  formattedPeriod,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
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
                  typeString,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  doctorName,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
