import 'package:flutter/material.dart';

class CommunityEventsPage extends StatefulWidget {
  const CommunityEventsPage({super.key});

  @override
  State<CommunityEventsPage> createState() => _CommunityEventsPageState();
}

class _CommunityEventsPageState extends State<CommunityEventsPage> {
  // Professional Blue Theme
  final Color _themeColor = const Color(0xFF1E88E5);

  // --- 1. DATA (Only 3 Items) ---
  final List<Map<String, dynamic>> _events = [
    {
      "title": "🧠 Advanced CBT Training",
      "date": "Feb 28",
      "time": "09:00 AM",
      "location": "Medical Center",
      "category": "Training",
      "joined": true, // Default: User has joined this
    },
    {
      "title": "🤝 Clinical Supervision",
      "date": "Mar 05",
      "time": "02:00 PM",
      "location": "Zoom / Virtual",
      "category": "Peer Review",
      "joined": false,
    },
    {
      "title": "📜 Autism Symposium",
      "date": "Mar 12",
      "time": "08:30 AM",
      "location": "Grand Hotel",
      "category": "Conference",
      "joined": false,
    },
  ];

  // --- 2. LOGIC (Pass the event object directly) ---
  void _toggleJoin(Map<String, dynamic> event) {
    setState(() {
      event['joined'] = !event['joined'];
    });

    bool nowJoined = event['joined'];

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          nowJoined ? "Seat reserved! 📅" : "Reservation cancelled.",
        ),
        backgroundColor: nowJoined ? _themeColor : Colors.grey,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final myEvents = _events.where((e) => e['joined'] == true).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA), // Light Grey Background

        appBar: AppBar(
          backgroundColor: _themeColor,
          elevation: 0,
          centerTitle: true,
          title: const Column(
            children: [
              Text(
                "Professional Development",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Text(
                "Psychology & Autism Support",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
              ),
            ],
          ),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            tabs: [
              Tab(text: "All Events"),
              Tab(text: "My Schedule"),
            ],
          ),
        ),

        // --- BODY ---
        body: TabBarView(
          children: [
            // TAB 1: All Events
            ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _events.length,
              itemBuilder: (context, index) {
                return _buildCard(_events[index]);
              },
            ),

            // TAB 2: My Schedule
            myEvents.isEmpty
                ? Center(
                    child: Text(
                      "No events registered yet.",
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: myEvents.length,
                    itemBuilder: (context, index) {
                      return _buildCard(myEvents[index]);
                    },
                  ),
          ],
        ),
      ),
    );
  }

  // --- 3. OPTIMIZED CARD WIDGET ---
  Widget _buildCard(Map<String, dynamic> item) {
    bool isJoined = item['joined'];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),

      // DECORATION: Handles Shape, Shadow, and the Blue Strip (via Border)
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        // This 'left' border replaces the IntrinsicHeight/Row method
        border: Border(left: BorderSide(color: _themeColor, width: 6.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Category & Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item['category'].toUpperCase(),
                  style: TextStyle(
                    color: _themeColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                Text(
                  item['date'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Title
            Text(
              item['title'],
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),

            // Location & Time
            Row(
              children: [
                const Icon(Icons.location_on, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  item['location'],
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(width: 15),
                const Icon(Icons.access_time, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(item['time'], style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 16),

            // Action Button
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                onPressed: () => _toggleJoin(item),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isJoined ? Colors.white : _themeColor,
                  foregroundColor: isJoined ? _themeColor : Colors.white,
                  elevation: 0,
                  side: BorderSide(color: _themeColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  isJoined ? "Registered ✓" : "Reserve Spot",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
