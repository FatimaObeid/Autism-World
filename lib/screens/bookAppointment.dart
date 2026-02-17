import 'package:flutter/material.dart';

class bookAppointment extends StatefulWidget {
  const bookAppointment({super.key});

  @override
  State<bookAppointment> createState() => _bookAppointmentState();
}

class _bookAppointmentState extends State<bookAppointment> {
  final List<String> categories = [
    "All",
    "Speech Therapist",
    "Psychologist",
    "Behavioral Specialist",
  ];
  String selectedCategory = "All";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Book Appointment")),
      body: Column(
        children: [
          // 2. Horizontal Category Selector
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ChoiceChip(
                    label: Text(categories[index]),
                    selected: selectedCategory == categories[index],
                    onSelected: (bool selected) {
                      setState(() {
                        selectedCategory = categories[index];
                      });
                    },
                  ),
                );
              },
            ),
          ),

          // 3. List of Specialists
          Expanded(
            child: ListView(
              children: [
                _specialistCard(
                  "Dr. Alice Smith",
                  "Speech Therapist",
                  "4.9",
                  "assets/doctor1.png",
                ),
                _specialistCard(
                  "Dr. John Doe",
                  "Occupational Therapist",
                  "4.7",
                  "assets/doctor2.png",
                ),
                _specialistCard(
                  "Dr. Sam Wilson",
                  "Behavioral Specialist",
                  "4.8",
                  "assets/doctor3.png",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _specialistCard(
    String name,
    String specialty,
    String rating,
    String img,
  ) {
    return Card(
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: const CircleAvatar(
          radius: 25,
          child: Icon(Icons.person), // Placeholder for image
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(specialty),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            // STEP 2 WILL GO HERE: Navigation to Time Slots
          },
          child: const Text("Book"),
        ),
      ),
    );
  }
}
