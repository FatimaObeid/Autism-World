import 'package:autism_world/specialist/ChatPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// Placeholder or Import for your actual ChatPage
// import 'package:your_app/pages/chat_page.dart';

class ClientDetailsPage extends StatefulWidget {
  final Map<String, dynamic> client;

  const ClientDetailsPage({super.key, required this.client});

  @override
  State<ClientDetailsPage> createState() => _ClientDetailsPageState();
}

class _ClientDetailsPageState extends State<ClientDetailsPage> {
  final String _baseUrl = 'http://127.0.0.1:8000/api/specialist';

  Map<String, dynamic>? _liveClientData;
  bool _isLoading = false;
  String? _errorMessage;

  // Specialist Editable Controllers
  late TextEditingController _diagnosisController;
  late TextEditingController _therapyTypeController;
  late TextEditingController _sessionFrequencyController;
  late TextEditingController _lastSessionController;
  late TextEditingController _nextPlanController;
  late TextEditingController _goalsController;
  late TextEditingController _recentProgressController;
  late TextEditingController _importantNotesController;

  // Edit states for Specialist fields
  bool _isEditingDiagnosis = false;
  bool _isEditingTherapy = false;
  bool _isEditingFrequency = false;
  bool _isEditingLastSession = false;
  bool _isEditingNextPlan = false;
  bool _isEditingGoals = false;
  bool _isEditingRecentProgress = false;
  bool _isEditingImportantNotes = false;

  @override
  void initState() {
    super.initState();
    _liveClientData = widget.client;
    _initControllers(_liveClientData!);
    _fetchClientDetails();
  }

  void _initControllers(Map<String, dynamic> data) {
    _diagnosisController = TextEditingController(
      text: data['diagnosis'] ?? _getDefaultDiagnosis(),
    );
    _therapyTypeController = TextEditingController(
      text:
          data['therapy_type'] ??
          data['therapyType'] ??
          _getDefaultTherapyType(),
    );
    _sessionFrequencyController = TextEditingController(
      text:
          data['session_frequency'] ??
          data['sessionFrequency'] ??
          _getDefaultFrequency(),
    );
    _lastSessionController = TextEditingController(
      text:
          data['last_session'] ??
          data['lastSession'] ??
          _getDefaultLastSession(),
    );
    _nextPlanController = TextEditingController(
      text: data['next_plan'] ?? data['nextPlan'] ?? _getDefaultNextPlan(),
    );
    _goalsController = TextEditingController(
      text: data['current_goals'] ?? data['goals'] ?? _getDefaultGoals(),
    );
    _recentProgressController = TextEditingController(
      text: data['recent_progress'] ?? _getDefaultRecentProgress(),
    );
    _importantNotesController = TextEditingController(
      text:
          data['important_notes'] ??
          data['importantNotes'] ??
          _getDefaultImportantNotes(),
    );
  }

  String _getDefaultDiagnosis() => "No diagnosis added yet.";
  String _getDefaultTherapyType() => "No therapy type selected yet.";
  String _getDefaultFrequency() => "Session frequency not specified.";
  String _getDefaultLastSession() => "No session notes recorded yet.";
  String _getDefaultNextPlan() => "No future plan set.";
  String _getDefaultGoals() => "No treatment goals added yet.";
  String _getDefaultRecentProgress() =>
      "No comprehensive progress reports added yet.";
  String _getDefaultImportantNotes() => "No important notes yet.";

  @override
  void dispose() {
    _diagnosisController.dispose();
    _therapyTypeController.dispose();
    _sessionFrequencyController.dispose();
    _lastSessionController.dispose();
    _nextPlanController.dispose();
    _goalsController.dispose();
    _recentProgressController.dispose();
    _importantNotesController.dispose();
    super.dispose();
  }

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // GET: Pull down live data
  Future<void> _fetchClientDetails() async {
    final childId = widget.client['id'] ?? widget.client['child_id'];
    if (childId == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse('$_baseUrl/clients/$childId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success'] == true || responseData['child'] != null) {
          setState(() {
            _liveClientData = responseData['child'] ?? responseData;
            _initControllers(_liveClientData!);
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Server error: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Connection error: $e';
        _isLoading = false;
      });
    }
  }

  // PUT: Persist live edits
  Future<void> _saveField(String field, String value) async {
    final childId = widget.client['id'] ?? widget.client['child_id'];
    setState(() => _isLoading = true);

    try {
      final token = await _getToken();
      final response = await http.put(
        Uri.parse('$_baseUrl/clients/$childId/notes'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({field: value}),
      );

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${field.replaceAll('_', ' ')} saved successfully'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 1),
            ),
          );
        }
      } else {
        throw Exception('Server error');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error saving updates to backend database.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          _liveClientData?['full_name'] ??
              _liveClientData?['childName'] ??
              'Client Details',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ),
        ],
      ),
      body: _errorMessage != null
          ? Center(
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUnifiedParentCard(),
                  const SizedBox(height: 20),

                  // RECENT PROGRESS SUMMARY
                  _buildEditableSection(
                    title: "Recent Progress Summary (Specialist Evaluation)",
                    icon: Icons.analytics_outlined,
                    child: _buildEditableTextArea(
                      controller: _recentProgressController,
                      isEditing: _isEditingRecentProgress,
                      onEditToggle: () {
                        setState(
                          () => _isEditingRecentProgress =
                              !_isEditingRecentProgress,
                        );
                        if (!_isEditingRecentProgress) {
                          _saveField(
                            'recent_progress',
                            _recentProgressController.text,
                          );
                        }
                      },
                      hintText:
                          "Enter comprehensive progress summary evaluations here...",
                      maxLines: 5,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Diagnosis Section
                  _buildEditableSection(
                    title: "Diagnosis & Treatment (Specialist)",
                    icon: Icons.medical_information,
                    child: Column(
                      children: [
                        _buildEditableRow(
                          label: "Diagnosis",
                          controller: _diagnosisController,
                          isEditing: _isEditingDiagnosis,
                          onEditToggle: () {
                            setState(
                              () => _isEditingDiagnosis = !_isEditingDiagnosis,
                            );
                            if (!_isEditingDiagnosis)
                              _saveField(
                                'diagnosis',
                                _diagnosisController.text,
                              );
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildEditableRow(
                          label: "Therapy Type",
                          controller: _therapyTypeController,
                          isEditing: _isEditingTherapy,
                          onEditToggle: () {
                            setState(
                              () => _isEditingTherapy = !_isEditingTherapy,
                            );
                            if (!_isEditingTherapy)
                              _saveField(
                                'therapy_type',
                                _therapyTypeController.text,
                              );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Last Session Section
                  _buildEditableSection(
                    title: "Last Session Notes",
                    icon: Icons.history,
                    child: _buildEditableTextArea(
                      controller: _lastSessionController,
                      isEditing: _isEditingLastSession,
                      onEditToggle: () {
                        setState(
                          () => _isEditingLastSession = !_isEditingLastSession,
                        );
                        if (!_isEditingLastSession)
                          _saveField(
                            'last_session',
                            _lastSessionController.text,
                          );
                      },
                      hintText:
                          "Describe what happened during the last session...",
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
    );
  }

  Widget _buildUnifiedParentCard() {
    final data = _liveClientData ?? widget.client;

    final moodLevel =
        int.tryParse(
          data['mood_level']?.toString() ??
              data['latest_daily_progress']?['mood_level']?.toString() ??
              '0',
        ) ??
        0;

    final bool sensoryPlay =
        data['sensory_play'] == true ||
        data['sensory_play'] == 1 ||
        data['latest_daily_progress']?['sensory_play'] == 1;

    final bool socialInteraction =
        data['social_interaction'] == true ||
        data['social_interaction'] == 1 ||
        data['latest_daily_progress']?['social_interaction'] == 1;

    final String parentNotes =
        data['daily_notes'] ??
        data['latest_daily_progress']?['notes'] ??
        "No explicit remarks shared by the parent.";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.family_restroom, size: 20, color: Colors.orange),
              const SizedBox(width: 8),
              const Text(
                "Parent Info",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              const Spacer(),
              // CHAT BUTTON TO TALK TO PARENT
              IconButton(
                icon: const Icon(Icons.chat_rounded, color: Colors.orange),
                tooltip: 'Chat with Parent',
                onPressed: () {
                  final parentId =
                      data['parent_profile_id'] ?? data['parent_id'];
                  // Clean fallback check to keep your UI context safe
                  if (parentId != null) {
                    print('Navigating to talk with Parent ID: $parentId');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                          parentId: parentId,
                          childName: data['full_name'] ?? 'Kid',
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Parent information profile missing.'),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "Verified Log",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            "Child Name: ${data['full_name'] ?? data['childName'] ?? 'N/A'}",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Autism Level: ${data['autism_level'] ?? data['autismLevel'] ?? 'Not specified'}",
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: Colors.orangeAccent, thickness: 0.5),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Daily Progress Logs",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              if (data['log_date'] != null ||
                  data['latest_daily_progress']?['date'] != null)
                Text(
                  (data['log_date'] ?? data['latest_daily_progress']?['date'])
                      .toString()
                      .split(' ')[0],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.orange.shade800,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            "Mood Level Tracker:",
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 4),
          Row(
            children: List.generate(5, (index) {
              return Icon(
                Icons.emoji_emotions,
                size: 24,
                color: index < moodLevel
                    ? Colors.amber.shade700
                    : Colors.orange.shade100,
              );
            }),
          ),
          const SizedBox(height: 12),
          const Text(
            "Tracked Performance Metrics:",
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _buildNestedActivityBadge("Sensory Play", sensoryPlay),
              _buildNestedActivityBadge(
                "Social Interaction",
                socialInteraction,
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            "Parent Observations:",
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.shade100),
            ),
            child: Text(
              parentNotes,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black87,
                fontStyle: FontStyle.italic,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNestedActivityBadge(String label, bool isCompleted) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isCompleted
            ? Colors.green.shade50
            : Colors.orange.shade100.withOpacity(0.4),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: isCompleted ? Colors.green.shade200 : Colors.orange.shade200,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isCompleted
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            size: 14,
            color: isCompleted ? Colors.green : Colors.orange.shade400,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: isCompleted
                  ? Colors.green.shade800
                  : Colors.orange.shade900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildEditableRow({
    required String label,
    required TextEditingController controller,
    required bool isEditing,
    required VoidCallback onEditToggle,
  }) {
    return Row(
      children: [
        Expanded(
          child: isEditing
              ? TextFormField(
                  controller: controller,
                  decoration: InputDecoration(labelText: label),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(controller.text),
                  ],
                ),
        ),
        IconButton(
          icon: Icon(
            isEditing ? Icons.check : Icons.edit,
            color: Colors.blue,
            size: 20,
          ),
          onPressed: onEditToggle,
        ),
      ],
    );
  }

  Widget _buildEditableTextArea({
    required TextEditingController controller,
    required bool isEditing,
    required VoidCallback onEditToggle,
    required String hintText,
    int maxLines = 4,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: Icon(
                isEditing ? Icons.check : Icons.edit,
                color: Colors.blue,
                size: 20,
              ),
              onPressed: onEditToggle,
            ),
          ],
        ),
        isEditing
            ? TextFormField(
                controller: controller,
                maxLines: maxLines,
                decoration: InputDecoration(
                  hintText: hintText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              )
            : Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  controller.text,
                  style: const TextStyle(height: 1.4),
                ),
              ),
      ],
    );
  }
}
