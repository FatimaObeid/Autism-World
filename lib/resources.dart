import 'package:flutter/material.dart';

class Resource {
  final String title;
  final String category;
  final String description;
  final IconData icon;

  Resource({
    required this.title,
    required this.category,
    required this.description,
    required this.icon,
  });
}

class ResourcesScreen extends StatelessWidget {
  ResourcesScreen({super.key});

  final List<Resource> resources = [
    Resource(
      title: "Understanding Sensory Overload",
      category: "Sensory",
      description:
          "Learn how to identify triggers and create a 'calm-down' corner at home.",
      icon: Icons.hearing,
    ),
    Resource(
      title: "Visual Schedules 101",
      category: "Communication",
      description:
          "A step-by-step guide on using picture cards to help your child navigate their day.",
      icon: Icons.remove_red_eye,
    ),
    Resource(
      title: "Nutrition & Autism",
      category: "Health",
      description:
          "Exploring the link between gut health and behavior in neurodivergent children.",
      icon: Icons.restaurant,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Learning Resources"),
        backgroundColor: Colors.purple[400],
      ),
      body: Column(
        children: [
          // 1. SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search topics...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),

          // 2. RESOURCE LIST
          Expanded(
            child: ListView.builder(
              itemCount: resources.length,
              itemBuilder: (context, index) {
                final item = resources[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.purple[50],
                      child: Icon(item.icon, color: Colors.purple),
                    ),
                    title: Text(
                      item.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(item.category),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.description),
                            const SizedBox(height: 10),
                            TextButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.menu_book),
                              label: const Text("Read Full Article"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
