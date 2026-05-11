import 'package:flutter/material.dart';
import 'package:autism_world/l10n/app_localizations.dart';

class BookAppointment extends StatefulWidget {
  const BookAppointment({super.key});

  @override
  State<BookAppointment> createState() => _BookAppointmentState();
}

class _BookAppointmentState extends State<BookAppointment> {
  static const Color primaryBlue = Color(0xFF1E88E5);

  List<String> categories = [];
  String selectedCategory = "";

  final List<Map<String, String>> allSpecialists = [
    {
      "name": "Dr. Alice Smith",
      "specialty": "Speech Therapist",
      "rating": "4.9",
    },
    {"name": "Dr. Emily Brown", "specialty": "Psychologist", "rating": "4.8"},
    {
      "name": "Dr. Sam Wilson",
      "specialty": "Behavioral Specialist",
      "rating": "4.8",
    },
  ];

  List<Map<String, String>> get filteredSpecialists {
    if (categories.isEmpty) return [];
    if (selectedCategory == categories[0]) return allSpecialists;
    return allSpecialists
        .where((doc) => doc["specialty"] == selectedCategory)
        .toList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final l10n = AppLocalizations.of(context)!;
    // Initialize categories with localized strings
    categories = [
      l10n.categoryAll,
      l10n.categorySpeechTherapist,
      l10n.categoryPsychologist,
      l10n.categoryBehavioralSpecialist,
    ];
    selectedCategory = categories[0]; // "All" in current language
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.bookAppointmentTitle),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: Column(
        children: [
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
                    onSelected: (selected) {
                      setState(() => selectedCategory = categories[index]);
                    },
                    selectedColor: primaryBlue.withOpacity(0.2),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: filteredSpecialists.isEmpty
                ? Center(child: Text(l10n.noSpecialistsFound))
                : ListView.builder(
                    itemCount: filteredSpecialists.length,
                    itemBuilder: (context, index) {
                      final doc = filteredSpecialists[index];
                      return _specialistCard(
                        doc["name"]!,
                        doc["specialty"]!,
                        doc["rating"]!,
                        l10n,
                      );
                    },
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
    AppLocalizations l10n,
  ) {
    return Card(
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: primaryBlue.withOpacity(0.1),
          child: Icon(Icons.person, color: primaryBlue),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(specialty),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryBlue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(l10n.bookingComingSoon)));
          },
          child: Text(l10n.bookButton),
        ),
      ),
    );
  }
}
