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

  /// Dynamically reads real-time approved specialist rosters from Laravel
  Future<void> _fetchSpecialistsFromBackend() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      final response = await http.get(
        Uri.parse("$baseUrl/api/specialists"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['success'] == true &&
            responseData['specialists'] != null) {
          setState(() {
            _serverSpecialists = (responseData['specialists'] as List).where((
              spec,
            ) {
              return spec['user'] != null &&
                  spec['user']['name'] != null &&
                  spec['user']['id'] != null;
            }).toList();
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage =
                "Server returned unsuccessful metadata parsing structure.";
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage =
              "Failed retrieving records. Server status: ${response.statusCode}";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Network exception error: $e";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(l10n.specialistsTitle),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: _buildBodyContext(l10n, isArabic),
    );
  }

  Widget _buildBodyContext(AppLocalizations l10n, bool isArabic) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: primaryBlue));
    }

    if (_errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_off, size: 60, color: Colors.redAccent),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _errorMessage = null;
                  });
                  _fetchSpecialistsFromBackend();
                },
                icon: const Icon(Icons.refresh, color: Colors.white),
                label: const Text(
                  "Retry Connection",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(backgroundColor: primaryBlue),
              ),
            ],
          ),
        ),
      );
    }

    if (_serverSpecialists.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.verified_user_outlined,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              const Text(
                "No verified or approved specialists are available right now.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _serverSpecialists.length,
      itemBuilder: (context, index) {
        final spec = _serverSpecialists[index];

        final int userId =
            spec['user']['id']; // Grab the user id to bind chat instances
        final String name = spec['user']['name'];
        final String specialty = spec['therapy_type'] ?? 'General Therapy';
        final int experienceYears = spec['experience_years'] ?? 0;

        final String bio = isArabic
            ? "هذا الأخصائي معتمد ومسجل لتقديم الدعم التخصصي والبرامج التأهيلية الشاملة."
            : "Certified clinical practitioner specializing in target behavioral therapies, developmental tracking guidelines, and progressive family support structures.";

        final String address = isArabic
            ? "العنوان متاح عند تأكيد الحجز الرسمي لجلسات المتابعة التخصصية."
            : "Clinic Address available upon confirmed session scheduling reservation context.";

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 2,
          shadowColor: Colors.black12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: primaryBlue.withOpacity(0.1),
                          child: const Icon(
                            Icons.person,
                            size: 30,
                            color: primaryBlue,
                          ),
                        ),
                        const Positioned(
                          right: 0,
                          bottom: 0,
                          child: CircleAvatar(
                            radius: 9,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.verified,
                              size: 14,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
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
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.work_outline,
                                size: 16,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "$experienceYears ${isArabic ? 'سنوات خبرة' : 'years experience'}",
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 2.0),
                                child: Icon(
                                  Icons.location_on_outlined,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  address,
                                  style: const TextStyle(
                                    height: 1.2,
                                    color: Colors.black54,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  bio,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      // Navigate smoothly into your standalone class routing channel
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
                    child: Text(l10n.contactButton),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
