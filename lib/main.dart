import 'package:flutter/material.dart';
import 'models/course.dart';
import 'services/course_api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Praktikum Flutter',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CourseScreen(),
    );
  }
}

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key});

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  // Inisialisasi service dengan base URL API Anda (atau gunakan data uji jika belum ada backend online)
  final CourseApiService apiService = CourseApiService('https://api.example.com');
  
  // Catatan: Jika Anda sedang menggunakan data statis/lokal untuk keperluan praktikum offline, 
  // pastikan struktur pemanggilan method mengarah ke service layer.
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Praktikum Tahap 4 - Service Layer'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Identitas Nama & NIM (Wajib terlihat untuk screenshot)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Colors.blue.shade50,
            child: const Column(
              children: [
                Text(
                  'Nama: I Putu Agus Martha Jaya',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 4),
                Text(
                  'NIM: 2415051097',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: Center(
              child: Text(
                'Logika HTTP berhasil dipindahkan ke CourseApiService',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}