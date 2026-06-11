import 'package:flutter/material.dart';
import 'package:autism_world/l10n/app_localizations.dart';
import 'package:autism_world/screens/settings.dart';
import 'package:autism_world/screens/settings_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class VolunteerDashboard extends StatefulWidget {
  // Clear the static string property parameter completely
  const VolunteerDashboard({super.key});

  @override
  State<VolunteerDashboard> createState() => _VolunteerDashboardState();
}

class _VolunteerDashboardState extends State<VolunteerDashboard> {
  // --- COLORS ---
  static const Color primaryBlue = Color(0xFF1E88E5);
  static const Color primaryDarkBlue = Color(0xFF1565C0);
  static const Color accentOrange = Color(0xFFFF9800);
  static const Color accentPurple = Color(0xFF9C27B0);
  static const Color accentGreen = Color(0xFF4CAF50);

  // --- API SETTINGS ---
  final String _baseUrl = 'http://127.0.0.1:8000/api/volunteer';

  // --- DYNAMIC DATA ---
  List<dynamic> _workshops = [];
  Map<String, dynamic> _summary = {
    'total_workshops': 0,
    'approved_count': 0,
    'pending_count': 0,
  };

  // Track profile attributes directly from the API response payload mappings
  String _volunteerName = "";

  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // GET: Fetch layout profile dashboard maps and workshop arrays
  Future<void> _fetchDashboardData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse('$_baseUrl/dashboard'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        setState(() {
          _workshops = responseData['workshops'] ?? [];
          _summary = responseData['dashboard_summary'] ?? _summary;

          // Read name string directly out of the database data map model fields
          if (responseData['profile'] != null) {
            _volunteerName = responseData['profile']['name'] ?? "Volunteer";
          }

          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Server error: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Connection error. Check your local server status.';
        _isLoading = false;
      });
    }
  }

  Future<void> _submitWorkshopToBackend(Map<String, String> payload) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          const Center(child: CircularProgressIndicator(color: primaryBlue)),
    );

    try {
      final token = await _getToken();
      final response = await http.post(
        Uri.parse('$_baseUrl/workshops'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(payload),
      );

      if (mounted) Navigator.pop(context); // Dismiss loading dialog

      if (response.statusCode == 201) {
        _fetchDashboardData();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Workshop submitted successfully!'),
              backgroundColor: accentGreen,
            ),
          );
        }
      } else {
        final errorBody = json.decode(response.body);
        _showErrorSnackBar(errorBody['message'] ?? 'Failed to add workshop.');
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      _showErrorSnackBar('Network error. Failed to save workshop.');
    }
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  List<dynamic> get _approvedList => _workshops
      .where((w) => w['status'] == 'approved' || w['status'] == 'Approved')
      .toList();

  List<dynamic> get _pendingList => _workshops
      .where((w) => w['status'] == 'pending' || w['status'] == 'Pending')
      .toList();

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

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            l10n.appTitle,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: cardColor,
          elevation: 0,
          foregroundColor: textColor,
          actions: [
            IconButton(
              onPressed: _fetchDashboardData,
              icon: Icon(Icons.refresh, color: subtitleColor),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsPage(role: "Volunteer"),
                  ),
                );
              },
              icon: Icon(Icons.settings, color: subtitleColor),
            ),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator(color: primaryBlue))
            : _errorMessage != null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _fetchDashboardData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                      ),
                      child: const Text(
                        'Retry',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              )
            : RefreshIndicator(
                onRefresh: _fetchDashboardData,
                color: primaryBlue,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
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
                                  Icons.volunteer_activism,
                                  color: Colors.white,
                                  size: 28,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    // Uses the dynamic string state element tracking from your backend API
                                    l10n.welcomeVolunteer(_volunteerName),
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
                              l10n.volunteerDashboardSubtitle,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      // --- STATS CORES ---
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              title: l10n.totalWorkshops,
                              value: _summary['total_workshops'].toString(),
                              icon: Icons.workspace_premium,
                              color: primaryBlue,
                              cardColor: cardColor,
                              textColor: textColor,
                              subtitleColor: subtitleColor,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              title: l10n.approved,
                              value: _summary['approved_count'].toString(),
                              icon: Icons.check_circle,
                              color: accentGreen,
                              cardColor: cardColor,
                              textColor: textColor,
                              subtitleColor: subtitleColor,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              title: l10n.pending,
                              value: _summary['pending_count'].toString(),
                              icon: Icons.pending_actions,
                              color: accentOrange,
                              cardColor: cardColor,
                              textColor: textColor,
                              subtitleColor: subtitleColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),

                      // --- TITLE + BUTTON ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.myWorkshops,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () => _showAddModal(context),
                            icon: const Icon(Icons.add),
                            label: Text(l10n.addNewWorkshop),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryBlue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // --- TAB BAR ---
                      Container(
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TabBar(
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: primaryBlue.withOpacity(0.1),
                          ),
                          indicatorColor: Colors.transparent,
                          indicatorSize: TabBarIndicatorSize.tab,
                          labelColor: primaryBlue,
                          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                          unselectedLabelColor: subtitleColor,
                          dividerColor: Colors.transparent,
                          tabs: [
                            Tab(text: l10n.approvedTab),
                            Tab(text: l10n.pendingTab),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // --- TAB VIEWS MAPS ---
                      SizedBox(
                        height: 450,
                        child: TabBarView(
                          children: [
                            _approvedList.isEmpty
                                ? _buildEmptyState(
                                    Icons.check_circle_outline,
                                    l10n.noApprovedWorkshops,
                                    subtitleColor,
                                  )
                                : ListView.builder(
                                    itemCount: _approvedList.length,
                                    itemBuilder: (context, index) =>
                                        _buildWorkshopCard(
                                          item: _approvedList[index],
                                          cardColor: cardColor,
                                          textColor: textColor,
                                          subtitleColor: subtitleColor,
                                        ),
                                  ),
                            _pendingList.isEmpty
                                ? _buildEmptyState(
                                    Icons.pending_actions,
                                    l10n.noPendingWorkshops,
                                    subtitleColor,
                                  )
                                : ListView.builder(
                                    itemCount: _pendingList.length,
                                    itemBuilder: (context, index) =>
                                        _buildWorkshopCard(
                                          item: _pendingList[index],
                                          cardColor: cardColor,
                                          textColor: textColor,
                                          subtitleColor: subtitleColor,
                                        ),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildEmptyState(IconData icon, String text, Color? color) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: color),
          const SizedBox(height: 10),
          Text(text, style: TextStyle(color: color)),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required Color cardColor,
    required Color textColor,
    required Color? subtitleColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(color: subtitleColor, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkshopCard({
    required Map<String, dynamic> item,
    required Color cardColor,
    required Color textColor,
    required Color? subtitleColor,
  }) {
    final String title = item['title'] ?? '';
    final String location = item['location'] ?? '';
    final String ageGroup = item['age_group'] ?? '';
    final String dateStr = item['date'] ?? '';
    final String timeStr = item['workshop_time'] ?? '';
    final String rawStatus = item['status'] ?? 'pending';

    final bool isApproved = rawStatus.toLowerCase() == 'approved';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border(left: BorderSide(color: isApproved ? accentGreen : accentOrange, width: 5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$dateStr • $timeStr",
                style: TextStyle(color: subtitleColor),
              ),
              const SizedBox(height: 4),
              Text(location, style: TextStyle(color: subtitleColor)),
              const SizedBox(height: 4),
              Text(ageGroup, style: TextStyle(color: subtitleColor)),
            ],
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isApproved
                ? accentGreen.withOpacity(0.1)
                : accentOrange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            rawStatus.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isApproved ? accentGreen : accentOrange,
            ),
          ),
        ),
      ),
    );
  }

  void _showAddModal(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final formKey = GlobalKey<FormState>();

    final titleController = TextEditingController();
    final locationController = TextEditingController();
    final ageController = TextEditingController();
    final dateController = TextEditingController();
    final timeController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.newWorkshopDetails,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: l10n.workshopTitle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Required field' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: dateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: '${l10n.date} (YYYY-MM-DD)',
                      suffixIcon: const Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now().add(
                          const Duration(days: 1),
                        ),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        dateController.text = picked.toIso8601String().split(
                          'T',
                        )[0];
                      }
                    },
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Required field' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: timeController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: '${l10n.time} (HH:MM)',
                      suffixIcon: const Icon(Icons.access_time),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onTap: () async {
                      TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: const TimeOfDay(hour: 16, minute: 0),
                      );
                      if (picked != null) {
                        final localM = picked.minute.toString().padLeft(2, '0');
                        final localH = picked.hour.toString().padLeft(2, '0');
                        timeController.text = '$localH:$localM';
                      }
                    },
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Required field' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: ageController,
                    decoration: InputDecoration(
                      labelText: "${l10n.ageGroup} (e.g. Kids 8-12)",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Required field' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: locationController,
                    decoration: InputDecoration(
                      labelText: l10n.location,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Required field' : null,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          Navigator.pop(context);
                          _submitWorkshopToBackend({
                            "title": titleController.text.trim(),
                            "date": dateController.text.trim(),
                            "workshop_time": timeController.text.trim(),
                            "age_group": ageController.text.trim(),
                            "location": locationController.text.trim(),
                          });
                        }
                      },
                      child: Text(l10n.submit),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
