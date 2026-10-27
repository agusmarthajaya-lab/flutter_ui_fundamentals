// Nama: I Putu Agus Martha Jaya
// NIM: 2415051097

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

// ==================== 1. MODEL ====================
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

  Course copyWith({int? id, String? code, String? title, int? credits, String? status}) {
    return Course(
      id: id ?? this.id,
      code: code ?? this.code,
      title: title ?? this.title,
      credits: credits ?? this.credits,
      status: status ?? this.status,
    );
  }
}

// ==================== 2. DATA SOURCE (Kontrak) ====================
abstract class CourseDataSource {
  Future<List<Course>> getCourses();
  Future<Course> createCourse(Course course);
  Future<void> updateCourse(int id, Course course);
  Future<void> deleteCourse(int id);
}

// ==================== 3. API SERVICE (Implementasi DataSource) ====================
class CourseApiService implements CourseDataSource {
  CourseApiService(this.baseUrl);
  final String baseUrl;

  @override
  Future<List<Course>> getCourses() async {
    final response = await http.get(Uri.parse('$baseUrl/courses'));
    if (response.statusCode != 200) throw Exception('Gagal mengambil course');
    final List data = jsonDecode(response.body) as List;
    return data.map((e) => Course.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<Course> createCourse(Course course) async {
    final response = await http.post(
      Uri.parse('$baseUrl/courses'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(course.toJson()),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Course.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }
    throw Exception('Gagal membuat course');
  }

  @override
  Future<void> updateCourse(int id, Course course) async {
    final response = await http.put(
      Uri.parse('$baseUrl/courses/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(course.toJson()),
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Gagal memperbarui course');
    }
  }

  @override
  Future<void> deleteCourse(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/courses/$id'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Gagal menghapus course');
    }
  }
}

// ==================== 4. REPOSITORY ====================
class CourseRepository {
  CourseRepository(this.dataSource);
  final CourseDataSource dataSource;

  Future<List<Course>> getCourses() => dataSource.getCourses();
  Future<Course> createCourse(Course course) => dataSource.createCourse(course);
  Future<void> updateCourse(int id, Course course) => dataSource.updateCourse(id, course);
  Future<void> deleteCourse(int id) => dataSource.deleteCourse(id);
}

// ==================== 5. PROVIDER ====================
class CourseProvider extends ChangeNotifier {
  CourseProvider(this.repository);
  final CourseRepository repository;

  bool _isLoading = false;
  String? _error;
  List<Course> _courses = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Course> get courses => _courses;

  Future<void> loadCourses() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulasi atau panggilan nyata ke repository
      await Future.delayed(const Duration(milliseconds: 500));
      // _courses = await repository.getCourses();
      
      // Data dummy fallback jika server belum aktif
      _courses = [
        const Course(id: 1, code: 'IF-101', title: 'Pemrograman Mobile', credits: 3, status: 'active'),
        const Course(id: 2, code: 'IF-102', title: 'Pemrograman Web', credits: 3, status: 'planned'),
      ];
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addCourse(Course course) async {
    try {
      // await repository.createCourse(course);
      _courses.add(course);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> editCourse(int id, Course course) async {
    try {
      // await repository.updateCourse(id, course);
      final index = _courses.indexWhere((c) => c.id == id);
      if (index != -1) {
        _courses[index] = course;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> removeCourse(int id) async {
    try {
      // await repository.deleteCourse(id);
      _courses.removeWhere((c) => c.id == id);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}

// ==================== 6. MAIN & UI ====================
void main() {
  const apiBaseUrl = 'https://api.example.com';
  final repository = CourseRepository(CourseApiService(apiBaseUrl));

  runApp(
    ChangeNotifierProvider(
      create: (_) => CourseProvider(repository)..loadCourses(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Praktikum Flutter Tahap 9',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CourseScreen(),
    );
  }
}

class CourseScreen extends StatelessWidget {
  const CourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Praktikum Tahap 9 - Repository Pattern'),
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
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.error != null
                    ? Center(child: Text('Error: ${provider.error}'))
                    : provider.courses.isEmpty
                        ? const Center(child: Text('Data course belum tersedia'))
                        : ListView.builder(
                            itemCount: provider.courses.length,
                            itemBuilder: (context, index) {
                              final course = provider.courses[index];
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
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => provider.removeCourse(course.id ?? 0),
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