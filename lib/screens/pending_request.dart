import 'package:flutter/material.dart';
import 'package:autism_world/l10n/app_localizations.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // Using SharedPreferences

class PendingRequestsPage extends StatefulWidget {
  const PendingRequestsPage({super.key});

  @override
  State<PendingRequestsPage> createState() => _PendingRequestsPageState();
}

class _PendingRequestsPageState extends State<PendingRequestsPage> {
  final String baseUrl = 'http://127.0.0.1:8000';

  List<dynamic> _pendingAppointments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPendingRequests();
  }

  // Your exact token retrieval method
  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // 1. Fetching the pending requests matching Route::get('/pendingRequests')
  Future<void> _fetchPendingRequests() async {
    setState(() => _isLoading = true);
    try {
      final token = await _getToken();

      if (token == null) {
        setState(() => _isLoading = false);
        _showErrorSnackBar('Authentication error: Token not found.');
        return;
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/specialist/pendingRequests'),
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
            _pendingAppointments = data['pending_requests'] ?? [];
            _isLoading = false;
          });
        }
      } else {
        throw Exception('Failed to load requests');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('Error connecting to server');
    }
  }

  Future<void> _handleRequest(
    int index,
    bool isAccepted,
    AppLocalizations l10n,
  ) async {
    final appointment = _pendingAppointments[index];
    final int appointmentId = appointment['id'];
    final String parentName = appointment['parent_name'] ?? 'Parent';

    final endpoint = isAccepted
        ? '$baseUrl/api/specialist/appointments/$appointmentId/confirm'
        : '$baseUrl/api/specialist/appointments/$appointmentId/decline';

    try {
      // Await the token here as well
      final token = await _getToken();
      if (token == null) {
        _showErrorSnackBar('Authentication error: Token not found.');
        return;
      }

      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token', // Injected token safely here
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          setState(() {
            _pendingAppointments.removeAt(index);
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isAccepted
                    ? l10n.acceptedRequest(parentName)
                    : l10n.declinedRequest(parentName),
              ),
              backgroundColor: isAccepted ? Colors.green : Colors.red,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } else {
        _showErrorSnackBar('Failed to update request status on server.');
      }
    } catch (e) {
      _showErrorSnackBar('Network error. Please try again.');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          l10n.pendingRequestsTitle,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: _fetchPendingRequests,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pendingAppointments.isEmpty
          ? _buildEmptyState(l10n)
          : RefreshIndicator(
              onRefresh: _fetchPendingRequests,
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: _pendingAppointments.length,
                itemBuilder: (context, index) {
                  final request = _pendingAppointments[index];
                  return _buildRequestCard(request, index, l10n);
                },
              ),
            ),
    );
  }

  Widget _buildRequestCard(
    Map<String, dynamic> request,
    int index,
    AppLocalizations l10n,
  ) {
    String name = request['parent_name'] ?? 'Unknown Parent';
    String initial = name.isNotEmpty ? name[0] : '?';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.blue.withOpacity(0.1),
                child: Text(
                  initial,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      request['session_type'] ?? 'Session',
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      request['day_label'] ?? '',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      request['time'] ?? '',
                      style: const TextStyle(color: Colors.blue, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _handleRequest(index, false, l10n),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.redAccent),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(l10n.decline),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _handleRequest(index, true, l10n),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 0,
                  ),
                  child: Text(l10n.approve),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 20),
          Text(
            l10n.allCaughtUp,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.noPendingAppointments,
            style: TextStyle(color: Colors.grey[50]),
          ),
        ],
      ),
    );
  }
}

