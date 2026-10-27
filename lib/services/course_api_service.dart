// Nama: I Putu Agus Martha Jaya
// NIM: 2415051097

import 'dart:convert';
import 'package:http/http.dart' as http;

class CourseApiService {
  CourseApiService(this.baseUrl);

  final String baseUrl;

  // Fungsi DELETE course berdasarkan ID
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