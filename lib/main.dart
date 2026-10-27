// Nama: I Putu Agus Martha Jaya
// NIM: 2415051097

import 'package:flutter/material.dart';

// Model Course (dari Tahap 3)
class Course {
  final int? id;
  final String code;
  final String title;
  final int credits;
  final String status;

  const Course({
    this.id,
    required this.code,
    required this.title,
    required this.credits,
    this.status = 'planned',
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as int?,
      code: json['code'] as String,
      title: json['title'] as String,
      credits: json['credits'] as int,
      status: (json['status'] as String?) ?? 'planned',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'title': title,
        'credits': credits,
        'status': status,
      };
}

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
  bool isLoading = false;
  String? error;
  List<Course> courses = [];

  @override
  void initState() {
    super.initState();
    loadCourses(); // Dipanggil saat initState, bukan di build()
  }

  // Fungsi simulasi memuat data (bisa diubah untuk testing Loading, Success, Empty, atau Error)
  Future<void> loadCourses() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      // Simulasi jeda jaringan
      await Future.delayed(const Duration(seconds: 1));
      
      // Berhasil (Success State) - Berisi data minimal 3 course
      courses = [
        const Course(code: 'IF-101', title: 'Pemrograman Mobile', credits: 3, status: 'active'),
        const Course(code: 'IF-102', title: 'Pemrograman Web', credits: 3, status: 'planned'),
        const Course(code: 'IF-103', title: 'Kecerdasan Buatan', credits: 4, status: 'completed'),
      ];

      // CATATAN PENGUJIAN TAHAP 5:
      // 1. Untuk menguji Empty State, ubah courses menjadi: courses = [];
      // 2. Untuk menguji Error State, aktifkan baris throw di bawah ini:
      // throw Exception('Gagal terhubung ke server backend');

    } catch (e) {
      error = e.toString();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Praktikum Tahap 5 - State Management'),
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
          // Penanganan State (Loading, Error, Empty, Success)
          Expanded(
            child: _buildBodyContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyContent() {
    // 1. Loading State
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // 2. Error State
    if (error != null) {
      return ErrorView(
        message: error!,
        onRetry: loadCourses,
      );
    }

    // 3. Empty State
    if (courses.isEmpty) {
      return const Center(
        child: Text(
          'Data course belum tersedia',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    // 4. Success State (Tampilkan list data)
    return ListView.builder(
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 2,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              child: Text(course.code.substring(0, 2)),
            ),
            title: Text(course.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Kode: ${course.code} | Status: ${course.status}'),
            trailing: Text('${course.credits} SKS'),
          ),
        );
      },
    );
  }
}

// Widget ErrorView sesuai permintaan Tahap 5
class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),
            const SizedBox(height: 12),
            Text(
              'Terjadi Kesalahan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red.shade700),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}