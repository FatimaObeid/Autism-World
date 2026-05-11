import 'package:flutter/material.dart';
import 'package:autism_world/l10n/app_localizations.dart';

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
  static const _tealColor = Colors.teal; // Matches the dashboard button color
  static const _successColor = Colors.green;

  final List<Map<String, dynamic>> _events = [
    {
      "title": "🧠 Advanced CBT Training",
      "date": "Feb 28",
      "time": "09:00 AM",
      "location": "Medical Center",
      "categoryKey": "Training",
      "joined": true,
    },
    {
      "title": "🤝 Clinical Supervision",
      "date": "Mar 05",
      "time": "02:00 PM",
      "location": "Zoom / Virtual",
      "categoryKey": "Peer Review",
      "joined": false,
    },
    {
      "title": "📜 Autism Symposium",
      "date": "Mar 12",
      "time": "08:30 AM",
      "location": "Grand Hotel",
      "categoryKey": "Conference",
      "joined": false,
    },
  ];

  void _toggleJoin(Map<String, dynamic> event, AppLocalizations l10n) {
    setState(() {
      event['joined'] = !event['joined'];
    });
    bool nowJoined = event['joined'];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          nowJoined ? l10n.seatReserved : l10n.reservationCancelled,
        ),
        backgroundColor: nowJoined ? _tealColor : _successColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: _bgColor, // Unified with other pages
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
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(
          20,
        ), // Matches UpcomingAppointments padding
        itemCount: _events.length,
        itemBuilder: (context, index) {
          return _buildCard(_events[index], l10n);
        },
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> item, AppLocalizations l10n) {
    bool isJoined = item['joined'];
    String category;

    switch (item['categoryKey']) {
      case 'Training':
        category = l10n.categoryTraining;
        break;
      case 'Peer Review':
        category = l10n.categoryPeerReview;
        break;
      default:
        category = l10n.categoryConference;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16), // Unified border radius
        border: Border.all(color: Colors.grey.shade200), // Unified border
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10),
        ], // Unified shadow
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
                    // Unified Tag Style
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
                      item['date'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  item['title'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 15,
                      color: _textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      item['location'],
                      style: const TextStyle(
                        color: _textSecondary,
                        fontSize: 13,
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
                      item['time'],
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
