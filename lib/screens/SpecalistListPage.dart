import 'package:flutter/material.dart';
import 'package:autism_world/l10n/app_localizations.dart';

class SpecialistListPage extends StatelessWidget {
  SpecialistListPage({super.key});

  static const Color primaryBlue = Color(0xFF1E88E5);

  // Bilingual specialist data
  final List<Map<String, dynamic>> specialists = [
    {
      "name_en": "Dr. Alice Smith",
      "name_ar": "د. أليس سميث",
      "specialty_en": "Speech Therapist",
      "specialty_ar": "اختصاصي تخاطب",
      "experience": "12 years",
      "bio_en":
          "Dr. Alice Smith specializes in pediatric speech disorders, including articulation delays, apraxia, and social communication challenges. She uses play-based therapy and has helped over 200 children improve their speech clarity and confidence.",
      "bio_ar":
          "تتخصص د. أليس سميث في اضطرابات النطق لدى الأطفال، بما في ذلك تأخر النطق، فقدان القدرة على الكلام، وتحديات التواصل الاجتماعي. تستخدم العلاج القائم على اللعب وساعدت أكثر من 200 طفل على تحسين وضوح كلامهم وثقتهم.",
      "comments_en": [
        "⭐ Sarah M.: 'Dr. Smith is amazing! My son went from nonverbal to speaking in short sentences in 6 months.'",
        "⭐ David L.: 'Very patient and engaging. Highly recommend for speech delays.'",
        "⭐ Emily R.: 'She gave us practical home exercises that really work.'",
      ],
      "comments_ar": [
        "⭐ سارة م.: 'د. أليس رائعة! ابني انتقل من عدم النطق إلى التحدث بجمل قصيرة في 6 أشهر.'",
        "⭐ ديفيد ل.: 'صابرة جداً ومتفاعلة. أوصي بها بشدة لتأخر النطق.'",
        "⭐ إيميلي ر.: 'أعطتنا تمارين منزلية عملية فعالة حقاً.'",
      ],
      "address_en": "Beirut, Hamra street, Bliss building, 4th floor",
      "address_ar": "بيروت، شارع الحمراء، مبنى بليس، الطابق الرابع",
    },
    {
      "name_en": "Dr. Emily Brown",
      "name_ar": "د. إميلي براون",
      "specialty_en": "Psychologist",
      "specialty_ar": "اختصاصي نفسي",
      "experience": "8 years",
      "bio_en":
          "Dr. Emily Brown is a clinical psychologist focusing on anxiety, emotional regulation, and social skills in children with autism. She offers CBT-based strategies and parent coaching sessions to build resilience at home.",
      "bio_ar":
          "د. إميلي براون هي أخصائية نفسية إكلينيكية تركز على القلق، التنظيم العاطفي، والمهارات الاجتماعية لدى الأطفال المصابين بالتوحد. تقدم استراتيجيات قائمة على العلاج السلوكي المعرفي وجلسات تدريب للآباء لبناء المرونة في المنزل.",
      "comments_en": [
        "⭐ Mark T.: 'Dr. Brown helped our daughter manage meltdowns. She's very empathetic.'",
        "⭐ Lisa K.: 'Great at explaining things to parents and kids alike.'",
      ],
      "comments_ar": [
        "⭐ مارك ت.: 'ساعدت د. براون ابنتنا في التعامل نوبات الغضب. إنها متعاطفة جداً.'",
        "⭐ ليزا ك.: 'رائعة في شرح الأمور للآباء والأطفال على حد سواء.'",
      ],
      "address_en":
          "South Lebanon, Sidon, Al-Bass Street, Al-Bass Building, 2nd floor",
      "address_ar": "جنوب لبنان، صيدا، شارع الباص، مبنى الباص، الطابق الثاني",
    },
    {
      "name_en": "Dr. Sam Wilson",
      "name_ar": "د. سام ويلسون",
      "specialty_en": "Behavioral Specialist",
      "specialty_ar": "اختصاصي سلوكي",
      "experience": "10 years",
      "bio_en":
          "Dr. Sam Wilson is a board-certified behavior analyst (BCBA) with expertise in ABA therapy, reducing challenging behaviors, and teaching daily living skills. He works closely with families to create positive behavior support plans.",
      "bio_ar":
          "د. سام ويلسون هو محلل سلوك معتمد (BCBA) بخبرة في علاج ABA، تقليل السلوكيات الصعبة، وتعليم مهارات الحياة اليومية. يعمل عن كثب مع العائلات لوضع خطط دعم سلوكي إيجابية.",
      "comments_en": [
        "⭐ Rachel P.: 'Life-changing! Sam gave us tools that actually reduced aggression.'",
        "⭐ James C.: 'Very structured approach but also warm with our child.'",
      ],
      "comments_ar": [
        "⭐ راشيل ب.: 'غيّر حياتنا! أعطانا سام أدوات قللت العدوانية فعلاً.'",
        "⭐ جيمس س.: 'نهج منظم جداً لكنه دافئ مع طفلنا.'",
      ],
      "address_en":
          "Mount Lebanon, Jounieh, Al-Bahr Street, Al-Bahr Building, 3rd floor",
      "address_ar": "جبل لبنان، جونيه، شارع البحر، مبنى البحر، الطابق الثالث",
    },
    {
      "name_en": "Dr. Olivia Martinez",
      "name_ar": "د. أوليفيا مارتينيز",
      "specialty_en": "Occupational Therapist",
      "specialty_ar": "اختصاصي علاج وظيفي",
      "experience": "6 years",
      "bio_en":
          "Dr. Olivia Martinez focuses on sensory integration, fine motor skills, and self-care routines. She creates fun, sensory-rich activities that help children regulate and participate in daily life more independently.",
      "bio_ar":
          "تركز د. أوليفيا مارتينيز على التكامل الحسي، المهارات الحركية الدقيقة، روتين العناية الذاتية. تخلق أنشطة ممتعة وغنية بالحواس تساعد الأطفال على التنظيم والمشاركة في الحياة اليومية بشكل أكثر استقلالية.",
      "comments_en": [
        "⭐ Anna W.: 'Olivia turned our messy mealtime into a success story. Her sensory diet advice was gold.'",
      ],
      "comments_ar": [
        "⭐ آنا دبليو.: 'حوّلت أوليفيا وقت الطعام الفوضوي لدينا إلى قصة نجاح. كانت نصائحها عن النظام الغذائي الحسي من ذهب.'",
      ],
      "address_en": "Beirut, Ghobeiry center, Zaarour 1st floor",
      "address_ar": "بيروت، مركز الغبيري، زعرور الطابق الأول",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.specialistsTitle),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: specialists.length,
        itemBuilder: (context, index) {
          final spec = specialists[index];

          // Select language-specific fields
          final name = isArabic ? spec['name_ar'] : spec['name_en'];
          final specialty = isArabic
              ? spec['specialty_ar']
              : spec['specialty_en'];
          final bio = isArabic ? spec['bio_ar'] : spec['bio_en'];
          final address = isArabic ? spec['address_ar'] : spec['address_en'];
          final comments = isArabic ? spec['comments_ar'] : spec['comments_en'];

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: primaryBlue.withOpacity(0.1),
                        child: Icon(Icons.person, size: 30, color: primaryBlue),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(specialty),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.work_outline,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Text(spec['experience']),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 2.0),
                                  child: Icon(
                                    Icons.location_on_outlined,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    address,
                                    style: const TextStyle(height: 1.2),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(bio, style: const TextStyle(fontSize: 14, height: 1.4)),
                  const SizedBox(height: 12),

                  // Comments section
                  ExpansionTile(
                    title: Text(
                      l10n.viewComments,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    leading: const Icon(Icons.comment, color: primaryBlue),
                    children: (comments as List<String>).map((comment) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 16,
                        ),
                        child: Text(
                          comment,
                          style: const TextStyle(fontSize: 13),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 8),
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
                          SnackBar(
                            content: Text(l10n.contactFeatureComing(name)),
                          ),
                        );
                      },
                      child: Text(l10n.contactButton),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
