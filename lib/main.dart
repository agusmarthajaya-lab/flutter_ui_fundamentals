import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Identitas Wajib Sesuai Aturan Praktikum
const String studentName = 'I Putu Agus Martha Jaya';
const String studentId = '2415051097';

// ==========================================
// 1. CLASS MODEL COURSE
// ==========================================
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

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      code: json['code'] as String,
      title: json['title'] as String,
      credits: json['credits'] as int,
      status: json['status'] as String,
    );
  }
}

// ==========================================
// 2. CLASS COURSE SERVICE (Tahap 9)
// ==========================================
class CourseService {
  // Mensimulasikan pengambilan data dari sumber luar / asset JSON
  Future<List<Course>> loadCourses() async {
    // Simulasi data JSON string
    await Future.delayed(const Duration(milliseconds: 300)); // Simulasi network/io delay
    
    final String jsonString = '''
    {
      "courses": [
        {
          "code": "c1",
          "title": "Pemrograman Mobile Flutter",
          "credits": 3,
          "status": "Aktif"
        },
        {
          "code": "c2",
          "title": "Arsitektur Perangkat Lunak",
          "credits": 3,
          "status": "Aktif"
        }
      ]
    }
    ''';

    final data = jsonDecode(jsonString) as Map<String, dynamic>;
    final list = data['courses'] as List<dynamic>;

    return list
        .map((e) => Course.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

// ==========================================
// 3. COURSE PROVIDER MENGGUNAKAN SERVICE
// ==========================================
class CourseState extends ChangeNotifier {
  final CourseService _courseService = CourseService();
  List<Course> _courses = [];
  bool _isLoading = false;

  List<Course> get courses => _courses;
  bool get isLoading => _isLoading;

  final Set<String> _favorites = {};
  Set<String> get favorites => _favorites;

  // Memuat data menggunakan Service
  Future<void> fetchCourses() async {
    _isLoading = true;
    notifyListeners();

    try {
      _courses = await _courseService.loadCourses();
    } catch (e) {
      _courses = [];
    }

    _isLoading = false;
    notifyListeners();
  }

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
      create: (_) => CourseState()..fetchCourses(), // Memanggil data saat provider dibuat
      child: const CourseExplorerApp(),
    ),
  );
}

class CourseExplorerApp extends StatelessWidget {
  const CourseExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course Explorer v1 - Tahap 9',
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
        title: const Text('Course Explorer - Tahap 9 (Service / Data Source)'),
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
                  'Daftar Kursus (via CourseService):',
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
            
            // Menampilkan daftar course berdasarkan hasil fetch dari CourseService
            Expanded(
              child: Consumer<CourseState>(
                builder: (context, courseState, child) {
                  if (courseState.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final courseList = courseState.courses;
                  if (courseList.isEmpty) {
                    return const Center(child: Text('Tidak ada data kursus.'));
                  }
                  
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