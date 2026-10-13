import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';

class CourseDetailScreen extends StatelessWidget {
  final Course course;

  const CourseDetailScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course.title),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              course.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text('Kode Kursus: ${course.code}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Jumlah SKS: ${course.credits}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Status: ${course.status}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            
            Consumer<CourseProvider>(
              builder: (context, provider, child) {
                final isFav = provider.isFavorite(course.code);
                return ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isFav ? Colors.red.shade50 : Colors.blue.shade50,
                    foregroundColor: isFav ? Colors.red : Colors.blue,
                  ),
                  onPressed: () {
                    provider.toggleFavorite(course.code);
                  },
                  icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
                  label: Text(isFav ? 'Hapus dari Favorit' : 'Tambah ke Favorit'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}