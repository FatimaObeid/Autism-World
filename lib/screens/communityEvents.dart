import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:autism_world/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommunityEventsPage extends StatefulWidget {
  const CommunityEventsPage({super.key});

  @override
  State<CommunityEventsPage> createState() => _CommunityEventsPageState();
}

class _CommunityEventsPageState extends State<CommunityEventsPage> {
  // --- Unified Design Constants ---
  static const _bgColor = Color(0xFFFAFAFA);
  static const _cardColor = Colors.white;
  static const _textPrimary = Colors.black;
  static const _textSecondary = Colors.grey;
  static const _tealColor = Colors.teal; // Matches dashboard button color
  static const _successColor = Colors.green;

  final String _baseUrl = 'http://127.0.0.1:8000/api/specialist';

  List<Map<String, dynamic>> _events = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> _fetchEvents() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse('$_baseUrl/events'),
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
            _events = List<Map<String, dynamic>>.from(responseData['events']);
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage = 'Failed to load events';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Server error: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Connection error. Check your server settings.';
        _isLoading = false;
      });
    }
  }

  // POST / DELETE: Register or unregister from event using endpoints in api.php
  Future<void> _toggleJoin(
    Map<String, dynamic> event,
    AppLocalizations l10n,
  ) async {
    final bool originalState = event['is_registered'] ?? false;
    final int eventId = event['id'];

    // Optimistic UI Update: updates right away for fluid UX responsiveness
    setState(() {
      event['is_registered'] = !originalState;
    });

    final String url = originalState
        ? '$_baseUrl/events/$eventId/unregister'
        : '$_baseUrl/events/$eventId/register';

    try {
      final http.Response response = originalState
          ? await http.delete(
              Uri.parse(url),
              headers: {'Accept': 'application/json'},
            )
          : await http.post(
              Uri.parse(url),
              headers: {'Accept': 'application/json'},
            );

      final Map<String, dynamic> responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                event['is_registered']
                    ? l10n.seatReserved
                    : l10n.reservationCancelled,
              ),
              backgroundColor: event['is_registered']
                  ? _tealColor
                  : _successColor,
            ),
          );
        }
      } else {
        // Fallback: Backend failed/declined operation, revert state
        setState(() {
          event['is_registered'] = originalState;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseData['message'] ?? 'An error occurred.'),
            ),
          );
        }
      }
    } catch (e) {
      // Fallback: Connection drop, revert state
      setState(() {
        event['is_registered'] = originalState;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Network error. Operation failed.')),
        );
      }
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
          l10n.communityEventsSpecialistTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: _textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: _textPrimary),
            onPressed: _fetchEvents,
          ),
        ],
      ),
      body: _buildBody(l10n),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: _tealColor));
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _fetchEvents,
              style: ElevatedButton.styleFrom(backgroundColor: _tealColor),
              child: const Text('Retry', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    if (_events.isEmpty) {
      return RefreshIndicator(
        onRefresh: _fetchEvents,
        color: _tealColor,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 100),
            Center(
              child: Text(
                'No upcoming events available.',
                style: TextStyle(color: _textSecondary, fontSize: 16),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchEvents,
      color: _tealColor,
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _events.length,
        itemBuilder: (context, index) {
          return _buildCard(_events[index], l10n);
        },
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> item, AppLocalizations l10n) {
    bool isJoined = item['is_registered'] ?? false;
    String categoryKey = item['category'] ?? '';
    String category;

    // Mapping based on category values from your backend
    switch (categoryKey) {
      case 'Training':
        category = l10n.categoryTraining;
        break;
      case 'Peer Review':
        category = l10n.categoryPeerReview;
        break;
      default:
        category = categoryKey.isNotEmpty
            ? categoryKey
            : l10n.categoryConference;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(left: BorderSide(color: _tealColor, width: 5.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _tealColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        category.toUpperCase(),
                        style: const TextStyle(
                          color: _tealColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    Text(
                      item['date'] ??
                          '', // Expects string layout formatted by controller map
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  item['title'] ?? '',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _textPrimary,
                  ),
                ),
                if (item['description'] != null &&
                    item['description'].toString().isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    item['description'],
                    style: const TextStyle(color: _textSecondary, fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 15,
                      color: _textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        item['location'] ?? '',
                        style: const TextStyle(
                          color: _textSecondary,
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Icon(
                      Icons.access_time,
                      size: 15,
                      color: _textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      item['time'] ??
                          '', // Expects string layout formatted by controller map
                      style: const TextStyle(
                        color: _textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () => _toggleJoin(item, l10n),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isJoined ? _cardColor : _tealColor,
                      foregroundColor: isJoined ? _tealColor : Colors.white,
                      elevation: 0,
                      side: const BorderSide(color: _tealColor, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      isJoined ? l10n.registered : l10n.reserveSpot,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
