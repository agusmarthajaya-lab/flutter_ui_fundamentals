// Nama: I Putu Agus Martha Jaya
// NIM: 2415051097

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ==================== 1. MODEL COURSE ====================
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
    required this.credits,_
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

// ==================== 2. MAIN & INISIALISASI SUPABASE ====================
Future<void> main() async {
  // Wajib dipanggil sebelum inisialisasi asynchronous
  WidgetsFlutterBinding.ensureInitialized();

  // Konfigurasi Supabase (Gunakan Project URL dan anon/public key Anda)
  // Catatan: Jangan pernah gunakan service_role key di sisi client!
  const supabaseUrl = 'https://YOUR_SUPABASE_PROJECT_URL.supabase.co';
  const supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY_HERE';

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  runApp(const MyApp());
}

// ==================== 3. APLIKASI UTAMA ====================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Praktikum Tahap 10 - Supabase',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CourseScreen(),
    );
  }
}

// ==================== 4. HALAMAN UI ====================
class CourseScreen extends StatelessWidget {
  const CourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Praktikum Tahap 10 - Supabase Client'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Identitas Nama & NIM
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
          const Expanded(
            child: Center(
              child: Text(
                'Supabase Client Berhasil Diinisialisasi!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}