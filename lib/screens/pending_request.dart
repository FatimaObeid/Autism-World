import 'package:flutter/material.dart';
import 'package:autism_world/l10n/app_localizations.dart';

class PendingRequestsPage extends StatefulWidget {
  const PendingRequestsPage({super.key});

  @override
  State<PendingRequestsPage> createState() => _PendingRequestsPageState();
}

class _PendingRequestsPageState extends State<PendingRequestsPage> {
  final List<Map<String, String>> _pendingAppointments = [
    {
      'name': 'Sarah Smith',
      'type': 'Initial Consultation',
      'time': '10:00 AM',
      'date': 'Today',
    },
    {
      'name': 'Mike Johnson',
      'type': 'Follow-up',
      'time': '2:30 PM',
      'date': 'Tomorrow',
    },
    {
      'name': 'Emily Davis',
      'type': 'Therapy Session',
      'time': '09:15 AM',
      'date': 'Mon, 12 Feb',
    },
  ];

  void _handleRequest(int index, bool isAccepted, AppLocalizations l10n) {
    String patientName = _pendingAppointments[index]['name']!;
    setState(() {
      _pendingAppointments.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isAccepted
              ? l10n.acceptedRequest(patientName)
              : l10n.declinedRequest(patientName),
        ),
        backgroundColor: isAccepted ? Colors.green : Colors.red,
        duration: const Duration(seconds: 2),
      ),
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
      ),
      body: _pendingAppointments.isEmpty
          ? _buildEmptyState(l10n)
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _pendingAppointments.length,
              itemBuilder: (context, index) {
                final request = _pendingAppointments[index];
                return _buildRequestCard(request, index, l10n);
              },
            ),
    );
  }

  Widget _buildRequestCard(
    Map<String, String> request,
    int index,
    AppLocalizations l10n,
  ) {
    String initial = request['name']![0];
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
                      request['name']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      request['type']!,
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
                      request['date']!,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      request['time']!,
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
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
