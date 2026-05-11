import 'package:flutter/material.dart';
import 'package:autism_world/l10n/app_localizations.dart';

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

  final List<Map<String, String>> _upcomingAppointments = [
    {
      'name': 'Lina Kate',
      'time': '09:00 AM',
      'date': 'Mon, 12 Feb',
      'tagKey': 'Therapy',
    },
    {
      'name': 'Ahmed Ali',
      'time': '11:30 AM',
      'date': 'Mon, 12 Feb',
      'tagKey': 'Check-up',
    },
    {
      'name': 'John Doe',
      'time': '02:00 PM',
      'date': 'Tue, 13 Feb',
      'tagKey': 'Consultation',
    },
    {
      'name': 'Sarah Smith',
      'time': '04:00 PM',
      'date': 'Wed, 14 Feb',
      'tagKey': 'Follow-up',
    },
  ];

  String _getTagText(String key, AppLocalizations l10n) {
    switch (key) {
      case 'Therapy':
        return l10n.tagTherapy;
      case 'Check-up':
        return l10n.tagCheckup;
      case 'Consultation':
        return l10n.tagConsultation;
      default:
        return l10n.tagFollowup;
    }
  }

  Color _getTagColor(String key) {
    switch (key) {
      case 'Therapy':
        return _colorTherapy;
      case 'Check-up':
        return _colorCheckup;
      case 'Consultation':
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
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _upcomingAppointments.length,
        itemBuilder: (context, index) {
          final appointment = _upcomingAppointments[index];
          final dateParts = appointment['date']!.split(',');
          final day = dateParts[0];
          final monthDay = dateParts[1].trim();

          final tagColor = _getTagColor(appointment['tagKey']!);

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
                          fontSize: 18,
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
                        appointment['name']!,
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
                            appointment['time']!,
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
                    _getTagText(appointment['tagKey']!, l10n),
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
