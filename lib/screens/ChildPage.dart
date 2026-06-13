import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:autism_world/l10n/app_localizations.dart';

class ChildPage extends StatefulWidget {
  const ChildPage({super.key});

  @override
  State<ChildPage> createState() => _ChildPageState();
}

class _ChildPageState extends State<ChildPage> {
  final _formKey = GlobalKey<FormState>();

  // Optimized Parental Entry Fields
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _medicalDetailsController = TextEditingController();
  final _importantNotesController = TextEditingController();

  String? _selectedGender;
  String? _autismLevel;
  bool _hasSevereCondition = false;
  bool _isLoading = false;

  // Premium UI Theme Palette Colors
  static const Color primaryBlue = Color(0xFF1E88E5);
  static const Color lightBlueBg = Color(0xFFF0F7FF);
  static const Color textDark = Color(0xFF0F172A);
  static const Color textLight = Color(0xFF64748B);
  static const Color surfaceCard = Color(0xFFFFFFFF);

  String get baseUrl {
    if (kIsWeb) return "http://127.0.0.1:8000";
    if (Platform.isAndroid) return "http://10.0.2.2:8000";
    return "http://127.0.0.1:8000";
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 4)),
      firstDate: DateTime(2010),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryBlue,
              onPrimary: Colors.white,
              onSurface: textDark,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      final response = await http.post(
        Uri.parse("$baseUrl/api/children"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "full_name": _nameController.text.trim(),
          "dob": _dobController.text.trim(),
          "gender": _selectedGender,
          "autism_level": _autismLevel,
          "behavioral_description": _descriptionController.text.trim(),
          "has_severe_condition": _hasSevereCondition,
          "medical_details": _hasSevereCondition
              ? _medicalDetailsController.text.trim()
              : null,
          "important_notes": _importantNotesController.text.trim(),
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors
                .green, // Fixed: Changed from Colors.emerald to Colors.green
            behavior: SnackBarBehavior.floating,
            content: Text("Profile saved seamlessly!"),
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(data['message'] ?? "Failed to save profile data."),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Connection Exception: $e"),
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          l10n.childProfileTitle,
          style: const TextStyle(
            color: textDark,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        foregroundColor: textDark,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SECTION 1: Identity & Demographics
                _buildCardWrapper(
                  title: "Personal Information",
                  subtitle: "Basic profile identity records",
                  icon: Icons.badge_outlined,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      validator: (v) =>
                          v!.isEmpty ? "Full name is required" : null,
                      style: const TextStyle(color: textDark, fontSize: 15),
                      decoration: _inputDecoration(
                        label: l10n.childFullName,
                        icon: Icons.person_outline,
                      ),
                    ),
                    const SizedBox(height: 18),
                    TextFormField(
                      controller: _dobController,
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      validator: (v) =>
                          v!.isEmpty ? "Date of birth is required" : null,
                      style: const TextStyle(color: textDark, fontSize: 15),
                      decoration: _inputDecoration(
                        label: l10n.birthDate,
                        icon: Icons.calendar_today_outlined,
                        hint: "YYYY-MM-DD",
                      ),
                    ),
                    const SizedBox(height: 18),
                    DropdownButtonFormField<String>(
                      value: _selectedGender,
                      items: ["Male", "Female"]
                          .map(
                            (g) => DropdownMenuItem(value: g, child: Text(g)),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => _selectedGender = v),
                      validator: (v) =>
                          v == null ? "Gender selection is required" : null,
                      dropdownColor: Colors.white,
                      style: const TextStyle(color: textDark, fontSize: 15),
                      decoration: _inputDecoration(
                        label: "Gender",
                        icon: Icons.wc_outlined,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // SECTION 2: Health Conditions & Symptoms Tracking
                _buildCardWrapper(
                  title: "Development & Health Profile",
                  subtitle: "Diagnostic spectrum overview metrics",
                  icon: Icons.analytics_outlined,
                  children: [
                    DropdownButtonFormField<String>(
                      value: _autismLevel,
                      items: ["Level 1", "Level 2", "Level 3"]
                          .map(
                            (l) => DropdownMenuItem(value: l, child: Text(l)),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => _autismLevel = v),
                      validator: (v) =>
                          v == null ? "Please specify diagnostic level" : null,
                      dropdownColor: Colors.white,
                      style: const TextStyle(color: textDark, fontSize: 15),
                      decoration: _inputDecoration(
                        label: "Autism Spectrum Level",
                        icon: Icons.psychology_outlined,
                      ),
                    ),
                    const SizedBox(height: 18),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 3,
                      style: const TextStyle(color: textDark, fontSize: 14),
                      decoration: _inputDecoration(
                        label: "Behavioral Characteristics / Traits",
                        icon: Icons.description_outlined,
                        hint:
                            "Brief info regarding active triggers, behaviors, or preferences...",
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: SwitchListTile(
                        title: const Text(
                          "Additional Medical Conditions",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: textDark,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: const Text(
                          "Does the child experience other medical complexities?",
                          style: TextStyle(fontSize: 12, color: textLight),
                        ),
                        value: _hasSevereCondition,
                        activeColor: primaryBlue,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 4,
                        ),
                        onChanged: (v) =>
                            setState(() => _hasSevereCondition = v),
                      ),
                    ),
                    if (_hasSevereCondition) ...[
                      const SizedBox(height: 18),
                      TextFormField(
                        controller: _medicalDetailsController,
                        maxLines: 2,
                        validator: (v) => (_hasSevereCondition && v!.isEmpty)
                            ? "Medical tracking info details are required"
                            : null,
                        style: const TextStyle(color: textDark, fontSize: 14),
                        decoration: _inputDecoration(
                          label: "Specific Medical Details",
                          icon: Icons.medical_services_outlined,
                        ),
                      ),
                    ],
                    const SizedBox(height: 18),
                    TextFormField(
                      controller: _importantNotesController,
                      maxLines: 2,
                      style: const TextStyle(color: textDark, fontSize: 14),
                      decoration: _inputDecoration(
                        label: "Notes for the Specialist",
                        icon: Icons.rate_review_outlined,
                        hint:
                            "Anything specific you want to communicate or address...",
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // SUBMIT ACTION BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : Text(
                            l10n.saveChildProfile,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.3,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardWrapper({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceCard,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(
              0xFF0F172A,
            ).withOpacity(0.04), // Fixed syntax issue here
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: lightBlueBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: primaryBlue, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: textDark,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 12, color: textLight),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: Color(0xFFF1F5F9), thickness: 1.2, height: 1),
          ),
          ...children,
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    String? hint,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: textLight,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
      prefixIcon: Icon(icon, color: textLight, size: 20),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: primaryBlue, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
      filled: true,
      fillColor: const Color(0xFFFAFAFA),
    );
  }
}
