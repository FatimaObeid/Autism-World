import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:autism_world/l10n/app_localizations.dart';

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  static const Color accentPurple = Color(0xFF9C27B0);

  List<dynamic> _allResources = [];
  List<dynamic> _filteredResources = [];
  bool _isLoading = true;
  String? _errorMessage;
  final TextEditingController _searchController = TextEditingController();

  /// Adjusts network hosts for emulator testing environments
  String get baseUrl {
    if (kIsWeb) return "http://127.0.0.1:8000";
    if (Platform.isAndroid) return "http://10.0.2.2:8000";
    return "http://127.0.0.1:8000";
  }

  @override
  void initState() {
    super.initState();
    _fetchResourcesFromBackend();
    _searchController.addListener(_filterResourcesLocally);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Fetches admin-populated items from ParentProfileController dynamically
  Future<void> _fetchResourcesFromBackend() async {
    try {
      // 1. Retrieve the parent's authenticated login token
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      // 2. Query the endpoint securely via ParentProfileController
      final response = await http.get(
        Uri.parse("$baseUrl/api/resources"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          setState(() {
            _allResources = responseData['data'] ?? [];
            _filteredResources = _allResources;
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage =
              "Server authentication error status code: ${response.statusCode}";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Network connection failed. Check backend: $e";
        _isLoading = false;
      });
    }
  }

  /// Runs local real-time queries across database text attributes
  void _filterResourcesLocally() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredResources = _allResources;
      } else {
        _filteredResources = _allResources.where((resource) {
          final title = (resource['title'] ?? '').toString().toLowerCase();
          final description = (resource['description'] ?? '')
              .toString()
              .toLowerCase();
          final type = (resource['type'] ?? '').toString().toLowerCase();
          return title.contains(query) ||
              description.contains(query) ||
              type.contains(query);
        }).toList();
      }
    });
  }

  /// Maps backend database resource enum fields directly to visual UI icons
  IconData _mapTypeToIcon(String? type) {
    switch (type) {
      case 'video':
        return Icons.play_circle_outline;
      case 'guide':
        return Icons.menu_book;
      case 'tool':
        return Icons.build_circle_outlined;
      case 'article':
      default:
        return Icons.description_outlined;
    }
  }

  /// Splitting utility logic supporting bilingual administration layouts ("EN | AR")
  String _getLocalText(String dbValue, bool isArabic) {
    if (dbValue.contains('|')) {
      final parts = dbValue.split('|');
      if (parts.length >= 2) {
        return isArabic ? parts[1].trim() : parts[0].trim();
      }
    }
    return dbValue;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.resourcesTitle),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.searchHint,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),
          Expanded(child: _buildMainContent(l10n, isArabic)),
        ],
      ),
    );
  }

  Widget _buildMainContent(AppLocalizations l10n, bool isArabic) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: accentPurple),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _errorMessage = null;
                  });
                  _fetchResourcesFromBackend();
                },
                style: ElevatedButton.styleFrom(backgroundColor: accentPurple),
                child: const Text(
                  "Retry Connection",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_filteredResources.isEmpty) {
      return const Center(
        child: Text("No records match your search parameters."),
      );
    }

    return ListView.builder(
      itemCount: _filteredResources.length,
      itemBuilder: (context, index) {
        final item = _filteredResources[index];

        final rawTitle = item['title'] ?? '';
        final rawDescription = item['description'] ?? '';
        final typeString = item['type'] ?? 'article';

        final title = _getLocalText(rawTitle, isArabic);
        final description = _getLocalText(rawDescription, isArabic);
        final icon = _mapTypeToIcon(typeString);

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: accentPurple.withOpacity(0.1),
              child: Icon(icon, color: accentPurple),
            ),
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              typeString.toString().toUpperCase(),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: accentPurple,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      description,
                      style: const TextStyle(
                        height: 1.4,
                        color: Colors.black87,
                      ),
                    ),
                    if (item['url'] != null &&
                        item['url'].toString().isNotEmpty) ...[
                      const SizedBox(height: 12),
                      TextButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "${l10n.readFullArticle}: ${item['url']}",
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.open_in_new,
                          size: 18,
                          color: accentPurple,
                        ),
                        label: Text(
                          l10n.readFullArticle,
                          style: const TextStyle(color: accentPurple),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

