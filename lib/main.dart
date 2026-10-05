import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';

const String studentName = 'I Putu Agus Martha Jaya';
const String studentId = '2415051097';

Future<Map<String, dynamic>> loadStudentData() async {
  final jsonString = await rootBundle.loadString(
    'assets/data/student_data.json',
  );

  return jsonDecode(jsonString) as Map<String, dynamic>;
}

// Tahap 13: FutureBuilder
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Future disimpan di sini
  late Future<Map<String, dynamic>> studentFuture;

  // Future dijalankan satu kali
  @override
  void initState() {
    super.initState();
    studentFuture = loadStudentData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning Dashboard'),
      ),

      body: FutureBuilder<Map<String, dynamic>>(
        future: studentFuture,

        builder: (context, snapshot) {
          // 1. Saat data sedang dimuat
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // 2. Jika terjadi error
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Gagal memuat data: ${snapshot.error}',
              ),
            );
          }

          // 3. Jika data berhasil dimuat
          final data = snapshot.data!;

          // Mengambil data student
          final student =
              data['student'] as Map<String, dynamic>;

          // Mengambil data courses
          final courses = data['courses'] as List<dynamic>;

          return Column(
            children: [
              // Informasi mahasiswa
              ListTile(
                leading: const Icon(Icons.person),
                title: Text(
                  student['name'] as String,
                ),
                subtitle: Text(
                  student['nim'] as String,
                ),
              ),

              const Divider(),

              // Daftar mata kuliah
              Expanded(
                child: ListView.builder(
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final course =
                        courses[index] as Map<String, dynamic>;

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.book,
                        ),
                        title: Text(
                          course['title'] as String,
                        ),
                        subtitle: Text(
                          course['code'] as String,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DashboardPage(),
    ),
  );
}