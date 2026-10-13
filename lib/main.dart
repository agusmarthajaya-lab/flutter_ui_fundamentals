import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Identitas Wajib Sesuai Aturan Praktikum
const String studentName = 'I Putu Agus Martha Jaya';
const String studentId = '2415051097';

class Course {
  final String code;
  final String title;
  final int credits;
  final String status;

  Course({
    required this.code,
    required this.title,
    required this.credits,
    required this.status,
  });

  // Factory constructor untuk parsing data dari Map<String, dynamic> (JSON)
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      code: json['code'] as String,
      title: json['title'] as String,
      credits: json['credits'] as int,
      status: json['status'] as String,
    );
  }
}

// 2. COURSE PROVIDER DENGAN OBJECT MODEL
class CourseState extends ChangeNotifier {
  // Simulasi data mentah JSON dari API / Database
  final List<Map<String, dynamic>> _rawCourses = [
    {
      'code': 'c1',
      'title': 'Pemrograman Mobile Flutter',
      'credits': 3,
      'status': 'Aktif',
    },
    {
      'code': 'c2',
      'title': 'Arsitektur Perangkat Lunak',
      'credits': 3,
      'status': 'Aktif',
    },
  ];

  // Mengubah data JSON menjadi object Course menggunakan Course.fromJson()
  List<Course> get courses {
    return _rawCourses.map((json) => Course.fromJson(json)).toList();
  }

  final Set<String> _favorites = {};

  Set<String> get favorites => _favorites;

  bool isFavorite(String code) {
    return _favorites.contains(code);
  }

  void toggleFavorite(String code) {
    if (_favorites.contains(code)) {
      _favorites.remove(code);
    } else {
      _favorites.add(code);
    }
    notifyListeners();
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CourseState(),
      child: const CourseExplorerApp(),
    ),
  );
}

class CourseExplorerApp extends StatelessWidget {
  const CourseExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course Explorer v1 - Tahap 8',
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
        title: const Text('Course Explorer - Tahap 8 (Model Course)'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Daftar Kursus (Model & JSON Parsing):',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Builder(
                  builder: (innerContext) {
                    final totalFav = innerContext.watch<CourseState>().favorites.length;
                    return Chip(
                      backgroundColor: Colors.blue.shade50,
                      label: Text(
                        'Total Favorit: $totalFav',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Menampilkan daftar course secara dinamis menggunakan object model Course dari Provider
            Expanded(
              child: Consumer<CourseState>(
                builder: (context, courseState, child) {
                  final courseList = courseState.courses;
                  
                  return ListView.builder(
                    itemCount: courseList.length,
                    itemBuilder: (context, index) {
                      final Course course = courseList[index];
                      final isFav = courseState.isFavorite(course.code);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 8.0),
                        child: ListTile(
                          title: Text(course.title),
                          subtitle: Text('Kode: ${course.code} | SKS: ${course.credits} | Status: ${course.status}'),
                          trailing: IconButton(
                            icon: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              context.read<CourseState>().toggleFavorite(course.code);
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}