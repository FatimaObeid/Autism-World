import 'package:flutter/material.dart';

class AutismEvent {
  final String title;
  final String date;
  final String location;
  final String description;
  final bool isSensoryFriendly;

  AutismEvent({
    required this.title,
    required this.date,
    required this.location,
    required this.description,
    this.isSensoryFriendly = true,
  });
}

class EventsScreen extends StatelessWidget {
  EventsScreen({super.key});

  final List<AutismEvent> events = [
    AutismEvent(
      title: "Sensory-Friendly Morning",
      date: "Oct 12, 10:00 AM",
      location: "City Aquarium",
      description:
          "Lights are dimmed and sounds are turned down for a comfortable experience.",
    ),
    AutismEvent(
      title: "Autism-Friendly Movie",
      date: "Oct 15, 2:00 PM",
      location: "Cinema One",
      description:
          "Low sound, lights slightly up, and freedom to move around the theater.",
    ),
    AutismEvent(
      title: "Adaptive Sports Day",
      date: "Oct 20, 9:00 AM",
      location: "Central Park",
      description:
          "Specialized coaches helping kids enjoy soccer and track in a safe environment.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Community Events"),
        backgroundColor: Colors.teal[400],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                // Event Image Placeholder
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.teal[50],
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: const Icon(
                    Icons.event_available,
                    size: 50,
                    color: Colors.teal,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              event.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (event.isSensoryFriendly)
                            const Chip(
                              label: Text(
                                "Sensory Friendly",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                ),
                              ),
                              backgroundColor: Colors.green,
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_month,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            event.date,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            event.location,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        event.description,
                        style: TextStyle(color: Colors.grey[800]),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {},
                          child: const Text("I'm Interested"),
                        ),
                      ),
                    ],
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
