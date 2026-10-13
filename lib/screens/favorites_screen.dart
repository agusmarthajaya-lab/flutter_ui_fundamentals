import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../widgets/course_card.dart';
import 'course_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kursus Favorit Saya'),
        backgroundColor: Colors.blue,
      ),
      body: Consumer<CourseProvider>(
        builder: (context, provider, child) {
          final favoriteCourses = provider.courses
              .where((course) => provider.isFavorite(course.code))
              .toList();

          if (favoriteCourses.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada kursus favorit.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: favoriteCourses.length,
            itemBuilder: (context, index) {
              final course = favoriteCourses[index];
              return CourseCard(
                course: course,
                isFavorite: true,
                onFavoritePressed: () {
                  provider.toggleFavorite(course.code);
                },
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CourseDetailScreen(course: course),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}