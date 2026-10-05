import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';

Future<Map<String, dynamic>> loadStudentData() async {
  final jsonString = await rootBundle.loadString(
    'assets/data/student_data.json',
  );

  return jsonDecode(jsonString) as Map<String, dynamic>;
}

// Reusable Widget 1: Summary Card
Widget buildSummaryCard(
  String value,
  String label,
  IconData icon,
) {
  return Expanded(
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              icon,
              size: 30,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(label),
          ],
        ),
      ),
    ),
  );
}

// Reusable Widget 2: Course Card
Widget buildCourseCard(Map<String, dynamic> course) {
  final String status = course['status'] as String;

  IconData statusIcon;
  String statusText;

  if (status == 'done') {
    statusIcon = Icons.check_circle;
    statusText = 'Selesai';
  } else if (status == 'active') {
    statusIcon = Icons.play_circle;
    statusText = 'Aktif';
  } else {
    statusIcon = Icons.schedule;
    statusText = 'Direncanakan';
  }

  return Card(
    margin: const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 6,
    ),
    child: ListTile(
      leading: Icon(
        statusIcon,
        size: 32,
      ),
      title: Text(
        course['title'] as String,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        '${course['code']} • ${course['credits']} SKS',
      ),
      trailing: Text(
        statusText,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

// Tahap 14: Mini Project Learning Dashboard
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<Map<String, dynamic>> studentFuture;

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
          // Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Error
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Gagal memuat data: ${snapshot.error}',
              ),
            );
          }

          // Data berhasil
          final data = snapshot.data!;

          final student =
              data['student'] as Map<String, dynamic>;

          final courses =
              data['courses'] as List<dynamic>;

          // Menghitung jumlah mata kuliah
          final int totalCourses = courses.length;

          // Menghitung total SKS
          final int totalCredits = courses.fold(
            0,
            (sum, item) =>
                sum + (item['credits'] as int),
          );

          return ListView(
            padding: const EdgeInsets.only(
              top: 12,
              bottom: 20,
            ),
            children: [
              // =========================
              // PROFILE
              // =========================
              Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage(
                          'assets/images/profile.jpg',
                        ),
                      ),

                      const SizedBox(width: 16),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              student['name'] as String,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              student['nim'] as String,
                            ),

                            const SizedBox(height: 4),

                            Text(
                              student['program'] as String,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // =========================
              // SUMMARY
              // =========================
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                child: Row(
                  children: [
                    buildSummaryCard(
                      '$totalCourses',
                      'Mata Kuliah',
                      Icons.menu_book,
                    ),

                    const SizedBox(width: 8),

                    buildSummaryCard(
                      '$totalCredits',
                      'Total SKS',
                      Icons.school,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // =========================
              // JUDUL COURSE
              // =========================
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                child: Text(
                  'Daftar Mata Kuliah',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // =========================
              // LIST COURSE
              // =========================
              ...courses.map(
                (course) => buildCourseCard(
                  course as Map<String, dynamic>,
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