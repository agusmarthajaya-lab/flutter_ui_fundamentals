import 'dart:convert';
import '../models/course.dart';

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