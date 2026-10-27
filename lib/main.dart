// Nama: I Putu Agus Martha Jaya
// NIM: 2415051097

import 'package:flutter/material.dart';

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
      title: 'Praktikum Flutter Tahap 8',
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
  List<Course> courses = [
    const Course(id: 1, code: 'IF-101', title: 'Pemrograman Mobile', credits: 3, status: 'active'),
    const Course(id: 2, code: 'IF-102', title: 'Pemrograman Web', credits: 3, status: 'planned'),
    const Course(id: 3, code: 'IF-103', title: 'Kecerdasan Buatan', credits: 4, status: 'completed'),
  ];

  // Fungsi untuk menghapus course dengan konfirmasi Dialog
  Future<void> _confirmAndDelete(Course course) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus course "${course.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (shouldDelete != true) return;

    try {
      // Simulasi request DELETE ke API
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      setState(() {
        courses.removeWhere((item) => item.id == course.id);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Course "${course.title}" berhasil dihapus!')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus course: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Praktikum Tahap 8 - HTTP DELETE'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
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
            child: courses.isEmpty
                ? const Center(
                    child: Text(
                      'Data course belum tersedia',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course = courses[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            child: Text(course.code.substring(0, 2)),
                          ),
                          title: Text(course.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('Kode: ${course.code} | Status: ${course.status} (${course.credits} SKS)'),
                          // Tombol Delete / Hapus
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _confirmAndDelete(course),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}