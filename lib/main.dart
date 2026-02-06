import 'package:autism_world/screens/login.dart';
import 'package:autism_world/screens/specialist.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SpecialistPage(),
    );
  }
}
