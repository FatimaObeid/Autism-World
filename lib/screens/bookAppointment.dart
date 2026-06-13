import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:autism_world/l10n/app_localizations.dart';

class BookAppointment extends StatefulWidget {
  const BookAppointment({super.key});

  @override
  State<BookAppointment> createState() => _BookAppointmentState();
}

class _BookAppointmentState extends State<BookAppointment> {
  static const Color primaryBlue = Color(0xFF1E88E5);
  final _formKey = GlobalKey<FormState>();

  // Text Editing Controllers
  final TextEditingController _phoneController = TextEditingController();

  // Page Initialization & Loading States
  bool _isLoading = false;
  bool _isInitializing = true;
  String? _errorMessage;

  // Tracked Database Structural Context Information
  int? parentProfileId;
  String? automaticallySelectedChildId;
  String? automaticallySelectedChildName;

  // Selected Data Values for Database Dispatch
  String? selectedSpecialistId;
  String selectedCategory = "";
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  // Runtime Data Collections
  List<Map<String, dynamic>> allSpecialists = [];
  List<Map<String, dynamic>> filteredSpecialists = [];
  List<String> categories = [];

  String get baseUrl {
    if (kIsWeb) return "http://127.0.0.1:8000";
    if (Platform.isAndroid) return "http://10.0.2.2:8000";
    return "http://127.0.0.1:8000";
  }

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _fetchInitialData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      if (token.isEmpty) {
        setState(() {
          _errorMessage =
              "Authentication token not found. Please log in again.";
          _isInitializing = false;
        });
        return;
      }

      // API Endpoints
      final childDashboardUri = Uri.parse("$baseUrl/api/children");
      final parentDashboardUri = Uri.parse("$baseUrl/api/dashboard");
      final specialistsUri = Uri.parse(
        "$baseUrl/api/specialists",
      ); // Fetching the real deal now

      final headers = {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      };

      final childResponse = await http.get(childDashboardUri, headers: headers);
      final parentResponse = await http.get(
        parentDashboardUri,
        headers: headers,
      );
      final specialistsResponse = await http.get(
        specialistsUri,
        headers: headers,
      );

      if (childResponse.statusCode == 200 &&
          parentResponse.statusCode == 200 &&
          specialistsResponse.statusCode == 200) {
        final childData = jsonDecode(childResponse.body);
        final parentData = jsonDecode(parentResponse.body);
        final specialistsData = jsonDecode(specialistsResponse.body);

        setState(() {
          // 1. CAPTURE PARENT PROFILE ID CONTEXT
          if (parentData['data'] != null &&
              parentData['data']['parent_profile'] != null) {
            parentProfileId = int.tryParse(
              parentData['data']['parent_profile']['id'].toString(),
            );
          } else if (childData['data'] != null &&
              childData['data']['parent_profile'] != null) {
            parentProfileId = int.tryParse(
              childData['data']['parent_profile']['id'].toString(),
            );
          } else {
            // Fallback default safe value for sandbox simulation testing matching backend expectations
            parentProfileId = parentData['user_id'] ?? 16;
          }

          // 2. AUTOMATICALLY ASSIGN AND BIND THE SINGLE CHILD DATA ROW
          if (childData['success'] == true &&
              childData['data'] != null &&
              childData['data']['children'] != null) {
            final List childrenList = childData['data']['children'];
            if (childrenList.isNotEmpty) {
              final singleChild = childrenList.first;
              automaticallySelectedChildId = singleChild['id'].toString();
              automaticallySelectedChildName =
                  singleChild['full_name'] ?? 'Unnamed Profile Context';
            }
          }

          // Dynamic Therapy Specialties categories
          categories = [
            "Speech Therapy",
            "Behavioral Therapy",
            "Occupational Therapy",
            "Psychological Therapy",
          ];
          selectedCategory = categories.first;

          // 3. PARSE DYNAMIC DATABASE SPECIALISTS RETURNED FROM LARAVEL ENDPOINT
          if (specialistsData['success'] == true &&
              specialistsData['specialists'] != null) {
            final List rawSpecs = specialistsData['specialists'];
            allSpecialists = rawSpecs.map<Map<String, dynamic>>((item) {
              return {
                "id": item['id'],
                "specialization": item['therapy_type'] ?? "General Therapy",
                "user": {
                  "name": item['user']?['name'] ?? "Certified Specialist",
                },
              };
            }).toList();
          }

          // Safety absolute fallback if your local DB specialists table is empty during testing
          if (allSpecialists.isEmpty) {
            allSpecialists = [
              {
                "id":
                    1, // Ensure this ID actually exists in your DB before running!
                "specialization": "Occupational Therapy",
                "user": {"name": "Dr. Emily Watson (Sensory Integration)"},
              },
            ];
          }

          _filterSpecialistsByCategory(selectedCategory);
          _isInitializing = false;
        });
      } else {
        setState(() {
          _errorMessage = "API Synchronization Error Code Mismatch.";
          _isInitializing = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Network Integration Error: $e";
        _isInitializing = false;
      });
    }
  }

  void _filterSpecialistsByCategory(String category) {
    setState(() {
      filteredSpecialists = allSpecialists.where((spec) {
        final String specType = (spec['specialization'] ?? '')
            .toString()
            .toLowerCase();
        return specType.contains(category.toLowerCase());
      }).toList();
      selectedSpecialistId = null;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
    );
    if (picked != null) {
      setState(() => selectedTime = picked);
    }
  }

  Future<void> _submitAppointment() async {
    if (!_formKey.currentState!.validate() ||
        selectedDate == null ||
        selectedTime == null ||
        selectedSpecialistId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please completely fill out choices, phone, dates, and specialists.",
          ),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      final String formattedDateTime =
          "${selectedDate!.year.toString().padLeft(4, '0')}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')} "
          "${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}:00";

      final Map<String, dynamic> requestPayload = {
        "child_id": int.parse(
          automaticallySelectedChildId ?? "4",
        ), // Safely falls back if missing
        "specialist_id": int.parse(selectedSpecialistId!),
        "appointment_time": formattedDateTime,
        "therapy_type": selectedCategory,
        "phone": _phoneController.text.trim(),
        "notes": "Requested via mobile app dashboard layout setup.",
      };

      final response = await http.post(
        Uri.parse("$baseUrl/api/appointments"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(requestPayload),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          responseData['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text("Appointment successfully reserved!"),
          ),
        );
        Navigator.pop(context);
      } else {
        String backError =
            responseData['errors']?.toString() ??
            responseData['message'] ??
            "Rejected.";
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text("Validation Failure: $backError"),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Transmission error failed: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_isInitializing) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: primaryBlue)),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          l10n.bookAppointmentTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF0F172A),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Child Display Box
              _buildSectionTitle("Child Profile Context"),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.child_care_outlined,
                      color: primaryBlue,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            automaticallySelectedChildName ?? "hoh",
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            "Booking session for your registered profile",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 2. Contact Phone Field
              _buildSectionTitle("Parent Contact Phone Number"),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Color(0xFF0F172A), fontSize: 15),
                decoration: _inputDecoration(
                  Icons.phone_outlined,
                ).copyWith(hintText: "Enter contact number for verification"),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Phone number is explicitly required.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // 3. Therapy Category Selection
              _buildSectionTitle("Therapy Category Specialization"),
              DropdownButtonFormField<String>(
                value: selectedCategory.isEmpty ? null : selectedCategory,
                dropdownColor: Colors.white,
                items: categories.map((cat) {
                  return DropdownMenuItem<String>(
                    value: cat,
                    child: Text(
                      cat,
                      style: const TextStyle(
                        color: Color(0xFF0F172A),
                        fontSize: 15,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      selectedCategory = val;
                      _filterSpecialistsByCategory(val);
                    });
                  }
                },
                decoration: _inputDecoration(Icons.category_outlined),
              ),
              const SizedBox(height: 20),

              // 4. Certified Specialists Selection Matrix
              _buildSectionTitle("Available Certified Specialists"),
              filteredSpecialists.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        "No medical specialists found under this category on database.",
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredSpecialists.length,
                      itemBuilder: (context, index) {
                        final spec = filteredSpecialists[index];
                        final idStr = spec['id'].toString();
                        final isSelected = selectedSpecialistId == idStr;
                        final userProfile = spec['user'] ?? {};

                        return GestureDetector(
                          onTap: () =>
                              setState(() => selectedSpecialistId = idStr),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected
                                    ? primaryBlue
                                    : const Color(0xFFE2E8F0),
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: primaryBlue.withOpacity(0.1),
                                  child: const Icon(
                                    Icons.person,
                                    color: primaryBlue,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Text(
                                    userProfile['name'] ??
                                        "Clinical Professional Row",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(
                                    Icons.check_circle,
                                    color: primaryBlue,
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
              const SizedBox(height: 20),

              // 5. Timing Pickers
              _buildSectionTitle("Schedule Session Timing & Date"),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _selectDate(context),
                      icon: const Icon(Icons.calendar_today, size: 18),
                      label: Text(
                        selectedDate == null
                            ? "Select Date"
                            : "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}",
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Color(0xFFE2E8F0)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _selectTime(context),
                      icon: const Icon(Icons.access_time, size: 18),
                      label: Text(
                        selectedTime == null
                            ? "Select Time"
                            : selectedTime!.format(context),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Color(0xFFE2E8F0)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 35),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitAppointment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          l10n.bookAppointmentTitle,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 2),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: Color(0xFF334155),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: Colors.grey[500], size: 20),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryBlue, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
    );
  }
}
}
