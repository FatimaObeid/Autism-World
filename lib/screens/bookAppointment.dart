import 'package:flutter/material.dart';
import 'package:autism_world/l10n/app_localizations.dart';

class BookAppointment extends StatefulWidget {
  const BookAppointment({super.key});

  @override
  State<BookAppointment> createState() => _BookAppointmentState();
}

class _BookAppointmentState extends State<BookAppointment> {
  static const Color primaryBlue = Color(0xFF1E88E5);

  final _formKey = GlobalKey<FormState>();

  List<String> categories = [];
  String selectedCategory = "";

  final TextEditingController childNameController = TextEditingController();

  final TextEditingController parentNameController = TextEditingController();

  final TextEditingController ageController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  final TextEditingController notesController = TextEditingController();

  String selectedTherapy = "";
  String selectedSpecialist = "";

  final List<Map<String, String>> allSpecialists = [
    {
      "name": "Dr. Alice Smith",
      "specialty": "Speech Therapist",
      "rating": "4.9",
    },
    {"name": "Dr. Emily Brown", "specialty": "Psychologist", "rating": "4.8"},
    {
      "name": "Dr. Sam Wilson",
      "specialty": "Behavioral Specialist",
      "rating": "4.8",
    },
  ];

  List<Map<String, String>> get filteredSpecialists {
    if (categories.isEmpty) return [];

    if (selectedCategory == categories[0]) {
      return allSpecialists;
    }

    return allSpecialists
        .where((doc) => doc["specialty"] == selectedCategory)
        .toList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final l10n = AppLocalizations.of(context)!;

    categories = [
      l10n.categoryAll,
      l10n.categorySpeechTherapist,
      l10n.categoryPsychologist,
      l10n.categoryBehavioralSpecialist,
    ];

    selectedCategory = categories[0];
  }

  @override
  void dispose() {
    childNameController.dispose();
    parentNameController.dispose();
    ageController.dispose();
    phoneController.dispose();
    notesController.dispose();
    super.dispose();
  }

  void _submitForm(AppLocalizations l10n) {
    if (_formKey.currentState!.validate()) {
      if (selectedTherapy.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select therapy type")),
        );
        return;
      }

      if (selectedSpecialist.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select a specialist")),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: primaryBlue,
          content: Text("Appointment request submitted successfully!"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        title: Text(
          l10n.bookAppointmentTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),

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
              /// HEADER
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E88E5), Color(0xFF42A5F5)],
                  ),

                  borderRadius: BorderRadius.circular(20),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Icon(Icons.calendar_month, color: Colors.white, size: 40),

                    SizedBox(height: 12),

                    Text(
                      "Book a Therapy Appointment",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 6),

                    Text(
                      "Fill in the information below to request an appointment.",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              /// CHILD NAME
              _buildTextField(
                controller: childNameController,
                label: "Child Name",
                icon: Icons.child_care,
              ),

              const SizedBox(height: 18),

              /// PARENT NAME
              _buildTextField(
                controller: parentNameController,
                label: "Parent Name",
                icon: Icons.person,
              ),

              const SizedBox(height: 18),

              /// AGE
              _buildTextField(
                controller: ageController,
                label: "Child Age",
                icon: Icons.cake,
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 18),

              /// PHONE
              _buildTextField(
                controller: phoneController,
                label: "Phone Number",
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 25),

              /// THERAPY TYPE
              const Text(
                "Therapy Type",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),

              const SizedBox(height: 12),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _therapyChip("Speech Therapy"),
                  _therapyChip("Behavioral Therapy"),
                  _therapyChip("Occupational Therapy"),
                  _therapyChip("Psychological Therapy"),
                ],
              ),

              const SizedBox(height: 25),

              /// SPECIALISTS
              const Text(
                "Choose Specialist",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),

              const SizedBox(height: 15),

              Container(
                height: 60,
                padding: const EdgeInsets.symmetric(vertical: 10),

                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,

                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),

                      child: ChoiceChip(
                        label: Text(categories[index]),

                        selected: selectedCategory == categories[index],

                        onSelected: (selected) {
                          setState(() {
                            selectedCategory = categories[index];
                          });
                        },

                        selectedColor: primaryBlue.withOpacity(0.2),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 10),

              filteredSpecialists.isEmpty
                  ? Center(child: Text(l10n.noSpecialistsFound))
                  : Column(
                      children: filteredSpecialists.map((doc) {
                        return _specialistCard(
                          doc["name"]!,
                          doc["specialty"]!,
                          doc["rating"]!,
                        );
                      }).toList(),
                    ),

              const SizedBox(height: 25),

              /// NOTES
              TextFormField(
                controller: notesController,
                maxLines: 4,

                decoration: InputDecoration(
                  labelText: "Additional Notes",

                  hintText: "Describe your child's needs or concerns...",

                  prefixIcon: const Icon(Icons.notes),

                  filled: true,
                  fillColor: Colors.white,

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /// SUBMIT BUTTON
              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton(
                  onPressed: () => _submitForm(l10n),

                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,

                    foregroundColor: Colors.white,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),

                  child: const Text(
                    "Submit Appointment Request",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,

      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "This field is required";
        }
        return null;
      },

      decoration: InputDecoration(
        labelText: label,

        prefixIcon: Icon(icon),

        filled: true,
        fillColor: Colors.white,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _therapyChip(String therapy) {
    final bool isSelected = selectedTherapy == therapy;

    return ChoiceChip(
      label: Text(therapy),

      selected: isSelected,

      onSelected: (_) {
        setState(() {
          selectedTherapy = therapy;
        });
      },

      selectedColor: primaryBlue.withOpacity(0.2),
    );
  }

  Widget _specialistCard(String name, String specialty, String rating) {
    final bool isSelected = selectedSpecialist == name;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSpecialist = name;
        });
      },

      child: Container(
        margin: const EdgeInsets.only(bottom: 15),

        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(18),

          border: Border.all(
            color: isSelected ? primaryBlue : Colors.transparent,

            width: 2,
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: primaryBlue.withOpacity(0.1),

              child: Icon(Icons.person, color: primaryBlue),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    name,

                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(specialty, style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            ),

            Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 18),

                    const SizedBox(width: 3),

                    Text(rating),
                  ],
                ),

                const SizedBox(height: 8),

                if (isSelected)
                  const Icon(Icons.check_circle, color: Colors.green),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
