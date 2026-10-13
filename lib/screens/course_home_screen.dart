import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';
import '../widgets/course_card.dart';
import 'course_detail_screen.dart';
import 'favorites_screen.dart';

// POINT 5: VARIABEL NAMA DAN NIM MAHASISWA (TERLIHAT DI KODE EDITOR)
const String studentName = 'I Putu Agus Martha Jaya';
const String studentId = '2415051097';

class CourseHomeScreen extends StatelessWidget {
  const CourseHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isWideScreen = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Course Explorer v2 - Integrasi',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.white),
            tooltip: 'Halaman Favorit',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritesScreen()),
              );
            },
          ),
          const SizedBox(width: 16),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(28.0),
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
            // POINT 5: NAMA DAN NIM MAHASISWA TAMPIL DI APPBAR BROWSER
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
                Text(
                  'Daftar Kursus (${isWideScreen ? "Desktop/Tablet View" : "Mobile View"}):',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (provider.error != null) {
                    return Center(
                      child: Text(
                        'Terjadi Kesalahan: ${provider.error}',
                        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    );
                  }

                  final courseList = provider.courses;
                  if (courseList.isEmpty) {
                    return const Center(child: Text('Tidak ada data kursus.'));
                  }
                  
                  if (isWideScreen) {
                    return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 3.2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: courseList.length,
                      itemBuilder: (context, index) {
                        final Course course = courseList[index];
                        final isFav = provider.isFavorite(course.code);

                        return CourseCard(
                          course: course,
                          isFavorite: isFav,
                          onFavoritePressed: () => provider.toggleFavorite(course.code),
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
                  }

                  return ListView.builder(
                    itemCount: courseList.length,
                    itemBuilder: (context, index) {
                      final Course course = courseList[index];
                      final isFav = provider.isFavorite(course.code);

                      return CourseCard(
                        course: course,
                        isFavorite: isFav,
                        onFavoritePressed: () => provider.toggleFavorite(course.code),
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
            ),
          ],
        ),
      ),
    );
  }
}