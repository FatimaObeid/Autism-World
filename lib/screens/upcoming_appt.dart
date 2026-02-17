import 'package:flutter/material.dart';

class UpcomingAppointmentsPage extends StatefulWidget {
  const UpcomingAppointmentsPage({super.key});

  @override
  State<UpcomingAppointmentsPage> createState() =>
      _UpcomingAppointmentsPageState();
}

class _UpcomingAppointmentsPageState extends State<UpcomingAppointmentsPage> {
  final List<Map<String, String>> _upcomingAppointments = [
    {
      'name': 'Lina Kate',
      'time': '09:00 AM',
      'date': 'Mon, 12 Feb',
      'tag': 'Therapy',
    },
    {
      'name': 'Ahmed Ali',
      'time': '11:30 AM',
      'date': 'Mon, 12 Feb',
      'tag': 'Check-up',
    },
    {
      'name': 'John Doe',
      'time': '02:00 PM',
      'date': 'Tue, 13 Feb',
      'tag': 'Consultation',
    },
    {
      'name': 'Sarah Smith',
      'time': '04:00 PM',
      'date': 'Wed, 14 Feb',
      'tag': 'Follow-up',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Upcoming Appointments",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _upcomingAppointments.length,
        itemBuilder: (context, index) {
          final appointment = _upcomingAppointments[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Text(
                        appointment['date']!.split(',')[0],
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        appointment['date']!.split(' ')[1],
                        style: const TextStyle(
                          color: Colors.blue,
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
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            appointment['time']!,
                            style: const TextStyle(
                              color: Colors.grey,
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
                    color: _getTagColor(appointment['tag']!).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    appointment['tag']!,
                    style: TextStyle(
                      color: _getTagColor(appointment['tag']!),
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

  Color _getTagColor(String tag) {
    switch (tag) {
      case 'Therapy':
        return Colors.green;
      case 'Check-up':
        return Colors.blue;
      case 'Consultation':
        return Colors.orange;
      default:
        return Colors.purple;
    }
  }
}
