import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:autism_world/l10n/app_localizations.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  static const Color primaryBlue = Color(0xFF1E88E5);

  List<dynamic> _serverEvents = [];
  bool _isLoading = true;
  String? _errorMessage;

  String get baseUrl {
    if (kIsWeb) return "http://127.0.0.1:8000";
    if (Platform.isAndroid) return "http://10.0.2.2:8000";
    return "http://127.0.0.1:8000";
  }

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      final response = await http.get(
        Uri.parse("$baseUrl/api/parent/events"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['success'] == true && data['data'] != null) {
          setState(() {
            _serverEvents = data['data'];
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage = "Invalid data format received from server.";
            _isLoading = false;
          });
        }
      } else {
        print(
          "LARAVEL ERROR (Status ${response.statusCode}): ${response.body}",
        );
        setState(() {
          _errorMessage = "Server error: ${response.statusCode}";
          _isLoading = false;
        });
      }
    } catch (e) {
      print("FLUTTER NETWORK ERROR: $e");
      setState(() {
        _errorMessage = "Network error. Please check your connection.";
        _isLoading = false;
      });
    }
  }

  // --- NEW FUNCTION: Registers the Parent for the Event ---
  Future<void> _registerForEvent(int eventId, int index) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      // Calling the backend route to approve attendance
      final response = await http.post(
        Uri.parse("$baseUrl/api/parent/events/$eventId/approve-attendance"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Update the UI immediately so the button turns grey!
        setState(() {
          _serverEvents[index]['is_registered'] = true;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Successfully registered for the event!'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseData['message'] ?? 'Could not register.'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      print("Registration Error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Network error while registering.'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Make sure your AppLocalizations are set up properly
    final l10n = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          l10n.eventsTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: _buildBody(l10n, isArabic),
    );
  }

  Widget _buildBody(AppLocalizations l10n, bool isArabic) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: primaryBlue));
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off, size: 60, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(_errorMessage!, style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _errorMessage = null;
                });
                _fetchEvents();
              },
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: const Text("Retry", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: primaryBlue),
            ),
          ],
        ),
      );
    }

    if (_serverEvents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text(
              "No upcoming events available right now.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _serverEvents.length,
      itemBuilder: (context, index) {
        final event = _serverEvents[index];

        final title = isArabic
            ? (event['title_ar'] ?? event['title'] ?? 'No Title')
            : (event['title_en'] ?? event['title'] ?? 'No Title');

        final location = isArabic
            ? (event['location_ar'] ?? event['location'] ?? 'TBD')
            : (event['location_en'] ?? event['location'] ?? 'TBD');

        final description = isArabic
            ? (event['description_ar'] ??
                  event['description'] ??
                  'No description')
            : (event['description_en'] ??
                  event['description'] ??
                  'No description');

        final date = event['date'] ?? 'Date TBD';
        final time = event['time'] ?? '';
        final isRegistered = event['is_registered'] == true;

        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 16),
          shadowColor: Colors.black12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: primaryBlue.withOpacity(0.1),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                ),
                child: const Icon(
                  Icons.event_available_rounded,
                  size: 50,
                  color: primaryBlue,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_month,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          time.isNotEmpty ? "$date at $time" : date.toString(),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            location,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      description,
                      style: TextStyle(color: Colors.grey[800], height: 1.4),
                    ),
                    const SizedBox(height: 15),

                    // --- SMART REGISTRATION BUTTON ---
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isRegistered
                              ? Colors.grey
                              : primaryBlue,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        // Disable button if registered, otherwise call the API
                        onPressed: isRegistered
                            ? null
                            : () => _registerForEvent(event['id'], index),
                        child: Text(
                          isRegistered ? "Registered" : l10n.imInterested,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
