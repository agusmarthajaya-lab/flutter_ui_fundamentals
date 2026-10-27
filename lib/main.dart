// Nama: I Putu Agus Martha Jaya
// NIM: 2415051097

import 'package:flutter/material.dart';

// Model Course
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
      title: 'Praktikum Flutter Tahap 6',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CourseScreen(),
    );
  }
}

// Halaman Utama Menampilkan List Course
class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key});

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  bool isLoading = false;
  List<Course> courses = [
    const Course(code: 'IF-101', title: 'Pemrograman Mobile', credits: 3, status: 'active'),
    const Course(code: 'IF-102', title: 'Pemrograman Web', credits: 3, status: 'planned'),
    const Course(code: 'IF-103', title: 'Kecerdasan Buatan', credits: 4, status: 'completed'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Praktikum Tahap 6 - HTTP POST'),
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
          Expanded(
            child: ListView.builder(
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
                    subtitle: Text('Kode: ${course.code} | Status: ${course.status}'),
                    trailing: Text('${course.credits} SKS'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // Tombol untuk membuka Form Tambah Course
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddCourseScreen()),
          );

          // Jika berhasil disimpan, refresh list
          if (result == true) {
            setState(() {
              // Simulasi menambah course baru ke list lokal
              courses.add(
                const Course(code: 'IF-104', title: 'Pemrograman Berorientasi Objek', credits: 3, status: 'active'),
              );
            });
          }
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

// Halaman Form Tambah Course (Tahap 6)
class AddCourseScreen extends StatefulWidget {
  const AddCourseScreen({super.key});

  @override
  State<AddCourseScreen> createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _titleController = TextEditingController();
  final _creditsController = TextEditingController();
  String _selectedStatus = 'planned';
  bool isSaving = false;

  @override
  void dispose() {
    _codeController.dispose();
    _titleController.dispose();
    _creditsController.dispose();
    super.dispose();
  }

  Future<void> _submitData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isSaving = true;
    });

    try {
      // Simulasi proses request POST ke server
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      // Tampilkan SnackBar sukses
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Course berhasil ditambahkan!')),
      );

      Navigator.pop(context, true); // Kembali ke halaman utama
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Course Baru (Tahap 6)'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                color: Colors.blue.shade50,
                child: const Column(
                  children: [
                    Text('Nama: I Putu Agus Martha Jaya', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('NIM: 2415051097', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(labelText: 'Kode Course (mis: IF-104)', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty ? 'Kode wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Judul Mata Kuliah', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty ? 'Judul wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _creditsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Jumlah SKS (Credits)', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Credits wajib diisi';
                  if (int.tryParse(value) == null) return 'Credits harus berupa angka';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: const InputDecoration(labelText: 'Status', border: OutlineInputBorder()),
                items: const [
                  DropdownMenuItem(value: 'planned', child: Text('Planned')),
                  DropdownMenuItem(value: 'active', child: Text('Active')),
                  DropdownMenuItem(value: 'completed', child: Text('Completed')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value!;
                  });
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: isSaving ? null : _submitData,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                child: isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Simpan Course'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}