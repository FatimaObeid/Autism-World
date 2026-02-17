import 'package:autism_world/screens/login.dart';
import 'package:autism_world/screens/parent.dart';
import 'package:autism_world/screens/specialist.dart';
import 'package:autism_world/screens/volunteer.dart';
import 'package:flutter/material.dart';

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  'Join Our Community',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                Text(
                  'Create your account to get started',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),

                const SizedBox(height: 30),

                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Full Name",
                    hintText: 'Enter Your Full Name',
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
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 30),

                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: "john@gmail.com",
                    labelText: "Email",
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
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 30),

                TextFormField(
                  controller: passwordController,
                  obscureText: _isPasswordHidden,
                  decoration: InputDecoration(
                    hintText: "Enter a password",
                    labelText: "Password",
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
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),

                if (selectedRole == 'Parent') ...[
                  SizedBox(height: 30),
                  TextFormField(
                    controller: dateOfBirthController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Date of Birth",
                      hintText: 'Enter your date of birth',
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
                        return 'This field is required';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 30),

                  TextFormField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      labelText: "Phone Number",
                      hintText: 'Enter your phone number',
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
                        return 'This field is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: addressController,
                    decoration: InputDecoration(
                      labelText: "Address",
                      hintText: 'Enter your address',
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
                        return 'This field is required';
                      }
                      return null;
                    },
                  ),
                ],

                if (selectedRole == 'Specialist') ...[
                  SizedBox(height: 30),
                  TextFormField(
                    controller: specializationController,
                    decoration: InputDecoration(
                      labelText: 'Specialization',
                      hintText: 'Enter Your Specialization',
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
                        return 'This field is required';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 30),

                  TextFormField(
                    controller: licenseController,
                    decoration: InputDecoration(
                      labelText: 'License Number',
                      hintText: 'Enter Your License Number',
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
                        return 'This field is required';
                      }
                      return null;
                    },
                  ),
                ],

                if (selectedRole == 'Volunteer') ...[
                  SizedBox(height: 30),
                  TextFormField(
                    controller: phoneController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Phone Number",
                      hintText: 'Enter your phone number',
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

                  SizedBox(height: 30),

                  TextFormField(
                    controller: typeController,
                    decoration: InputDecoration(
                      labelText: "Volunteer Type",
                      hintText: 'Enter your volunteer type',
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
                      if (selectedRole == 'Parent' &&
                          (value == null || value.isEmpty)) {
                        return 'This field is required';
                      }
                      return null;
                    },
                  ),
                ],
                const SizedBox(height: 30),
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  hint: const Text('Select your role'),
                  items: const [
                    DropdownMenuItem(value: 'Parent', child: Text('Parent')),
                    DropdownMenuItem(
                      value: 'Specialist',
                      child: Text('Specialist'),
                    ),
                    DropdownMenuItem(
                      value: 'Volunteer',
                      child: Text('Volunteer'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedRole = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a role';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'I am a...',
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
                          const SnackBar(
                            content: Text(
                              "Parent account created successfully!",
                            ),
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
                          const SnackBar(
                            content: Text(
                              "Specialist account created successfully!",
                            ),
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
                          const SnackBar(
                            content: Text(
                              "Volunteer account created successfully!",
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const VolunteerPage(),
                          ),
                        );
                      }
                    },
                    child: Text('Create Account'),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(color: Colors.grey),
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
                        'Login',
                        style: TextStyle(
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

