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
// 2. CLASS COURSE SERVICE
// ==========================================
class CourseService {
  Future<List<Course>> loadCourses() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
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
// 3. CLASS COURSE REPOSITORY
// ==========================================
class CourseRepository {
  final CourseService service;

  CourseRepository(this.service);

  Future<List<Course>> getCourses() {
    return service.loadCourses();
  }
}

// ==========================================
// 4. CLASS COURSE PROVIDER (Tahap 11 - Async State)
// ==========================================
class CourseProvider extends ChangeNotifier {
  final CourseRepository repository;

  CourseProvider(this.repository);

  List<Course> courses = [];
  bool isLoading = false;
  String? error;

  final Set<String> _favorites = {};
  Set<String> get favorites => _favorites;

  Future<void> loadCourses() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      courses = await repository.getCourses();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
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
    MultiProvider(
      providers: [
        Provider<CourseService>(create: (_) => CourseService()),
        ProxyProvider<CourseService, CourseRepository>(
          update: (_, service, __) => CourseRepository(service),
        ),
        ChangeNotifierProxyProvider<CourseRepository, CourseProvider>(
          create: (context) => CourseProvider(context.read<CourseRepository>())..loadCourses(),
          update: (_, repository, previousProvider) => 
              previousProvider ?? CourseProvider(repository),
        ),
      ],
      child: const CourseExplorerApp(),
    ),
  );
}

class CourseExplorerApp extends StatelessWidget {
  const CourseExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course Explorer v1 - Tahap 11',
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
        title: const Text('Course Explorer - Tahap 11 (Async State)'),
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
                  'Daftar Kursus (Async State Handling):',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Builder(
                  builder: (innerContext) {
                    final totalFav = innerContext.watch<CourseProvider>().favorites.length;
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
            
            Expanded(
              child: Consumer<CourseProvider>(
                builder: (context, provider, child) {
                  // 1. Kondisi Loading
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // 2. Kondisi Error
                  if (provider.error != null) {
                    return Center(
                      child: Text(
                        'Terjadi Kesalahan: ${provider.error}',
                        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    );
                  }

                  final courseList = provider.courses;
                  
                  // 3. Kondisi Kosong
                  if (courseList.isEmpty) {
                    return const Center(child: Text('Tidak ada data kursus.'));
                  }
                  
                  // 4. Kondisi Sukses Menampilkan List
                  return ListView.builder(
                    itemCount: courseList.length,
                    itemBuilder: (context, index) {
                      final Course course = courseList[index];
                      final isFav = provider.isFavorite(course.code);

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
                              provider.toggleFavorite(course.code);
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