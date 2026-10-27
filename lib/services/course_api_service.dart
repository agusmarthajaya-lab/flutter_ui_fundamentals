// Nama: I Putu Agus Martha Jaya
// NIM: 2415051097

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/course.dart'; // Sesuaikan jalur import model course Anda jika berbeda

class CourseApiService {
  CourseApiService(this.baseUrl);

  final String baseUrl;

  Future<List<Course>> getCourses() async {
    final response = await http.get(Uri.parse('$baseUrl/courses'));

    if (response.statusCode != 200) {
      throw Exception('Gagal mengambil course');
    }

    final List data = jsonDecode(response.body) as List;
    return data
        .map((e) => Course.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}