import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:autism_world/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:autism_world/screens/login.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  // Theme Colors
  static const Color primaryBlue = Color(0xFF1E88E5);
  static const Color accentOrange = Color(0xFFFF9800);
  static const Color accentPurple = Color(0xFF9C27B0);
  static const Color accentTeal = Color(0xFF00897B);
  static const Color backgroundLight = Color(0xFFF5F7FA);

  // --- Dynamic Dashboard Data Lists ---
  List<dynamic> specialists = [];
  List<dynamic> parents = [];
  List<dynamic> volunteers = [];
  List<dynamic> pendingWorkshops = [];
  List<dynamic> resources = [];

  bool isLoading = true;
  String? _error;

  // Backend URL
  static const String baseUrl = 'http://127.0.0.1:8000';
  // PATCH - Approve or Decline Specialist Application
  Future<void> handleSpecialistStatus(
    dynamic targetId, {
    required bool approve,
  }) async {
    final token = await _getToken();
    if (token == null) {
      _redirectToLogin();
      return;
    }

    final endpoint = approve
        ? 'specialists/$targetId/approve'
        : 'specialists/$targetId/decline';

    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/api/admin/$endpoint'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        _showFeedbackSnackBar(
          approve
              ? "Specialist profile has been approved live!"
              : "Specialist application turned down.",
          approve ? Colors.green : Colors.orange,
        );
        // Refresh the entire state so the specialist moves out of pending
        await fetchDashboardData();
      } else if (response.statusCode == 401) {
        _redirectToLogin();
      } else {
        _showFeedbackSnackBar(
          "Failed to update specialist status.",
          Colors.red,
        );
      }
    } catch (e) {
      _showFeedbackSnackBar("Network Error: $e", Colors.red);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDashboardData();
  }

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  void _redirectToLogin() {
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    _redirectToLogin();
  }

  // 1. GET - Fetch and Initialize Dashboard Data from Laravel
  Future<void> fetchDashboardData() async {
    setState(() {
      isLoading = true;
      _error = null;
    });

    final token = await _getToken();
    if (token == null) {
      _redirectToLogin();
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/admin/dashboard'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final payload = json.decode(response.body);
        setState(() {
          specialists = payload['specialists'] ?? [];
          parents = payload['parents'] ?? [];
          volunteers = payload['volunteers'] ?? [];
          pendingWorkshops = payload['pendingWorkshops'] ?? [];
          resources = payload['resources'] ?? [];
          isLoading = false;
        });
      } else if (response.statusCode == 401) {
        _redirectToLogin();
      } else {
        throw Exception('Server returned code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        _error = e.toString();
      });
      _showFeedbackSnackBar(
        "Error syncing with backend server: $e",
        Colors.red,
      );
    }
  }

  void _showFeedbackSnackBar(String msg, Color bg) {
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: bg));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(
        title: const Text(
          "Admin Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: fetchDashboardData,
          ),
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryBlue))
          : RefreshIndicator(
              onRefresh: fetchDashboardData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 30),

                    const Text(
                      "Quick Actions",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    _buildActionGrid(),

                    const SizedBox(height: 30),

                    _buildSectionHeader("Pending Volunteer Workshops"),
                    if (pendingWorkshops.isEmpty)
                      _buildEmptyPlaceholder(
                        "No pending volunteer workshops to review",
                      )
                    else
                      ...pendingWorkshops.asMap().entries.map((e) {
                        final item = e.value;
                        return _buildApprovalCard(
                          item['title'] ?? "No Title",
                          "Proposed by: ${item['proposed_by'] ?? 'Unknown'}",
                          "Description: ${item['description'] ?? ''}\nScheduled Date: ${item['scheduled_date'] ?? 'TBD'}",
                          Icons.volunteer_activism,
                          accentTeal,
                          () => handleWorkshopStatus(e.key, approve: true),
                          () => handleWorkshopStatus(e.key, approve: false),
                        );
                      }),

                    _buildSectionHeader("Pending Specialist Applications"),
                    if (specialists
                        .where((s) => s["status"] == "pending")
                        .isEmpty)
                      _buildEmptyPlaceholder("No pending specialists to review")
                    else
                      ...specialists.where((s) => s["status"] == "pending").map((
                        item,
                      ) {
                        final userObj = item["user"] ?? {};
                        return _buildApprovalCard(
                          userObj["name"] ?? "No Name",
                          "Specialization: ${item["specialization"] ?? "Specialist"}",
                          "Experience: ${item["years_of_experience"] ?? 0} years\nBio: ${item["bio"] ?? ''}\nLocation: ${item["location"] ?? ''}",
                          Icons.psychology_rounded,
                          accentPurple,
                          () =>
                              handleSpecialistStatus(item['id'], approve: true),
                          () => handleSpecialistStatus(
                            item['id'],
                            approve: false,
                          ),
                        );
                      }),

                    // --- INTERACTIVE RESOURCE PARENT BLOCK ---
                    _buildSectionHeader("Shared Parent Resources"),
                    if (resources.isEmpty)
                      _buildEmptyPlaceholder("No learning resources shared yet")
                    else
                      ...resources.asMap().entries.map((e) {
                        final item = e.value;
                        final title = isArabic
                            ? item['title_ar']
                            : item['title_en'];
                        final category = isArabic
                            ? item['category_ar']
                            : item['category_en'];
                        return _buildCard(
                          title ?? "",
                          category ?? "",
                          Icons.menu_book_rounded,
                          accentTeal,
                          () => openResourceDialog(index: e.key),
                          () => handleDeleteOperation(
                            'resources',
                            item['id'],
                            e.key,
                          ),
                        );
                      }),

                    // --- CORE MANAGEMENTS ---
                    _buildSectionHeader("Manage Specialists"),
                    if (specialists
                        .where((s) => s["status"] == "approved")
                        .isEmpty)
                      _buildEmptyPlaceholder(
                        "No approved specialists registered",
                      )
                    else
                      ...specialists
                          .asMap()
                          .entries
                          .where((e) => e.value["status"] == "approved")
                          .map((e) {
                            final userObj = e.value["user"] ?? {};
                            return _buildCard(
                              userObj["name"] ?? "No Name",
                              e.value["specialization"] ?? "Specialist",
                              Icons.psychology_rounded,
                              accentPurple,
                              () => openSpecialistDialog(index: e.key),
                              () => handleDeleteOperation(
                                'specialists',
                                e.value['id'],
                                e.key,
                              ),
                            );
                          }),

                    _buildSectionHeader("Manage Parents"),
                    if (parents.isEmpty)
                      _buildEmptyPlaceholder("No parent records added yet")
                    else
                      ...parents.asMap().entries.map((e) {
                        final userObj = e.value["user"] ?? {};
                        return _buildCard(
                          userObj["name"] ?? "No Name",
                          "Email: ${userObj["email"] ?? ''} • Phone: ${e.value["phone"] ?? ''}",
                          Icons.family_restroom_rounded,
                          primaryBlue,
                          () => openParentDialog(index: e.key),
                          () => handleDeleteOperation(
                            'parents',
                            e.value['id'],
                            e.key,
                          ),
                        );
                      }),

                    _buildSectionHeader("Manage Volunteers"),
                    if (volunteers.isEmpty)
                      _buildEmptyPlaceholder(
                        "No registered volunteer applications",
                      )
                    else
                      ...volunteers.asMap().entries.map((e) {
                        final userObj = e.value["user"] ?? {};
                        return _buildCard(
                          userObj["name"] ?? "No Name",
                          e.value["activity"] ?? "General Helper",
                          Icons.volunteer_activism,
                          accentTeal,
                          () => openVolunteerDialog(index: e.key),
                          () => handleDeleteOperation(
                            'volunteers',
                            e.value['id'],
                            e.key,
                          ),
                        );
                      }),
                  ],
                ),
              ),
            ),
    );
  }

  // PATCH - Approve or Decline Volunteer Workshops
  Future<void> handleWorkshopStatus(
    int arrayIndex, {
    required bool approve,
  }) async {
    final token = await _getToken();
    if (token == null) {
      _redirectToLogin();
      return;
    }

    final targetId = pendingWorkshops[arrayIndex]['id'];
    final endpoint = approve
        ? 'workshops/$targetId/approve'
        : 'workshops/$targetId/decline';

    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/api/admin/$endpoint'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        _showFeedbackSnackBar(
          approve
              ? "Workshop has been approved live!"
              : "Workshop application turned down.",
          approve ? Colors.green : Colors.orange,
        );
        setState(() => pendingWorkshops.removeAt(arrayIndex));
      } else if (response.statusCode == 401) {
        _redirectToLogin();
      } else {
        _showFeedbackSnackBar("Failed to update workshop status.", Colors.red);
      }
    } catch (e) {
      _showFeedbackSnackBar("Network Error: $e", Colors.red);
    }
  }

  // DELETE - Remove records completely from the database
  Future<void> handleDeleteOperation(
    String contextKey,
    dynamic modelId,
    int arrayIndex,
  ) async {
    final token = await _getToken();
    if (token == null) {
      _redirectToLogin();
      return;
    }

    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/admin/$contextKey/$modelId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        _showFeedbackSnackBar(
          "Record removed from database successfully.",
          Colors.green,
        );
        setState(() {
          if (contextKey == 'volunteers') volunteers.removeAt(arrayIndex);
          if (contextKey == 'specialists') specialists.removeAt(arrayIndex);
          if (contextKey == 'parents') parents.removeAt(arrayIndex);
          if (contextKey == 'resources') resources.removeAt(arrayIndex);
        });
      } else if (response.statusCode == 401) {
        _redirectToLogin();
      } else {
        _showFeedbackSnackBar("Could not delete item from server.", Colors.red);
      }
    } catch (e) {
      _showFeedbackSnackBar("Network Error: $e", Colors.red);
    }
  }

  Widget _buildHeader() => Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      gradient: const LinearGradient(colors: [primaryBlue, Color(0xFF1565C0)]),
      borderRadius: BorderRadius.circular(20),
    ),
    child: const Row(
      children: [
        Icon(Icons.admin_panel_settings, color: Colors.white, size: 30),
        SizedBox(width: 10),
        Text(
          "Welcome Autism World Admin",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );

  Widget _buildActionGrid() => GridView.count(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    crossAxisCount: 2,
    crossAxisSpacing: 10,
    mainAxisSpacing: 10,
    childAspectRatio: 2.5,
    children: [
      _buildMenuCard(
        "Share Resource",
        Icons.post_add_rounded,
        accentTeal,
        () => openResourceDialog(),
      ),
      _buildMenuCard(
        "Add Specialist",
        Icons.assignment_ind_rounded,
        accentPurple,
        () => openSpecialistDialog(),
      ),
      _buildMenuCard(
        "Add Parent",
        Icons.person_add,
        primaryBlue,
        () => openParentDialog(),
      ),
      _buildMenuCard(
        "Add Volunteer",
        Icons.person_2_outlined,
        accentOrange,
        () => openVolunteerDialog(),
      ),
    ],
  );

  Widget _buildSectionHeader(String title) => Padding(
    padding: const EdgeInsets.only(top: 25, bottom: 10),
    child: Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
  );

  Widget _buildEmptyPlaceholder(String message) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Text(
      message,
      style: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
      textAlign: TextAlign.center,
    ),
  );

  Widget _buildCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onEdit,
    VoidCallback onDelete,
  ) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
      ],
    ),
    child: Row(
      children: [
        CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        IconButton(icon: const Icon(Icons.edit, size: 20), onPressed: onEdit),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red, size: 20),
          onPressed: onDelete,
        ),
      ],
    ),
  );

  Widget _buildApprovalCard(
    String title,
    String author,
    String description,
    IconData icon,
    Color color,
    VoidCallback onApprove,
    VoidCallback onDecline,
  ) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    author,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          description,
          style: TextStyle(color: Colors.grey[800], fontSize: 13, height: 1.4),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton.icon(
              onPressed: onDecline,
              icon: const Icon(Icons.close, color: Colors.red, size: 18),
              label: const Text("Decline", style: TextStyle(color: Colors.red)),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: onApprove,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.check, size: 18),
              label: const Text("Approve"),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _buildMenuCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(15),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 5),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );

  void openResourceDialog({int? index}) {
    final isEdit = index != null;
    final titleEnC = TextEditingController(
      text: isEdit ? resources[index]["title_en"] ?? "" : "",
    );
    final titleArC = TextEditingController(
      text: isEdit ? resources[index]["title_ar"] ?? "" : "",
    );
    final catEnC = TextEditingController(
      text: isEdit ? resources[index]["category_en"] ?? "" : "",
    );
    final catArC = TextEditingController(
      text: isEdit ? resources[index]["category_ar"] ?? "" : "",
    );
    final descEnC = TextEditingController(
      text: isEdit ? resources[index]["description_en"] ?? "" : "",
    );
    final descArC = TextEditingController(
      text: isEdit ? resources[index]["description_ar"] ?? "" : "",
    );
    final iconC = TextEditingController(
      text: isEdit ? resources[index]["icon"] ?? "" : "",
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEdit ? "Edit Resource" : "Share Autism Resource"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleEnC,
                decoration: const InputDecoration(labelText: "Title (English)"),
              ),
              TextField(
                controller: titleArC,
                decoration: const InputDecoration(
                  labelText: "العنوان (العربية)",
                ),
              ),
              TextField(
                controller: catEnC,
                decoration: const InputDecoration(
                  labelText: "Category (English)",
                ),
              ),
              TextField(
                controller: catArC,
                decoration: const InputDecoration(labelText: "الفئة (العربية)"),
              ),
              TextField(
                controller: descEnC,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: "Description (English)",
                ),
              ),
              TextField(
                controller: descArC,
                maxLines: 2,
                decoration: const InputDecoration(labelText: "الوصف (العربية)"),
              ),
              TextField(
                controller: iconC,
                decoration: const InputDecoration(
                  labelText: "Icon (optional - e.g., Icons.menu_book)",
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final payload = {
                "title_en": titleEnC.text,
                "title_ar": titleArC.text,
                "category_en": catEnC.text,
                "category_ar": catArC.text,
                "description_en": descEnC.text,
                "description_ar": descArC.text,
                "icon": iconC.text,
              };
              Navigator.pop(context);
              setState(() => isLoading = true);

              final token = await _getToken();
              if (token == null) {
                _redirectToLogin();
                return;
              }

              final headers = {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              };

              try {
                http.Response response;

                if (isEdit) {
                  // Use PUT for update (your backend uses updateResource with PUT)
                  response = await http.put(
                    Uri.parse(
                      '$baseUrl/api/admin/resources/${resources[index]['id']}',
                    ),
                    headers: headers,
                    body: json.encode(payload),
                  );
                } else {
                  // Use POST for create
                  response = await http.post(
                    Uri.parse('$baseUrl/api/admin/resources'),
                    headers: headers,
                    body: json.encode(payload),
                  );
                }

                if (response.statusCode == 200 || response.statusCode == 201) {
                  _showFeedbackSnackBar(
                    isEdit
                        ? "Resource updated successfully!"
                        : "Bilingual parent resource published!",
                    Colors.green,
                  );
                  await fetchDashboardData();
                } else if (response.statusCode == 401) {
                  _redirectToLogin();
                } else {
                  final errorBody = json.decode(response.body);
                  _showFeedbackSnackBar(
                    errorBody['message'] ?? "Failed to save resource.",
                    Colors.red,
                  );
                  setState(() => isLoading = false);
                }
              } catch (e) {
                _showFeedbackSnackBar(
                  "Network Exception Error: $e",
                  Colors.red,
                );
                setState(() => isLoading = false);
              }
            },
            child: Text(isEdit ? "Update" : "Publish"),
          ),
        ],
      ),
    );
  }

  void openSpecialistDialog({int? index}) {
    final bool isEdit = index != null;

    // Core controllers
    final nameC = TextEditingController(
      text: isEdit ? specialists[index]["user"]["name"] ?? "" : "",
    );
    final emailC = TextEditingController(
      text: isEdit ? specialists[index]["user"]["email"] ?? "" : "",
    );
    final passC = TextEditingController();
    final specC = TextEditingController(
      text: isEdit ? specialists[index]["specialization"] ?? "" : "",
    );
    final licC = TextEditingController(
      text: isEdit ? specialists[index]["license"] ?? "" : "",
    );

    // ADDED: New attribute fields controllers
    final expC = TextEditingController(
      text: isEdit
          ? (specialists[index]["years_of_experience"]?.toString() ?? "")
          : "",
    );
    final bioC = TextEditingController(
      text: isEdit ? specialists[index]["bio"] ?? "" : "",
    );
    final locC = TextEditingController(
      text: isEdit ? specialists[index]["location"] ?? "" : "",
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          isEdit ? "Edit Specialist Parameters" : "Add Autism Specialist",
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameC,
                decoration: const InputDecoration(labelText: "Full Name"),
              ),
              TextField(
                controller: emailC,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              if (!isEdit)
                TextField(
                  controller: passC,
                  decoration: const InputDecoration(
                    labelText: "Default Account Password",
                  ),
                ),
              TextField(
                controller: specC,
                decoration: const InputDecoration(labelText: "Specialization"),
              ),
              TextField(
                controller: licC,
                decoration: const InputDecoration(labelText: "License No."),
              ),
              // ADDED: Input Form components for the new properties
              TextField(
                controller: expC,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Years of Experience",
                ),
              ),
              TextField(
                controller: locC,
                decoration: const InputDecoration(
                  labelText: "Location (City / Clinic Address)",
                ),
              ),
              TextField(
                controller: bioC,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Biography / Bio Context",
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              // Appending fields into request bundle payload map
              final payload = {
                "name": nameC.text,
                "email": emailC.text,
                "specialization": specC.text,
                "license": licC.text,
                "years_of_experience": int.tryParse(expC.text) ?? 0,
                "bio": bioC.text,
                "location": locC.text,
              };

              if (!isEdit) {
                payload["password"] = passC.text.isEmpty
                    ? "secret123"
                    : passC.text;
              }

              Navigator.pop(context);
              setState(() => isLoading = true);

              final token = await _getToken();
              if (token == null) {
                _redirectToLogin();
                return;
              }

              final headers = {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              };

              try {
                final response = isEdit
                    ? await http.put(
                        Uri.parse(
                          '$baseUrl/api/admin/specialists/${specialists[index]['id']}',
                        ),
                        headers: headers,
                        body: json.encode(payload),
                      )
                    : await http.post(
                        Uri.parse('$baseUrl/api/admin/specialists'),
                        headers: headers,
                        body: json.encode(payload),
                      );

                if (response.statusCode == 200 || response.statusCode == 201) {
                  _showFeedbackSnackBar(
                    isEdit
                        ? "Specialist details updated!"
                        : "Specialist successfully added to team catalog!",
                    Colors.green,
                  );
                  await fetchDashboardData();
                } else if (response.statusCode == 401) {
                  _redirectToLogin();
                } else {
                  _showFeedbackSnackBar(
                    "Failed transaction update workflow operations.",
                    Colors.red,
                  );
                  setState(() => isLoading = false);
                }
              } catch (e) {
                _showFeedbackSnackBar(
                  "Network connection error node point: $e",
                  Colors.red,
                );
                setState(() => isLoading = false);
              }
            },
            child: Text(isEdit ? "Update" : "Add"),
          ),
        ],
      ),
    );
  }

  // POST & PUT - Parent Profile Sync
  void openParentDialog({int? index}) {
    final isEdit = index != null;
    final userObj = isEdit ? (parents[index]["user"] ?? {}) : {};

    final nameC = TextEditingController(text: isEdit ? userObj["name"] : "");
    final emailC = TextEditingController(text: isEdit ? userObj["email"] : "");
    final phoneC = TextEditingController(
      text: isEdit ? parents[index]["phone"] ?? "" : "",
    );
    final addrC = TextEditingController(
      text: isEdit ? parents[index]["address"] ?? "" : "",
    );
    final passC = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEdit ? "Edit Parent Details" : "Register Parent Profile"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameC,
                decoration: const InputDecoration(labelText: "Parent Name"),
              ),
              TextField(
                controller: emailC,
                decoration: const InputDecoration(labelText: "Email Address"),
              ),
              if (!isEdit)
                TextField(
                  controller: passC,
                  decoration: const InputDecoration(
                    labelText: "Secure Account Password",
                  ),
                ),
              TextField(
                controller: phoneC,
                decoration: const InputDecoration(labelText: "Phone Contact"),
              ),
              TextField(
                controller: addrC,
                decoration: const InputDecoration(
                  labelText: "Residential Address",
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final payload = {
                "name": nameC.text,
                "email": emailC.text,
                "phone": phoneC.text,
                "address": addrC.text,
              };
              if (!isEdit)
                payload["password"] = passC.text.isEmpty
                    ? "parent123"
                    : passC.text;

              Navigator.pop(context);
              setState(() => isLoading = true);

              final token = await _getToken();
              if (token == null) {
                _redirectToLogin();
                return;
              }

              final headers = {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              };

              try {
                final response = isEdit
                    ? await http.put(
                        Uri.parse(
                          '$baseUrl/api/admin/parents/${parents[index]['id']}',
                        ),
                        headers: headers,
                        body: json.encode(payload),
                      )
                    : await http.post(
                        Uri.parse('$baseUrl/api/admin/parents'),
                        headers: headers,
                        body: json.encode(payload),
                      );

                if (response.statusCode == 200 || response.statusCode == 201) {
                  _showFeedbackSnackBar(
                    isEdit
                        ? "Parent record synced!"
                        : "Parent profile entry registered successfully!",
                    Colors.green,
                  );
                  await fetchDashboardData();
                } else if (response.statusCode == 401) {
                  _redirectToLogin();
                } else {
                  _showFeedbackSnackBar(
                    "Backend registration failed validation blocks.",
                    Colors.red,
                  );
                  setState(() => isLoading = false);
                }
              } catch (e) {
                _showFeedbackSnackBar(
                  "Network exception error node: $e",
                  Colors.red,
                );
                setState(() => isLoading = false);
              }
            },
            child: Text(isEdit ? "Update" : "Register"),
          ),
        ],
      ),
    );
  }

  // POST & PUT - Volunteer Management Dialog
  void openVolunteerDialog({int? index}) {
    final isEdit = index != null;
    final userObj = isEdit ? (volunteers[index]["user"] ?? {}) : {};

    final nameC = TextEditingController(text: isEdit ? userObj["name"] : "");
    final emailC = TextEditingController(text: isEdit ? userObj["email"] : "");
    final phoneC = TextEditingController(
      text: isEdit ? volunteers[index]["phone"] ?? "" : "",
    );
    final actC = TextEditingController(
      text: isEdit ? volunteers[index]["activity"] ?? "" : "",
    );
    final passC = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          isEdit ? "Edit Volunteer Profile" : "Register Volunteer Account",
        ),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameC,
                decoration: const InputDecoration(labelText: "Full Name"),
              ),
              TextField(
                controller: emailC,
                decoration: const InputDecoration(labelText: "Email ID"),
              ),
              if (!isEdit)
                TextField(
                  controller: passC,
                  decoration: const InputDecoration(labelText: "Password"),
                ),
              TextField(
                controller: phoneC,
                decoration: const InputDecoration(labelText: "Phone"),
              ),
              TextField(
                controller: actC,
                decoration: const InputDecoration(
                  labelText: "Volunteering Activity Assignment",
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final payload = {
                "name": nameC.text,
                "email": emailC.text,
                "phone": phoneC.text,
                "activity": actC.text,
              };
              if (!isEdit)
                payload["password"] = passC.text.isEmpty
                    ? "volunteer123"
                    : passC.text;

              Navigator.pop(context);
              setState(() => isLoading = true);

              final token = await _getToken();
              if (token == null) {
                _redirectToLogin();
                return;
              }

              final headers = {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              };

              try {
                final response = isEdit
                    ? await http.put(
                        Uri.parse(
                          '$baseUrl/api/admin/volunteers/${volunteers[index]['id']}',
                        ),
                        headers: headers,
                        body: json.encode(payload),
                      )
                    : await http.post(
                        Uri.parse('$baseUrl/api/admin/volunteers'),
                        headers: headers,
                        body: json.encode(payload),
                      );

                if (response.statusCode == 200 || response.statusCode == 201) {
                  _showFeedbackSnackBar(
                    isEdit
                        ? "Volunteer details updated."
                        : "Volunteer assigned successfully!",
                    Colors.green,
                  );
                  await fetchDashboardData();
                } else if (response.statusCode == 401) {
                  _redirectToLogin();
                } else {
                  _showFeedbackSnackBar(
                    "Failed processing target operations database.",
                    Colors.red,
                  );
                  setState(() => isLoading = false);
                }
              } catch (e) {
                _showFeedbackSnackBar(
                  "Network exception error node: $e",
                  Colors.red,
                );
                setState(() => isLoading = false);
              }
            },
            child: Text(isEdit ? "Update" : "Add"),
          ),
        ],
      ),
    );
  }
}
