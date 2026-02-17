import 'package:autism_world/screens/bookAppointment.dart';
import 'package:autism_world/screens/dailyProgress.dart';
import 'package:autism_world/screens/events.dart';
import 'package:autism_world/screens/resources.dart';
import 'package:autism_world/screens/specialistList.dart';
import 'package:flutter/material.dart';

class ParentPage extends StatefulWidget {
  const ParentPage({super.key});

  @override
  State<ParentPage> createState() => _ParentPageState();
}

class _ParentPageState extends State<ParentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Autism World"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Hello, Parent!",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              Text(
                "How is your child doing today?",
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 25),

              GridView.count(
                shrinkWrap: false,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2, // 2 columns
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                children: [
                  _buildMenuCard(
                    context,
                    "Book Appointment",
                    Icons.calendar_month,
                    Colors.blue,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const bookAppointment(),
                        ),
                      );
                    },
                  ),
                  _buildMenuCard(
                    context,
                    "Specialists",
                    Icons.medical_services,
                    Colors.teal,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SpecialistsPage(),
                        ),
                      );
                    },
                  ),
                  _buildMenuCard(
                    context,
                    "Daily Progress",
                    Icons.auto_graph,
                    Colors.orange,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DailyProgress(),
                        ),
                      );
                    },
                  ),
                  _buildMenuCard(
                    context,
                    "Resources",
                    Icons.library_books,
                    Colors.purple,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResourcesScreen(),
                        ),
                      );
                    },
                  ),
                  _buildMenuCard(
                    context,
                    "Community Events",
                    Icons.celebration, // A fun icon for events
                    Colors.teal,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EventsScreen()),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 30),

              const Text(
                "Next Appointment",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildUpcomingCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.blue[800],
        borderRadius: BorderRadius.circular(15),
      ),
      child: const ListTile(
        leading: Icon(Icons.access_time, color: Colors.white),
        title: Text(
          "Speech Therapy",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "Today at 4:00 PM",
          style: TextStyle(color: Colors.white70),
        ),
      ),
    );
  }
}
