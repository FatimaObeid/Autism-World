import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:autism_world/l10n/app_localizations.dart';
import 'package:autism_world/screens/login.dart';
import 'package:autism_world/screens/parent.dart';
import 'package:autism_world/screens/specialist/specialist.dart';
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
  final String baseUrl = "http://127.0.0.1";

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
        Uri.parse("$baseUrl/api/register"),
        headers: {"Accept": "application/json"},
        body: {
          "name": name.text,
          "email": email.text,
          "password": password.text,
          "role": selectedRole!,
          "date_of_birth": dob.text,
          "phone": phone.text,
          "address": address.text,
          "specialization": specialization.text,
          "license_number": license.text,
          "volunteer_type": volunteerType.text,
        },
      );

      final data = jsonDecode(response.body);

      if (!mounted) return;

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(data["message"] ?? "Success")));

        if (selectedRole == "Parent") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const ParentPage()),
          );
        } else if (selectedRole == "Specialist") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const SpecialistPage()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const VolunteerDashboard(volunteerName: ""),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "Registration failed")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }

    setState(() => loading = false);
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

