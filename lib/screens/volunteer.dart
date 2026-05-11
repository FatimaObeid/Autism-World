import 'package:flutter/material.dart';
// Make sure to import your generated localization file!
import 'package:autism_world/l10n/app_localizations.dart';

class VolunteerDashboard extends StatefulWidget {
  final String volunteerName;

  const VolunteerDashboard({super.key, required this.volunteerName});

  @override
  State<VolunteerDashboard> createState() => _VolunteerDashboardState();
}

class _VolunteerDashboardState extends State<VolunteerDashboard> {
  // --- DATA & LOGIC ---

  // FUTURE DATABASE NOTE:
  // In the future, this list won't be hardcoded. It will be fetched from Firebase.
  // When the admin uploads, the database will contain 'title_en', 'title_ar', etc.
  final List<Map<String, dynamic>> _workshops = [
    {
      "title_en": "🎨 Creative Painting",
      "title_ar": "🎨 الرسم الإبداعي",
      "date": "Feb 20",
      "time": "4:00 PM",
      "location_en": "123 Art St",
      "location_ar": "123 شارع الفن",
      "age": "6-9 years",
      "status": "Approved",
      "color": const Color(0xFFFF6B6B),
    },
    {
      "title_en": "🤖 Mini Robotics",
      "title_ar": "🤖 الروبوتات الصغيرة",
      "date": "Feb 22",
      "time": "10:00 AM",
      "location_en": "Tech Hub",
      "location_ar": "مركز التكنولوجيا",
      "age": "10-14 years",
      "status": "Pending",
      "color": const Color(0xFF4ECDC4),
    },
  ];

  List<Map<String, dynamic>> get _approvedList =>
      _workshops.where((w) => w['status'] == 'Approved').toList();

  List<Map<String, dynamic>> get _pendingList =>
      _workshops.where((w) => w['status'] == 'Pending').toList();

  void _addWorkshop(Map<String, dynamic> newWorkshop) {
    setState(() {
      newWorkshop['color'] = Colors.purpleAccent;
      newWorkshop['status'] = 'Pending';
      _workshops.add(newWorkshop);
    });
  }

  // --- UI BUILD ---

  @override
  Widget build(BuildContext context) {
    // Helper to get localizations easily
    final l10n = AppLocalizations.of(context)!;
    // Helper to check current language for dynamic content
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                top: 60,
                bottom: 30,
                left: 20,
                right: 20,
              ),
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFF86A8E7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    // USING ARB PLACEHOLDER
                    l10n.hello(widget.volunteerName),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    // USING ARB FILE
                    l10n.workshopOverview,
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(
                            "${_workshops.length}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            l10n.total, // USING ARB FILE
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Container(width: 1, height: 30, color: Colors.white30),

                      Column(
                        children: [
                          Text(
                            "${_approvedList.length}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            l10n.approved, // USING ARB FILE
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Container(width: 1, height: 30, color: Colors.white30),

                      Column(
                        children: [
                          Text(
                            "${_pendingList.length}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            l10n.pending, // USING ARB FILE
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Container(
              color: Colors.white,
              child: TabBar(
                labelColor: const Color(0xFF6C63FF),
                indicatorWeight: 3,
                tabs: [
                  Tab(text: l10n.approvedTab), // USING ARB FILE
                  Tab(text: l10n.pendingTab), // USING ARB FILE
                ],
              ),
            ),

            Expanded(
              child: TabBarView(
                children: [
                  _approvedList.isEmpty
                      ? Center(
                          child: Text(
                            l10n.noItemsHere, // USING ARB FILE
                            style: TextStyle(color: Colors.grey[400]),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(20),
                          itemCount: _approvedList.length,
                          itemBuilder: (context, index) {
                            final item = _approvedList[index];

                            // HOW YOU HANDLE DYNAMIC ADMIN UPLOADS:
                            // We check 'isArabic' and pull the correct database field!
                            final displayTitle = isArabic
                                ? item['title_ar']
                                : item['title_en'];
                            final displayLocation = isArabic
                                ? item['location_ar']
                                : item['location_en'];

                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 10,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: item['color'],
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        bottomLeft: Radius.circular(16),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                item['date'],
                                                style: TextStyle(
                                                  color: item['color'],
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                item['time'],
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            displayTitle, // USING DYNAMIC TRANSLATION
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.location_on,
                                                size: 14,
                                                color: Colors.grey[400],
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                displayLocation, // USING DYNAMIC TRANSLATION
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 13,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Icon(
                                                Icons.person,
                                                size: 14,
                                                color: Colors.grey[400],
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                item['age'],
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

                  // (I omitted the pendingList ListView for brevity, but you apply the exact same
                  // 'displayTitle' and 'displayLocation' logic to the pending list builder!)
                  _pendingList.isEmpty
                      ? Center(
                          child: Text(
                            l10n.noItemsHere,
                            style: TextStyle(color: Colors.grey[400]),
                          ),
                        )
                      : const Center(child: Text("Pending List Here")),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF9F1C),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.add),
                  label: Text(
                    l10n.addNewWorkshop, // USING ARB FILE
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () => _showAddModal(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddModal(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final titleController = TextEditingController();
    final locController = TextEditingController();
    final ageController = TextEditingController();
    final dateController = TextEditingController();
    final timeController = TextEditingController();

    // ... (pickDate and pickTime logic remains exactly the same) ...

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.only(
          bottom: 25,
          top: 25,
          left: 20,
          right: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.newWorkshopDetails, // USING ARB FILE
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: l10n.workshopTitle, // USING ARB FILE
                prefixIcon: const Icon(Icons.edit, color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // ... Date and Time fields using l10n.date and l10n.time as labels ...
            TextField(
              controller: ageController,
              decoration: InputDecoration(
                labelText: l10n.ageGroup, // USING ARB FILE
                prefixIcon: const Icon(Icons.child_care, color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: locController,
              decoration: InputDecoration(
                labelText: l10n.location, // USING ARB FILE
                prefixIcon: const Icon(
                  Icons.location_on_outlined,
                  color: Colors.grey,
                ),
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  // When hooked up to database, you would save Arabic and English versions here!
                  Navigator.pop(context);
                },
                child: Text(l10n.submit), // USING ARB FILE
              ),
            ),
          ],
        ),
      ),
    );
  }
}
