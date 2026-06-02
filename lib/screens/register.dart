import 'package:autism_world/Parent/ParentPage.dart';
import 'package:autism_world/screens/login.dart';
import 'package:autism_world/specialist/specialist.dart';
import 'package:autism_world/screens/volunteer.dart';
import 'package:flutter/material.dart';

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
  DateTime? selectedDateOfBirth;

  bool _isPasswordHidden = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? selectedRole;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
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
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 15,
                            spreadRadius: 2,
                            offset: const Offset(0, 5),
                          ),
                        ],
                        border: Border.all(
                          color: Colors.blue.shade50,
                          width: 3,
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
                // --------------------------------------------------------
                Text(
                  l10n.joinCommunity,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                Text(
                  l10n.createAccountDesc,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),

                const SizedBox(height: 30),

                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: l10n.fullName,
                    hintText: l10n.hintFullName,
                    hintStyle: const TextStyle(
                      letterSpacing: 2,
                      color: Colors.grey,
                    ),
                    prefixIcon: const Icon(
                      Icons.person_outline,
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.pleaseEnterName;
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 30),

                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: l10n.hintEmail,
                    labelText: l10n.email,
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.pleaseEnterEmail;
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return l10n.validEmail;
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 30),

                TextFormField(
                  controller: passwordController,
                  obscureText: _isPasswordHidden,
                  decoration: InputDecoration(
                    hintText: l10n.hintPassword,
                    labelText: l10n.password,
                    hintStyle: const TextStyle(
                      letterSpacing: 2,
                      color: Colors.grey,
                    ),
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordHidden
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordHidden = !_isPasswordHidden;
                        });
                      },
                    ),
                  ),

                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return l10n.passwordMinLength;
                    }
                    return null;
                  },
                ),

                if (selectedRole == 'Parent') ...[
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: dateOfBirthController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: l10n.dateOfBirth,
                      hintText: l10n.hintDob,
                      hintStyle: const TextStyle(
                        letterSpacing: 2,
                        color: Colors.grey,
                      ),
                      prefixIcon: const Icon(
                        Icons.calendar_today_outlined,
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
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
                              "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
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

                  const SizedBox(height: 30),

                  TextFormField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      labelText: l10n.phoneNumber,
                      hintText: l10n.hintPhone,
                      hintStyle: const TextStyle(
                        letterSpacing: 2,
                        color: Colors.grey,
                      ),
                      prefixIcon: const Icon(
                        Icons.phone_outlined,
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    validator: (value) {
                      if (selectedRole == 'Parent' &&
                          (value == null || value.isEmpty)) {
                        return l10n.thisFieldRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: addressController,
                    decoration: InputDecoration(
                      labelText: l10n.address,
                      hintText: l10n.hintAddress,
                      hintStyle: const TextStyle(
                        letterSpacing: 2,
                        color: Colors.grey,
                      ),
                      prefixIcon: const Icon(
                        Icons.home_outlined,
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
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
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: specializationController,
                    decoration: InputDecoration(
                      labelText: l10n.specialization,
                      hintText: l10n.hintSpecialization,
                      hintStyle: const TextStyle(
                        letterSpacing: 2,
                        color: Colors.grey,
                      ),
                      prefixIcon: const Icon(
                        Icons.work_outline,
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    validator: (value) {
                      if (selectedRole == 'Specialist' &&
                          (value == null || value.isEmpty)) {
                        return l10n.thisFieldRequired;
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 30),

                  TextFormField(
                    controller: licenseController,
                    decoration: InputDecoration(
                      labelText: l10n.licenseNumber,
                      hintText: l10n.hintLicense,
                      hintStyle: const TextStyle(
                        letterSpacing: 2,
                        color: Colors.grey,
                      ),
                      prefixIcon: const Icon(
                        Icons.badge_outlined,
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
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
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: phoneController,

                    decoration: InputDecoration(
                      labelText: l10n.phoneNumber,
                      hintText: l10n.hintPhone,
                      hintStyle: const TextStyle(
                        letterSpacing: 2,
                        color: Colors.grey,
                      ),
                      prefixIcon: const Icon(
                        Icons.phone_outlined,
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  TextFormField(
                    controller: typeController,
                    decoration: InputDecoration(
                      labelText: l10n.volunteerType,
                      hintText: l10n.hintVolunteerType,
                      hintStyle: const TextStyle(
                        letterSpacing: 2,
                        color: Colors.grey,
                      ),
                      prefixIcon: const Icon(
                        Icons.person_outline,
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
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
                const SizedBox(height: 30),
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
                  onChanged: (value) {
                    setState(() {
                      selectedRole = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return l10n.pleaseSelectRole;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: l10n.iAmA,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                SizedBox(
                  width: 300,
                  height: 43,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      final isValid = _formKey.currentState!.validate();

                      if (!isValid) {
                        return;
                      }
                      if (selectedRole == 'Parent') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.parentAccountCreated),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ParentPage(),
                          ),
                        );
                      } else if (selectedRole == 'Specialist') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.specialistAccountCreated),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SpecialistPage(),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.volunteerAccountCreated),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const VolunteerDashboard(
                              volunteerName: 'john doe',
                            ),
                          ),
                        );
                      }
                    },
                    child: Text(l10n.createAccount),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.alreadyHaveAccount,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      child: Text(
                        l10n.login,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
(hayde l designed)




(hayde l marbuta bl backend)

import 'dart:convert';
import 'package:autism_world/Parent/ParentPage.dart';
import 'package:autism_world/specialist/specialist.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:autism_world/l10n/app_localizations.dart';
import 'package:autism_world/screens/login.dart';
import 'package:autism_world/screens/volunteer.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  bool loading = false;
  bool hidePassword = true;

  String? selectedRole;
  final String baseUrl = "http://127.0.0.1:8000";

  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final dob = TextEditingController();
  final phone = TextEditingController();
  final address = TextEditingController();
  final specialization = TextEditingController();
  final license = TextEditingController();
  final volunteerType = TextEditingController();

  Future<void> pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      setState(() {
        dob.text =
            "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/register"), //[cite: 1, 5]
        headers: {"Accept": "application/json"}, //
        body: {
          "name": name.text, //[cite: 1]
          "email": email.text, //[cite: 1]
          "password": password.text, //[cite: 1]
          "role": selectedRole!, //[cite: 1]
          "date_of_birth": dob.text, //[cite: 1]
          "phone": phone.text, //[cite: 1]
          "address": address.text, //[cite: 1]
          "specialization": specialization.text, //[cite: 1]
          "license_number": license.text, //[cite: 1]
          "volunteer_type": volunteerType.text, //[cite: 1]
        },
      );

      final data = jsonDecode(response.body); //[cite: 1]

      if (!mounted) return; //[cite: 1]

      if (response.statusCode == 200 || response.statusCode == 201) {
        //[cite: 1]

        // ==================== THE GOLDEN FIX ====================
        // Check if the backend returned the token, and save it locally
        if (data["token"] != null) {
          final token = data["token"];
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);
        }
        // ========================================================

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "Success")), //[cite: 1]
        );

        if (selectedRole == "Parent") {
          //[cite: 1]
          Navigator.pushReplacement(
            //[cite: 1]
            context,
            MaterialPageRoute(builder: (_) => const ParentPage()), //[cite: 1]
          );
        } else if (selectedRole == "Specialist") {
          //[cite: 1]
          Navigator.pushReplacement(
            //[cite: 1]
            context,
            MaterialPageRoute(
              builder: (_) => const SpecialistPage(),
            ), //[cite: 1]
          );
        } else {
          Navigator.pushReplacement(
            //[cite: 1]
            context,
            MaterialPageRoute(
              //[cite: 1]
              builder: (_) =>
                  const VolunteerDashboard(volunteerName: ""), //[cite: 1]
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          //[cite: 1]
          SnackBar(
            content: Text(data["message"] ?? "Registration failed"),
          ), //[cite: 1]
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        //[cite: 1]
        SnackBar(content: Text("Error: $e")), //[cite: 1]
      );
    }

    setState(() => loading = false); //[cite: 1]
  }

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    dob.dispose();
    phone.dispose();
    address.dispose();
    specialization.dispose();
    license.dispose();
    volunteerType.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),

              const Icon(Icons.favorite, size: 70, color: Colors.blue),

              const SizedBox(height: 10),
              Text(
                l10n.joinCommunity,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),
              Text(
                l10n.createAccountDesc,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),

              const SizedBox(height: 30),

              // NAME
              TextFormField(
                controller: name,
                decoration: InputDecoration(labelText: l10n.fullName),
                validator: (v) =>
                    v == null || v.isEmpty ? l10n.pleaseEnterName : null,
              ),

              const SizedBox(height: 15),

              // EMAIL
              TextFormField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: l10n.email),
                validator: (v) =>
                    v == null || v.isEmpty ? l10n.pleaseEnterEmail : null,
              ),

              const SizedBox(height: 15),

              // PASSWORD
              TextFormField(
                controller: password,
                obscureText: hidePassword,
                decoration: InputDecoration(
                  labelText: l10n.password,
                  suffixIcon: IconButton(
                    icon: Icon(
                      hidePassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () =>
                        setState(() => hidePassword = !hidePassword),
                  ),
                ),
                validator: (v) =>
                    v == null || v.length < 6 ? l10n.passwordMinLength : null,
              ),

              const SizedBox(height: 15),

              // ROLE
              DropdownButtonFormField<String>(
                value: selectedRole,
                decoration: InputDecoration(labelText: l10n.selectRole),
                items: [
                  DropdownMenuItem(value: "Parent", child: Text(l10n.parent)),
                  DropdownMenuItem(
                    value: "Specialist",
                    child: Text(l10n.specialist),
                  ),
                  DropdownMenuItem(
                    value: "Volunteer",
                    child: Text(l10n.volunteer),
                  ),
                ],
                onChanged: (v) => setState(() => selectedRole = v),
                validator: (v) => v == null ? l10n.pleaseSelectRole : null,
              ),

              const SizedBox(height: 25),

              // ================= PARENT FIELDS =================
              if (selectedRole == "Parent") ...[
                TextFormField(
                  controller: dob,
                  readOnly: true,
                  onTap: pickDate,
                  decoration: const InputDecoration(
                    labelText: "Date of Birth",
                    suffixIcon: Icon(Icons.calendar_month),
                  ),
                  validator: (v) => v == null || v.isEmpty ? "Required" : null,
                ),
                const SizedBox(height: 15),

                TextFormField(
                  controller: phone,
                  decoration: InputDecoration(labelText: l10n.phoneNumber),
                  validator: (v) =>
                      v == null || v.isEmpty ? l10n.thisFieldRequired : null,
                ),
                const SizedBox(height: 15),

                TextFormField(
                  controller: address,
                  decoration: InputDecoration(labelText: l10n.address),
                  validator: (v) =>
                      v == null || v.isEmpty ? l10n.thisFieldRequired : null,
                ),
              ],

              // ================= SPECIALIST FIELDS =================
              if (selectedRole == "Specialist") ...[
                TextFormField(
                  controller: specialization,
                  decoration: InputDecoration(labelText: l10n.specialization),
                  validator: (v) =>
                      v == null || v.isEmpty ? l10n.thisFieldRequired : null,
                ),
                const SizedBox(height: 15),

                TextFormField(
                  controller: license,
                  decoration: InputDecoration(labelText: l10n.licenseNumber),
                  validator: (v) =>
                      v == null || v.isEmpty ? l10n.thisFieldRequired : null,
                ),
              ],

              // ================= VOLUNTEER FIELDS =================
              if (selectedRole == "Volunteer") ...[
                TextFormField(
                  controller: phone,
                  decoration: InputDecoration(labelText: l10n.phoneNumber),
                  validator: (v) =>
                      v == null || v.isEmpty ? l10n.thisFieldRequired : null,
                ),
                const SizedBox(height: 15),

                TextFormField(
                  controller: volunteerType,
                  decoration: InputDecoration(labelText: l10n.volunteerType),
                  validator: (v) =>
                      v == null || v.isEmpty ? l10n.thisFieldRequired : null,
                ),
              ],

              const SizedBox(height: 30),

              // ================= REGISTER BUTTON =================
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: loading ? null : registerUser,
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(l10n.createAccount),
                ),
              ),

              const SizedBox(height: 15),

              // ================= CENTER LOGIN BUTTON =================
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    );
                  },
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
    );
  }
}


