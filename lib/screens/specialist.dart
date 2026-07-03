import 'dart:convert';
import 'package:autism_world/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Fixed: Added missing http import
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:autism_world/l10n/app_localizations.dart';
import 'package:autism_world/screens/settings.dart';
import 'package:autism_world/screens/settings_provider.dart';
import 'package:autism_world/specialist/community_events.dart';
import 'package:autism_world/specialist/myclientsPage.dart';
import 'package:autism_world/specialist/pending_requests_page.dart';
import 'package:autism_world/specialist/upcoming_appt.dart';

class SpecialistPage extends StatefulWidget {
  const SpecialistPage({super.key});

  @override
  State<SpecialistPage> createState() => _SpecialistPageState();
}

class _SpecialistPageState extends State<SpecialistPage> {
  static const Color primaryBlue = Color(0xFF1E88E5);
  static const Color primaryDarkBlue = Color(0xFF1565C0);
  static const Color accentOrange = Color(0xFFFF9800);
  static const Color accentPurple = Color(0xFF9C27B0);
  static const Color accentTeal = Color(0xFF00897B);
  static const Color accentPink = Color(0xFFE91E63);

  String _specialistName = '';
  String _specialization = '';
  Map<String, dynamic>? _nextAppointment;
  int _todaysAppointments = 0;
  bool _isLoading = true;
  String? _error;
  static const String baseUrl = 'http://127.0.0.1:8000';

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    final token = await _getToken();
    if (token == null) {
      _redirectToLogin();
      return;
    }
    try {
      final token = await _getToken();

      final response = await http.get(
        Uri.parse('$baseUrl/api/specialist/dashboard'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      print('status ${response.statusCode}');
      print('body ${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _specialistName = data['specialist_name'] ?? 'Specialist';
          _specialization = data['specialization'] ?? 'Specialist';
          _nextAppointment = data['next_appointment'];
          _todaysAppointments = data['today_appointments'] ?? 0;
          _isLoading = false;
        });
      } else if (response.statusCode == 401) {
        _redirectToLogin();
      } else {
        setState(() {
          _error = 'Failed to load data. Please try again.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'An error occurred. Please check your connection.';
        _isLoading = false;
      });
    }
  }

  void _redirectToLogin() {
    if (mounted) {
      // Replace pushNamedAndRemoveUntil with MaterialPageRoute
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ), // Import your LoginPage widget
        (route) => false,
      );
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    _redirectToLogin();
  }

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
        // Handled: Show screens dynamically based on network state
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_error!, style: TextStyle(color: textColor)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadDashboardData,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- WELCOME CARD ---
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
                              // NEW CODE
                              Expanded(
                                child: Text(
                                  l10n.welcomeSpecialist(
                                    _specialization,
                                    _specialistName,
                                  ),
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
                            // Fixed: Swapped appointmentCount for _todaysAppointments
                            l10n.appointmentsCount(_todaysAppointments),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
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

                    // Handled: Dynamically rendering next appointment if it exists
                    _buildUpcomingAppointmentCard(
                      cardColor: cardColor,
                      textColor: textColor,
                      subtitleColor: subtitleColor,
                      l10n: l10n,
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
                          page: MyClientsPage(),
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

  // Helper Widget for the dynamic "Up Next" logic
  Widget _buildUpcomingAppointmentCard({
    required Color cardColor,
    required Color textColor,
    required Color? subtitleColor,
    required AppLocalizations l10n,
  }) {
    if (_nextAppointment == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          "No upcoming appointments today",
          style: TextStyle(color: subtitleColor, fontSize: 14),
          textAlign: TextAlign.center,
        ),
      );
    }

    // Assumes your API response map includes keys like 'time', 'title', and 'client_name'
    final String time = _nextAppointment!['time'] ?? '--:--';
    final String title = _nextAppointment!['title'] ?? 'Session';
    final String clientName = _nextAppointment!['child_name'] ?? 'Client';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: const Border(left: BorderSide(color: accentTeal, width: 5)),
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
                time,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: textColor,
                ),
              ),
              Text(
                _nextAppointment!['starts_in'] ?? '',
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
              Text(title, style: TextStyle(color: subtitleColor, fontSize: 14)),
              Text(
                clientName,
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

