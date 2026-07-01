import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:autism_world/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpcomingAppointmentsPage extends StatefulWidget {
  const UpcomingAppointmentsPage({super.key});

  @override
  State<UpcomingAppointmentsPage> createState() =>
      _UpcomingAppointmentsPageState();
}

class _UpcomingAppointmentsPageState extends State<UpcomingAppointmentsPage> {
  // --- Design Constants ---
  static const _bgColor = Color(0xFFFAFAFA);
  static const _cardColor = Colors.white;
  static const _textPrimary = Colors.black;
  static const _textSecondary = Colors.grey;

  static const _colorTherapy = Colors.green;
  static const _colorCheckup = Colors.blue;
  static const _colorConsultation = Colors.orange;
  static const _colorFollowUp = Colors.purple;

  // --- State Variables ---
  List<Map<String, dynamic>> _upcomingAppointments = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchAppointments();
  }

  Future<void> _fetchAppointments() async {
    const String baseUrl = 'http://127.0.0.1:8000';
    final url = Uri.parse('$baseUrl/api/specialist/upcoming-appointments');

    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      Future<String?> _getToken() async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        return prefs.getString('auth_token');
      }

      final token = await _getToken();

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          setState(() {
            _upcomingAppointments = List<Map<String, dynamic>>.from(
              responseData['upcoming_appointments'],
            );
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage =
                'Failed to load appointments processing backend logic';
            _isLoading = false;
          });
        }
      } else if (response.statusCode == 401) {
        setState(() {
          _errorMessage = 'Unauthorized. Please log in again.';
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
        _errorMessage = 'Connection failed: $e';
        _isLoading = false;
      });
    }
  }

  String _getTagText(String key, AppLocalizations l10n) {
    switch (key.toLowerCase()) {
      case 'therapy':
      case 'therapy_session':
        return l10n.tagTherapy;
      case 'check-up':
      case 'checkup':
        return l10n.tagCheckup;
      case 'consultation':
        return l10n.tagConsultation;
      default:
        return l10n.tagFollowup;
    }
  }

  Color _getTagColor(String key) {
    switch (key.toLowerCase()) {
      case 'therapy':
      case 'therapy_session':
        return _colorTherapy;
      case 'check-up':
      case 'checkup':
        return _colorCheckup;
      case 'consultation':
        return _colorConsultation;
      default:
        return _colorFollowUp;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: _bgColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: _textPrimary),
        title: Text(
          l10n.upcomingAppointmentsTitle,
          style: const TextStyle(
            color: _textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _buildBody(l10n),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 14),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _fetchAppointments,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_upcomingAppointments.isEmpty) {
      return RefreshIndicator(
        onRefresh: _fetchAppointments,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 100),
            Center(
              child: Text(
                'No upcoming appointments found.',
                style: TextStyle(color: _textSecondary, fontSize: 15),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchAppointments,
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _upcomingAppointments.length,
        itemBuilder: (context, index) {
          final appointment = _upcomingAppointments[index];

          // Safely extracts fields matching backend mapping format
          final String childName = appointment['child_name'] ?? 'Unknown Child';
          final String sessionType = appointment['session_type'] ?? 'Therapy';
          final String appointmentTime = appointment['time'] ?? '00:00 AM';
          final String rawDate = appointment['date'] ?? 'Mon 12 Feb';

          // Parsed date format: "D d M" (e.g., "Mon 12 Feb")
          String day = 'Day';
          String monthDay = 'Date';
          final dateParts = rawDate.split(' ');
          if (dateParts.length >= 3) {
            day = dateParts[0]; // "Mon"
            monthDay = "${dateParts[1]} ${dateParts[2]}"; // "12 Feb"
          } else {
            monthDay = rawDate;
          }

          final tagColor = _getTagColor(sessionType);

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: _colorCheckup.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Text(
                        day,
                        style: const TextStyle(
                          color: _colorCheckup,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        monthDay,
                        style: const TextStyle(
                          color: _colorCheckup,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        childName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 14,
                            color: _textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            appointmentTime,
                            style: const TextStyle(
                              color: _textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: tagColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getTagText(sessionType, l10n),
                    style: TextStyle(
                      color: tagColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

