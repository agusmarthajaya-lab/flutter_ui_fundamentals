import 'package:flutter/material.dart';

// Identitas Wajib Sesuai Aturan Praktikum
const String studentName = 'I Putu Agus Martha Jaya';
const String studentId = '2415051097'; // Ganti dengan NIM Anda jika diperlukan

void main() {
  runApp(const CourseExplorerApp());
}

class CourseExplorerApp extends StatelessWidget {
  const CourseExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course Explorer v1',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CourseHomeScreen(),
    );
  }
}

class CourseHomeScreen extends StatelessWidget {
  const CourseHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue, 
        title: const Text('Course Explorer - Tahap 0'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(28.0),
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
            child: const Text(
              '$studentName - $studentId',
              style: TextStyle(
                color: Colors.white, 
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: const Center(
        child: Text(
          'Project siap untuk masuk ke tahap State Management!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}