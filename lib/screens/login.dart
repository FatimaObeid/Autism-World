import 'package:flutter/material.dart';
import 'package:autism_world/l10n/app_localizations.dart';

class EventsScreen extends StatelessWidget {
  EventsScreen({super.key});

  static const Color primaryBlue = Color(0xFF1E88E5);

  // Bilingual event data
  final List<Map<String, dynamic>> events = [
    {
      "title_en": "Sensory-Friendly Morning",
      "title_ar": "صباح مناسب للحواس",
      "date": "Oct 12, 10:00 AM",
      "location_en": "City Aquarium",
      "location_ar": "أكواريوم المدينة",
      "description_en":
          "Lights are dimmed and sounds are turned down for a comfortable experience.",
      "description_ar": "يتم خفض الإضاءة والأصوات لتجربة مريحة.",
    },
    {
      "title_en": "Autism-Friendly Movie",
      "title_ar": "فيلم مناسب للتوحد",
      "date": "Oct 15, 2:00 PM",
      "location_en": "Cinema One",
      "location_ar": "سينما ون",
      "description_en":
          "Low sound, lights slightly up, and freedom to move around the theater.",
      "description_ar":
          "صوت منخفض، إضاءة مرتفعة قليلاً، وحرية الحركة في أرجاء الصالة.",
    },
    {
      "title_en": "Adaptive Sports Day",
      "title_ar": "يوم رياضي تكيفي",
      "date": "Oct 20, 9:00 AM",
      "location_en": "Central Park",
      "location_ar": "الحديقة المركزية",
      "description_en":
          "Specialized coaches helping kids enjoy soccer and track in a safe environment.",
      "description_ar":
          "مدربون متخصصون يساعدون الأطفال على الاستمتاع بكرة القدم وألعاب القوى في بيئة آمنة.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.eventsTitle),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          final title = isArabic ? event['title_ar'] : event['title_en'];
          final location = isArabic
              ? event['location_ar']
              : event['location_en'];
          final description = isArabic
              ? event['description_ar']
              : event['description_en'];
          final date = event['date'];

          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: primaryBlue.withOpacity(0.1),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(15),
                    ),
                  ),
                  child: Icon(
                    Icons.event_available,
                    size: 50,
                    color: primaryBlue,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
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
                            date,
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
                            location,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        description,
                        style: TextStyle(color: Colors.grey[800]),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryBlue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l10n.interestNoted)),
                            );
                          },
                          child: Text(l10n.imInterested),
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
