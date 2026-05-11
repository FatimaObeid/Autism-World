import 'package:flutter/material.dart';
import 'package:autism_world/l10n/app_localizations.dart';

class ResourcesScreen extends StatelessWidget {
  ResourcesScreen({super.key});

  static const Color accentPurple = Color(0xFF9C27B0);

  // Bilingual resource data
  final List<Map<String, dynamic>> resources = [
    {
      "title_en": "Understanding Sensory Overload",
      "title_ar": "فهم الحمل الحسي الزائد",
      "category_en": "Sensory",
      "category_ar": "حسي",
      "description_en":
          "Learn how to identify triggers and create a 'calm-down' corner at home.",
      "description_ar":
          "تعلم كيفية تحديد المحفزات وإنشاء ركن 'التهدئة' في المنزل.",
      "icon": Icons.hearing,
    },
    {
      "title_en": "Visual Schedules 101",
      "title_ar": "الجداول المرئية 101",
      "category_en": "Communication",
      "category_ar": "تواصل",
      "description_en":
          "A step-by-step guide on using picture cards to help your child navigate their day.",
      "description_ar":
          "دليل خطوة بخطوة حول استخدام بطاقات الصور لمساعدة طفلك على تنظيم يومه.",
      "icon": Icons.remove_red_eye,
    },
    {
      "title_en": "Nutrition & Autism",
      "title_ar": "التغذية والتوحد",
      "category_en": "Health",
      "category_ar": "صحة",
      "description_en":
          "Exploring the link between gut health and behavior in neurodivergent children.",
      "description_ar":
          "استكشاف العلاقة بين صحة الأمعاء والسلوك لدى الأطفال ذوي الاختلافات العصبية.",
      "icon": Icons.restaurant,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.resourcesTitle),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: l10n.searchHint,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: resources.length,
              itemBuilder: (context, index) {
                final item = resources[index];
                final title = isArabic ? item['title_ar'] : item['title_en'];
                final category = isArabic
                    ? item['category_ar']
                    : item['category_en'];
                final description = isArabic
                    ? item['description_ar']
                    : item['description_en'];
                final icon = item['icon'] as IconData;

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundColor: accentPurple.withOpacity(0.1),
                      child: Icon(icon, color: accentPurple),
                    ),
                    title: Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(category),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(description),
                            const SizedBox(height: 10),
                            TextButton.icon(
                              onPressed: () {
                                // TODO: Open article in a web view or detail screen
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(l10n.readFullArticle)),
                                );
                              },
                              icon: const Icon(Icons.menu_book),
                              label: Text(l10n.readFullArticle),
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
