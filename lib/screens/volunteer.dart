
import 'package:flutter/material.dart';

class VolunteerDashboard extends StatefulWidget {
  final String volunteerName;

  const VolunteerDashboard({super.key, required this.volunteerName});

  @override
  State<VolunteerDashboard> createState() => _VolunteerDashboardState();
}

class _VolunteerDashboardState extends State<VolunteerDashboard> {
  // --- DATA & LOGIC ---

  final List<Map<String, dynamic>> _workshops = [
    {
      "title": "🎨 Creative Painting",
      "date": "Feb 20",
      "time": "4:00 PM",
      "location": "123 Art St",
      "age": "6-9 years",
      "status": "Approved",
      "color": const Color(0xFFFF6B6B),
    },
    {
      "title": "🤖 Mini Robotics",
      "date": "Feb 22",
      "time": "10:00 AM",
      "location": "Tech Hub",
      "age": "10-14 years",
      "status": "Pending",
      "color": const Color(0xFF4ECDC4),
    },
    {
      "title": "📚 Story Time",
      "date": "Feb 25",
      "time": "3:00 PM",
      "location": "Library Hall",
      "age": "3-5 years",
      "status": "Approved",
      "color": const Color(0xFF1A535C),
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
                    "Hello, ${widget.volunteerName}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Here is your workshop overview",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
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
                          const Text(
                            "Total",
                            style: TextStyle(
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
                          const Text(
                            "Approved",
                            style: TextStyle(
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
                          const Text(
                            "Pending",
                            style: TextStyle(
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
              child: const TabBar(
                labelColor: Color(0xFF6C63FF),

                indicatorWeight: 3,
                tabs: [
                  Tab(text: "Approved ✅"),
                  Tab(text: "Pending ⏳"),
                ],
              ),
            ),

            Expanded(
              child: TabBarView(
                children: [
                  _approvedList.isEmpty
                      ? Center(
                          child: Text(
                            "No items here",
                            style: TextStyle(color: Colors.grey[400]),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(20),
                          itemCount: _approvedList.length,
                          itemBuilder: (context, index) {
                            final item = _approvedList[index];

                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(color: Colors.white),
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
                                            item['title'],
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
                                                item['location'],
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

                  _pendingList.isEmpty
                      ? Center(
                          child: Text(
                            "No items here",
                            style: TextStyle(color: Colors.grey[400]),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(20),
                          itemCount: _pendingList.length,
                          itemBuilder: (context, index) {
                            final item = _pendingList[index];

                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
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
                                            item['title'],
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
                                                item['location'],
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
                                                item['age'] ?? 'All Ages',
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
                  label: const Text(
                    "Add New Workshop",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
    final titleController = TextEditingController();
    final locController = TextEditingController();
    final ageController = TextEditingController();
    final dateController = TextEditingController();
    final timeController = TextEditingController();

    Future<void> pickDate() async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2030),
      );
      if (picked != null) {
        dateController.text = "${picked.month}/${picked.day}/${picked.year}";
      }
    }

    Future<void> pickTime() async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (picked != null && context.mounted) {
        timeController.text = picked.format(context);
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: 25, top: 25, left: 20, right: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "New Workshop Details 🌟",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: "Workshop Title",
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

            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: pickDate,
                    child: AbsorbPointer(
                      child: TextField(
                        controller: dateController,
                        decoration: InputDecoration(
                          labelText: "Date",
                          prefixIcon: const Icon(
                            Icons.calendar_today,
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
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: pickTime,
                    child: AbsorbPointer(
                      child: TextField(
                        controller: timeController,
                        decoration: InputDecoration(
                          labelText: "Time",
                          prefixIcon: const Icon(
                            Icons.access_time,
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
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            TextField(
              controller: ageController,
              decoration: InputDecoration(
                labelText: "Age Group (e.g. 5-8 yrs)",
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
                labelText: "Location",
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
                  if (titleController.text.isNotEmpty &&
                      dateController.text.isNotEmpty &&
                      timeController.text.isNotEmpty &&
                      locController.text.isNotEmpty &&
                      ageController.text.isNotEmpty) {
                    _addWorkshop({
                      "title": titleController.text,
                      "date": dateController.text,
                      "time": timeController.text,
                      "location": locController.text,
                      "age": ageController.text,
                    });

                    Navigator.pop(context);
                  }
                },
                child: const Text("Submit"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
