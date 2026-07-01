import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:autism_world/specialist/clients_details.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:autism_world/l10n/app_localizations.dart'; // Verified package path

class MyClientsPage extends StatefulWidget {
  const MyClientsPage({super.key});

  @override
  State<MyClientsPage> createState() => _MyClientsPageState();
}

class _MyClientsPageState extends State<MyClientsPage> {
  static const _bgColor = Color(0xFFFAFAFA);
  static const _textPrimary = Colors.black;

  List<dynamic> _clients = [];
  bool _isLoading = true;
  String? _errorMessage;
  bool _isServerError =
      false; // Added to distinguish plain messages from dynamic server errors
  String _serverCode = '';

  @override
  void initState() {
    super.initState();
    _fetchClients();
  }

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> _fetchClients() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _isServerError = false;
    });

    try {
      const String apiUrl = 'http://127.0.0.1:8000/api/specialist/clients';

      final token = await _getToken();

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          setState(() {
            _clients = data['clients'];
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage = 'failedToLoadClients';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _isServerError = true;
          _serverCode = response.statusCode.toString();
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'connectionFailed';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        title: Text(
          l10n.myClientsTitle,
          style: const TextStyle(
            color: _textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: _bgColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: _textPrimary),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _fetchClients),
        ],
      ),
      body: _buildBody(l10n),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.teal));
    }

    // Handle Error States with Localized Strings
    if (_errorMessage != null || _isServerError) {
      String displayedError = '';
      if (_isServerError) {
        displayedError = l10n.serverError(_serverCode);
      } else if (_errorMessage == 'failedToLoadClients') {
        displayedError = l10n.failedToLoadClients;
      } else {
        displayedError = l10n.connectionFailed;
      }

      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          key: const ValueKey('error_layout'),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.redAccent,
              ),
              const SizedBox(height: 12),
              Text(
                displayedError,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                onPressed: _fetchClients,
                child: Text(
                  l10n.retryButton,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_clients.isEmpty) {
      return Center(
        child: Text(
          l10n.noAssignedClients,
          style: const TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchClients,
      color: Colors.teal,
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _clients.length,
        itemBuilder: (context, index) {
          return _ClientListCard(client: _clients[index], l10n: l10n);
        },
      ),
    );
  }
}

class _ClientListCard extends StatelessWidget {
  final Map<String, dynamic> client;
  final AppLocalizations l10n;

  const _ClientListCard({required this.client, required this.l10n});

  static const _cardColor = Colors.white;
  static const _textPrimary = Colors.black;
  static const _textSecondary = Colors.grey;
  static const _tealColor = Colors.teal;

  void _navigateToDetails(BuildContext context) {
    final String clientId = client['id']?.toString() ?? '';

    final Map<String, dynamic> clientData = {
      'id': clientId,
      'childName': client['child_name']?.toString() ?? 'Unknown',
      'age': client['age']?.toString() ?? 'N/A',
      'dob': client['dob']?.toString() ?? 'N/A',
      'gender': client['gender']?.toString() ?? 'N/A',
      'autismLevel': client['autism_level']?.toString() ?? 'Not specified',
      'behavioralDescription':
          client['behavioral_description']?.toString() ??
          'No description provided',
      'parentName': client['parent_name']?.toString() ?? 'N/A',
      'parentEmail': client['parent_email']?.toString() ?? 'N/A',
      'parentPhone': client['parent_phone']?.toString() ?? 'N/A',
      'lastSession': client['last_session_summary']?.toString() ?? '',
      'nextPlan': client['next_plan']?.toString() ?? '',
      'diagnosis': client['diagnosis']?.toString() ?? '',
      'therapyType': client['therapy_type']?.toString() ?? '',
      'sessionFrequency': client['session_frequency']?.toString() ?? '',
      'goals': client['goals']?.toString() ?? '',
      'importantNotes': client['important_notes']?.toString() ?? '',

      // FIX: Pass 'recent_progress' explicitly so details page finds it
      'recent_progress':
          client['recent_progress'] ?? client['progress']?.toString() ?? '',

      // FIX: Pass the daily progress log items explicitly
      'log_date': client['log_date'],
      'mood_level': client['mood_level'],
      'sensory_play': client['sensory_play'],
      'social_interaction': client['social_interaction'],
      'daily_notes': client['daily_notes'] ?? client['parent_progress_notes'],
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClientDetailsPage(client: clientData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String ageValue = client['age']?.toString() ?? l10n.notAvailable;
    final String parentValue =
        client['parent_name']?.toString() ?? l10n.notAvailable;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            client['child_name'] ?? l10n.unknownName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "${l10n.ageLabel}: $ageValue • ${l10n.parentLabel}: $parentValue",
            style: const TextStyle(
              color: _textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Divider(height: 24),
          Text(
            l10n.lastSessionLabel,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: _tealColor,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            client['last_session_summary'] ?? l10n.noSessionNotes,
            style: const TextStyle(color: _textPrimary, fontSize: 14),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Text(
            l10n.nextPlanLabel,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: _tealColor,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            client['next_plan'] ?? l10n.noPlanSet,
            style: const TextStyle(color: _textPrimary, fontSize: 14),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => _navigateToDetails(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  l10n.viewCompleteDetails,
                  style: const TextStyle(
                    color: _tealColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward, size: 16, color: _tealColor),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
