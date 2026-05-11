import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:autism_world/l10n/app_localizations.dart';

class ChildPage extends StatefulWidget {
  const ChildPage({super.key});

  @override
  State<ChildPage> createState() => _ChildPageState();
}

class _ChildPageState extends State<ChildPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _medicalDetailsController = TextEditingController();

  String? _selectedGender;
  String? _autismLevel;
  bool _hasSevereCondition = false;

  // Consistent colors from the app theme
  static const Color primaryBlue2 = Color(0xFF1E88E5);
  static const Color lightBlueBg = Color(0xFFEFF6FF);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textLight = Color(0xFF64748B);

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(l10n.childProfileTitle),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section: Personal Information
              Text(
                l10n.personalInformation,
                style: const TextStyle(
                  color: textLight,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.08),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      style: const TextStyle(
                        color: textDark,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: _inputDecoration(
                        label: l10n.childFullName,
                        icon: Icons.person_rounded,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _dobController,
                            readOnly: true,
                            onTap: () => _selectDate(context),
                            style: const TextStyle(
                              color: textDark,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: _inputDecoration(
                              label: l10n.birthDate,
                              icon: Icons.calendar_month_rounded,
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            dropdownColor: Colors.white,
                            icon: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: primaryBlue2,
                            ),
                            items: [
                              DropdownMenuItem(
                                value: "Male",
                                child: Text(l10n.male),
                              ),
                              DropdownMenuItem(
                                value: "Female",
                                child: Text(l10n.female),
                              ),
                            ],
                            onChanged: (val) =>
                                setState(() => _selectedGender = val),
                            decoration: _inputDecoration(
                              label: l10n.gender,
                              icon: Icons.wc_rounded,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // Section: Medical Profile
              Text(
                l10n.medicalProfile,
                style: const TextStyle(
                  color: textLight,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.08),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: primaryBlue2,
                      ),
                      items: [
                        DropdownMenuItem(
                          value: "Level 1 - Mild",
                          child: Text(l10n.level1Mild),
                        ),
                        DropdownMenuItem(
                          value: "Level 2 - Moderate",
                          child: Text(l10n.level2Moderate),
                        ),
                        DropdownMenuItem(
                          value: "Level 3 - Severe",
                          child: Text(l10n.level3Severe),
                        ),
                      ],
                      onChanged: (val) => setState(() => _autismLevel = val),
                      decoration: _inputDecoration(
                        label: l10n.autismLevel,
                        icon: Icons.medical_information_rounded,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 4,
                      style: const TextStyle(color: textDark),
                      decoration: _inputDecoration(
                        label: l10n.behavioralDescription,
                        icon: Icons.notes_rounded,
                        hint: l10n.behavioralHint,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // Severe Condition Toggle
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.08),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: _hasSevereCondition
                      ? Border.all(color: Colors.red.shade200, width: 1)
                      : null,
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        l10n.severeCondition,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      activeColor: Colors.redAccent,
                      value: _hasSevereCondition,
                      onChanged: (val) =>
                          setState(() => _hasSevereCondition = val),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: _hasSevereCondition ? 100 : 0,
                      curve: Curves.easeInOut,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: TextFormField(
                            controller: _medicalDetailsController,
                            maxLines: 2,
                            decoration: InputDecoration(
                              labelText: l10n.specifyCondition,
                              labelStyle: TextStyle(
                                color: Colors.red.shade700,
                                fontSize: 14,
                              ),
                              filled: true,
                              fillColor: Colors.red.withOpacity(0.04),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.childProfileSaved)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue2,
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    l10n.saveChildProfile,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method for consistent input decoration
  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    String? hint,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: textLight, fontSize: 14),
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 13),
      prefixIcon: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: lightBlueBg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: primaryBlue2, size: 20),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: primaryBlue2, width: 1.5),
      ),
      filled: true,
      fillColor: const Color(0xFFF1F5F9),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}

