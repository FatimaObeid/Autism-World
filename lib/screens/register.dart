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
    // 1. Initialize your localizations here
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  width: 70,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
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
                              volunteerName: 'john doe', // Mock data
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

