import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:autism_world/l10n/app_localizations.dart';

class DailyProgress extends StatefulWidget {
  const DailyProgress({super.key});

  @override
  State<DailyProgress> createState() => _DailyProgressState();
}

class _DailyProgressState extends State<DailyProgress> {
  static const Color accentOrange = Color(0xFFFF9800);

  // Form Field Interactive States
  double _moodLevel = 3.0;
  bool _tookMedicine = false; // Maps visually to Sensory Play
  bool _socialInteraction = false;
  final TextEditingController _notesController = TextEditingController();

  // Network Lifecycles & Context States
  bool _isLoading = false;
  bool _isInitializing = true;
  String? _errorMessage;

  String? automaticallySelectedChildId;
  String? automaticallySelectedChildName;

  String get baseUrl {
    if (kIsWeb) return "http://127.0.0.1:8000";
    if (Platform.isAndroid) return "http://10.0.2.2:8000";
    return "http://127.0.0.1:8000";
  }

  @override
  void initState() {
    super.initState();
    _fetchChildContext();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  /// Resolves the logged-in user's active child context profile seamlessly
  Future<void> _fetchChildContext() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      if (token.isEmpty) {
        setState(() {
          _errorMessage =
              "Authentication token not found. Please log in again.";
          _isInitializing = false;
        });
        return;
      }

      final childDashboardUri = Uri.parse("$baseUrl/api/children");
      final response = await http.get(
        childDashboardUri,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final childData = jsonDecode(response.body);
        setState(() {
          if (childData['success'] == true &&
              childData['data'] != null &&
              childData['data']['children'] != null) {
            final List childrenList = childData['data']['children'];
            if (childrenList.isNotEmpty) {
              final singleChild = childrenList.first;
              automaticallySelectedChildId = singleChild['id'].toString();
              automaticallySelectedChildName =
                  singleChild['full_name'] ?? 'Registered Profile';
            }
          }
          _isInitializing = false;
        });
      } else {
        setState(() {
          _errorMessage =
              "Unable to load baseline child profile layout status code: ${response.statusCode}";
          _isInitializing = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Failed parsing child configuration metadata: $e";
        _isInitializing = false;
      });
    }
  }

  /// Submits tracked daily records back to your Laravel API storage infrastructure
  Future<void> _saveDailyProgress() async {
    if (automaticallySelectedChildId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            "Error: No active child identity profiles found contextually linked.",
          ),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      final String formattedTodayDate =
          "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}";

      // Map clean request payload payload dictionary keys
      final Map<String, dynamic> requestPayload = {
        "child_id": int.parse(automaticallySelectedChildId!),
        "date": formattedTodayDate,
        "mood_level": _moodLevel.toInt(),
        "sensory_play": _tookMedicine ? 1 : 0,
        "social_interaction": _socialInteraction ? 1 : 0,
        "notes": _notesController.text.trim(),
      };

      final response = await http.post(
        Uri.parse("$baseUrl/api/daily-progress"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(requestPayload),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          responseData['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(AppLocalizations.of(context)!.progressSaved),
          ),
        );
        Navigator.pop(context);
      } else {
        String serverErrorMessage =
            responseData['message'] ??
            responseData['errors']?.toString() ??
            "Rejected.";
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text("Database Insertion Failure: $serverErrorMessage"),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Network Connection Interrupted: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_isInitializing) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: accentOrange)),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Connection Error")),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 50,
                  color: Colors.redAccent,
                ),
                const SizedBox(height: 16),
                Text(_errorMessage!, textAlign: TextAlign.center),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isInitializing = true;
                      _errorMessage = null;
                    });
                    _fetchChildContext();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentOrange,
                  ),
                  child: const Text(
                    "Retry Connection",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        title: Text(
          l10n.dailyProgressTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Embedded Clean Context Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFEEEEEE)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.assignment_ind_outlined,
                    color: accentOrange,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Logging tracking metrics for: ${automaticallySelectedChildName ?? 'Child Profile'}",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            Text(
              l10n.howWasDay,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 20),

            _buildSectionTitle(l10n.currentMood),
            Center(
              child: Text(
                _getMoodEmoji(_moodLevel),
                style: const TextStyle(fontSize: 50),
              ),
            ),
            Slider(
              value: _moodLevel,
              min: 1,
              max: 5,
              divisions: 4,
              activeColor: accentOrange,
              inactiveColor: accentOrange.withOpacity(0.2),
              onChanged: (value) => setState(() => _moodLevel = value),
            ),
            const SizedBox(height: 20),

            _buildSectionTitle(l10n.dailyGoals),
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Color(0xFFEEEEEE)),
              ),
              child: Column(
                children: [
                  CheckboxListTile(
                    title: Text(
                      l10n.sensoryPlay,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    value: _tookMedicine,
                    activeColor: accentOrange,
                    onChanged: (val) => setState(() => _tookMedicine = val!),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  CheckboxListTile(
                    title: Text(
                      l10n.socialInteraction,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    value: _socialInteraction,
                    activeColor: accentOrange,
                    onChanged: (val) =>
                        setState(() => _socialInteraction = val!),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            _buildSectionTitle(l10n.parentNotes),
            TextField(
              controller: _notesController,
              maxLines: 4,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: l10n.notesHint,
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: accentOrange, width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveDailyProgress,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentOrange,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        l10n.saveEntry,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 2),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.blueGrey,
        ),
      ),
    );
  }

  String _getMoodEmoji(double level) {
    if (level <= 1) return "😫";
    if (level <= 2) return "🙁";
    if (level <= 3) return "😐";
    if (level <= 4) return "🙂";
    return "🌟";
  }
}
