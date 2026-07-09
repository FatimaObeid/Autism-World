import 'dart:convert';
import 'dart:io' show Platform;
import 'package:autism_world/screens/chat.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:autism_world/l10n/app_localizations.dart';

class SpecialistListPage extends StatefulWidget {
  const SpecialistListPage({super.key});

  @override
  State<SpecialistListPage> createState() => _SpecialistListPageState();
}

class _SpecialistListPageState extends State<SpecialistListPage> {
  static const Color primaryBlue = Color(0xFF1E88E5);

  List<dynamic> _serverSpecialists = [];
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
    _fetchSpecialistsFromBackend();
  }

  Future<void> _fetchSpecialistsFromBackend() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      final response = await http.get(
        Uri.parse('$baseUrl/api/parent/specialists'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);

        setState(() {
          if (decodedResponse is Map<String, dynamic> &&
              decodedResponse['success'] == true) {
            _serverSpecialists = decodedResponse['specialists'] ?? [];
          } else if (decodedResponse is List) {
            _serverSpecialists = decodedResponse;
          }
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage =
              'Server error: ${response.statusCode}. Could not load specialists.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage =
            'Failed to load specialists. Please check your connection.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pageTitle = l10n?.ourSpecialists ?? 'Our Specialists';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          pageTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black54, fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _fetchSpecialistsFromBackend,
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: const Text("Retry", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: primaryBlue),
            ),
          ],
        ),
      );
    }

    if (_serverSpecialists.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text(
              "No specialists available right now.",
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
      itemCount: _serverSpecialists.length,
      itemBuilder: (context, index) {
        final specialist = _serverSpecialists[index];

        final String name = specialist['user'] != null
            ? (specialist['user']['name'] ?? 'Specialist')
            : 'Specialist';
        final String specialty = specialist['therapy_type'] ?? 'Therapist';

        // Displays the custom registration bio text inside the summary feed preview row
        final String enteredBio =
            specialist['bio'] ?? 'No biography overview provided.';

        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 16),
          shadowColor: Colors.black12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SpecialistDetailPage(
                    initialData: specialist,
                    baseUrl: baseUrl,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: primaryBlue.withOpacity(0.1),
                        child: const Icon(
                          Icons.medical_services,
                          size: 30,
                          color: primaryBlue,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              specialty,
                              style: const TextStyle(
                                color: primaryBlue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    enteredBio,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      color: Colors.black87,
                    ),
                  ),
                  // Outer card screen layout row contact action button completely dropped here
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ==========================================
// SPECIALIST PROFILE DETAIL SCREEN (INSIDE)
// ==========================================
class SpecialistDetailPage extends StatefulWidget {
  final Map<String, dynamic> initialData;
  final String baseUrl;

  const SpecialistDetailPage({
    super.key,
    required this.initialData,
    required this.baseUrl,
  });

  @override
  State<SpecialistDetailPage> createState() => _SpecialistDetailPageState();
}

class _SpecialistDetailPageState extends State<SpecialistDetailPage> {
  late Map<String, dynamic> _detailedData;

  @override
  void initState() {
    super.initState();
    _detailedData = Map<String, dynamic>.from(widget.initialData);
  }

  @override
  Widget build(BuildContext context) {
    final String name = _detailedData['user'] != null
        ? (_detailedData['user']['name'] ?? 'Specialist')
        : 'Specialist';
    final String specialty = _detailedData['therapy_type'] ?? 'General Care';
    final int experience = _detailedData['experience_years'] ?? 0;

    // SAFE PARSING OF USER ID FOR THE CHAT ROUTE
    final int userId = _detailedData['user'] != null
        ? (_detailedData['user']['id'] ?? 0)
        : 0;

    final String realLocation = _detailedData['location'] ?? 'Remote / Online';
    final String realBio =
        _detailedData['bio'] ??
        'No biography overview has been provided by this specialist yet.';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Specialist Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: const Color(0xFF1E88E5).withOpacity(0.1),
                    child: const Icon(
                      Icons.medical_services,
                      size: 50,
                      color: Color(0xFF1E88E5),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    specialty,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF1E88E5),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 40, thickness: 1),
            Row(
              children: [
                Expanded(
                  child: _buildInfoTile(
                    Icons.work_history,
                    "Experience",
                    "$experience Years",
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInfoTile(
                    Icons.location_on,
                    "Location",
                    realLocation,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              "About Specialist",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              realBio,
              style: const TextStyle(
                fontSize: 15,
                height: 1.6,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 40),

            // CONNECTED CONSULTATION BUTTON NAVIGATION ROUTE
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.chat, color: Colors.white),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E88E5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ParentChatScreen(
                        specialistId: userId,
                        specialistName: name,
                      ),
                    ),
                  );
                },
                label: const Text(
                  "Start Consultation",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
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

  Widget _buildInfoTile(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF1E88E5), size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(color: Colors.black54, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
