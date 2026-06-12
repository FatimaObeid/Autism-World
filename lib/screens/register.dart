import 'dart:convert';
import 'package:autism_world/screens/parent.dart';
import 'package:autism_world/screens/login.dart';
import 'package:autism_world/screens/specialist/specialist.dart';
import 'package:autism_world/screens/volunteer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:autism_world/l10n/app_localizations.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController specializationController = TextEditingController();
  TextEditingController licenseController = TextEditingController();
  TextEditingController typeController = TextEditingController();

  // Added Specialist Specific Controllers
  TextEditingController experienceController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  DateTime? selectedDateOfBirth;
  bool _isPasswordHidden = true;
  bool loading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? selectedRole;
  final String baseUrl = "http://127.0.0.1:8000";

  Future<void> registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    try {
      final Map<String, String> registrationData = {
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "password": passwordController.text,
        "role": selectedRole!,
      };

      if (dateOfBirthController.text.isNotEmpty) {
        registrationData["date_of_birth"] = dateOfBirthController.text;
      }
      if (phoneController.text.isNotEmpty) {
        registrationData["phone"] = phoneController.text.trim();
      }
      if (addressController.text.isNotEmpty) {
        registrationData["address"] = addressController.text.trim();
      }
      if (specializationController.text.isNotEmpty) {
        registrationData["specialization"] = specializationController.text
            .trim();
      }
      if (licenseController.text.isNotEmpty) {
        registrationData["license_number"] = licenseController.text.trim();
      }
      if (typeController.text.isNotEmpty) {
        registrationData["activity"] = typeController.text.trim();
      }

      // Appending newly added structural specialist parameters to payload
      if (selectedRole == "Specialist") {
        registrationData["experience_years"] = experienceController.text.trim();
        registrationData["clinic_location"] = locationController.text.trim();
        registrationData["description"] = descriptionController.text.trim();
      }

      final response = await http.post(
        Uri.parse("$baseUrl/api/register"),
        headers: {"Accept": "application/json"},
        body: registrationData,
      );

      if (!mounted) return;

      print("--- RAW SERVER RESPONSE ---");
      print("Status Code: ${response.statusCode}");
      print("Body: ${response.body}");
      print("---------------------------");

      dynamic data;
      try {
        data = jsonDecode(response.body);
      } on FormatException catch (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Server configuration error. Check debug console."),
            backgroundColor: Colors.red,
          ),
        );
        setState(() => loading = false);
        return;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        String token = "";
        if (data["token"] != null) {
          token = data["token"];
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data["message"] ?? "Registration successful!"),
          ),
        );

        if (selectedRole == "Parent") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const ParentPage()),
          );
        } else if (selectedRole == "Specialist") {
          // INTERCEPT NAVIGATION: Push to approval message container screen instead of the direct dashboard
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const SpecialistPendingApprovalPage(),
            ),
          );
        } else {
          final String extractedName =
              data["user"] != null && data["user"]["name"] != null
              ? data["user"]["name"]
              : nameController.text.trim();

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => VolunteerDashboard(
                volunteerName: extractedName,
                token: token,
              ),
            ),
          );
        }
      } else {
        String errorMessage = data["message"] ?? "Registration failed";
        if (data["errors"] != null) {
          errorMessage = (data["errors"] as Map).values.first[0].toString();
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    }

    setState(() => loading = false);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    dateOfBirthController.dispose();
    phoneController.dispose();
    addressController.dispose();
    specializationController.dispose();
    licenseController.dispose();
    typeController.dispose();
    experienceController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  InputDecoration _buildModernInput({
    required String label,
    required String hint,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(prefixIcon, color: Colors.grey.shade500),
      suffixIcon: suffixIcon,
      labelStyle: TextStyle(color: Colors.grey.shade700, fontSize: 15),
      hintStyle: const TextStyle(
        letterSpacing: 1,
        color: Colors.grey,
        fontSize: 14,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.blue, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.red.shade400, width: 1.2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.red.shade500, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 20,
                            spreadRadius: 1,
                            offset: const Offset(0, 8),
                          ),
                        ],
                        border: Border.all(
                          color: Colors.blue.shade50,
                          width: 4,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/logo.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.blue.shade50,
                              child: const Icon(
                                Icons.emoji_nature_rounded,
                                size: 60,
                                color: Colors.blue,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  l10n.joinCommunity,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.createAccountDesc,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 35),

                TextFormField(
                  controller: nameController,
                  decoration: _buildModernInput(
                    label: l10n.fullName,
                    hint: l10n.hintFullName,
                    prefixIcon: Icons.person_outline,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return l10n.pleaseEnterName;
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _buildModernInput(
                    label: l10n.email,
                    hint: l10n.hintEmail,
                    prefixIcon: Icons.email_outlined,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return l10n.pleaseEnterEmail;
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value))
                      return l10n.validEmail;
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                TextFormField(
                  controller: passwordController,
                  obscureText: _isPasswordHidden,
                  decoration: _buildModernInput(
                    label: l10n.password,
                    hint: l10n.hintPassword,
                    prefixIcon: Icons.lock_outline,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordHidden
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () => setState(
                        () => _isPasswordHidden = !_isPasswordHidden,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.length < 6)
                      return l10n.passwordMinLength;
                    return null;
                  },
                ),

                if (selectedRole == 'Parent') ...[
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: dateOfBirthController,
                    readOnly: true,
                    decoration: _buildModernInput(
                      label: l10n.dateOfBirth,
                      hint: l10n.hintDob,
                      prefixIcon: Icons.calendar_today_outlined,
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime(2000),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          selectedDateOfBirth = pickedDate;
                          dateOfBirthController.text =
                              "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                        });
                      }
                    },
                    validator: (value) {
                      if (selectedRole == 'Parent' &&
                          (value == null || value.isEmpty)) {
                        return l10n.thisFieldRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: _buildModernInput(
                      label: l10n.phoneNumber,
                      hint: l10n.hintPhone,
                      prefixIcon: Icons.phone_outlined,
                    ),
                    validator: (value) {
                      if (selectedRole == 'Parent' &&
                          (value == null || value.isEmpty)) {
                        return l10n.thisFieldRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: addressController,
                    decoration: _buildModernInput(
                      label: l10n.address,
                      hint: l10n.hintAddress,
                      prefixIcon: Icons.home_outlined,
                    ),
                    validator: (value) {
                      if (selectedRole == 'Parent' &&
                          (value == null || value.isEmpty)) {
                        return l10n.thisFieldRequired;
                      }
                      return null;
                    },
                  ),
                ],

                if (selectedRole == 'Specialist') ...[
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: specializationController,
                    decoration: _buildModernInput(
                      label: l10n.specialization,
                      hint: l10n.hintSpecialization,
                      prefixIcon: Icons.work_outline,
                    ),
                    validator: (value) {
                      if (selectedRole == 'Specialist' &&
                          (value == null || value.isEmpty)) {
                        return l10n.thisFieldRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: licenseController,
                    decoration: _buildModernInput(
                      label: l10n.licenseNumber,
                      hint: l10n.hintLicense,
                      prefixIcon: Icons.badge_outlined,
                    ),
                    validator: (value) {
                      if (selectedRole == 'Specialist' &&
                          (value == null || value.isEmpty)) {
                        return l10n.thisFieldRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // NEW FIELD: Years of Experience
                  TextFormField(
                    controller: experienceController,
                    keyboardType: TextInputType.number,
                    decoration: _buildModernInput(
                      label: "Years of Experience",
                      hint: "Enter your total years practicing",
                      prefixIcon: Icons.timeline_outlined,
                    ),
                    validator: (value) {
                      if (selectedRole == 'Specialist' &&
                          (value == null || value.isEmpty)) {
                        return l10n.thisFieldRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // NEW FIELD: Clinic Location
                  TextFormField(
                    controller: locationController,
                    decoration: _buildModernInput(
                      label: "Clinic Location / Address",
                      hint: "Enter physical clinic workplace address",
                      prefixIcon: Icons.map_outlined,
                    ),
                    validator: (value) {
                      if (selectedRole == 'Specialist' &&
                          (value == null || value.isEmpty)) {
                        return l10n.thisFieldRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // NEW FIELD: Description
                  TextFormField(
                    controller: descriptionController,
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    decoration: _buildModernInput(
                      label: "Professional Summary / Biography",
                      hint:
                          "Write a short summary about your background therapies",
                      prefixIcon: Icons.description_outlined,
                    ),
                    validator: (value) {
                      if (selectedRole == 'Specialist' &&
                          (value == null || value.isEmpty)) {
                        return l10n.thisFieldRequired;
                      }
                      return null;
                    },
                  ),
                ],

                if (selectedRole == 'Volunteer') ...[
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: _buildModernInput(
                      label: l10n.phoneNumber,
                      hint: l10n.hintPhone,
                      prefixIcon: Icons.phone_outlined,
                    ),
                    validator: (value) {
                      if (selectedRole == 'Volunteer' &&
                          (value == null || value.isEmpty)) {
                        return l10n.thisFieldRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: typeController,
                    decoration: _buildModernInput(
                      label: l10n.volunteerType,
                      hint: l10n.hintVolunteerType,
                      prefixIcon: Icons.person_outline,
                    ),
                    validator: (value) {
                      if (selectedRole == 'Volunteer' &&
                          (value == null || value.isEmpty)) {
                        return l10n.thisFieldRequired;
                      }
                      return null;
                    },
                  ),
                ],

                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  hint: Text(l10n.selectRole),
                  items: [
                    DropdownMenuItem(value: 'Parent', child: Text(l10n.parent)),
                    DropdownMenuItem(
                      value: 'Specialist',
                      child: Text(l10n.specialist),
                    ),
                    DropdownMenuItem(
                      value: 'Volunteer',
                      child: Text(l10n.volunteer),
                    ),
                  ],
                  onChanged: (value) => setState(() => selectedRole = value),
                  validator: (value) =>
                      value == null ? l10n.pleaseSelectRole : null,
                  icon: const Icon(
                    Icons.arrow_drop_down_circle_outlined,
                    color: Colors.blue,
                  ),
                  decoration: InputDecoration(
                    labelText: l10n.iAmA,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 20,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1.2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 35),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: loading ? null : registerUser,
                    child: loading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : Text(
                            l10n.createAccount,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 25),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    child: Text(
                      l10n.login,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// --- APPROVAL LOCKOUT WINDOW COMPONENT ---
class SpecialistPendingApprovalPage extends StatelessWidget {
  const SpecialistPendingApprovalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.gavel_rounded,
                size: 80,
                color: Colors.amber.shade800,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Application Under Review",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Thank you for joining our community! To maintain a safe space for families, all specialist profiles must be manually validated by an administrator.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "You will be granted access to your dashboard once your medical credentials and licenses are approved.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black45,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                label: const Text(
                  "Return to Login",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
