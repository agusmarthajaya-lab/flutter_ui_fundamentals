import 'package:flutter/material.dart';

// 1. Model Course (Sesuai Tahap 3)
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

class CourseScreen extends StatelessWidget {
  const CourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Simulasi data list course (minimal 3 course) sesuai instruksi Tahap 3
    final List<Map<String, dynamic>> rawData = [
      {
        'id': 1,
        'code': 'IF-101',
        'title': 'Pemrograman Mobile',
        'credits': 3,
        'status': 'active',
      },
      {
        'id': 2,
        'code': 'IF-102',
        'title': 'Pemrograman Web',
        'credits': 3,
        'status': 'planned',
      },
      {
        'id': 3,
        'code': 'IF-103',
        'title': 'Kecerdasan Buatan',
        'credits': 4,
        'status': 'completed',
      },
    ];

    // Konversi response list menjadi List<Course> (Poin 4 instruksi)
    List<Course> courseList = rawData.map((item) => Course.fromJson(item)).toList();

    return Scaffold(
      appBar: AppBar(
        // Judul disesuaikan untuk Tahap 3
        title: const Text('Praktikum Tahap 3 - Model Course'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Bagian Identitas Nama & NIM yang wajib terlihat di screenshot
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
          // List View untuk menampilkan minimal 3 course (Poin 5 instruksi)
          Expanded(
            child: ListView.builder(
              itemCount: courseList.length,
              itemBuilder: (context, index) {
                final course = courseList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 2,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      child: Text(course.code.substring(0, 2)),
                    ),
                    // Menampilkan title
                    title: Text(
                      course.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    // Menampilkan code dan status
                    subtitle: Text('Kode: ${course.code}  |  Status: ${course.status}'),
                    trailing: Text('${course.credits} SKS'),
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