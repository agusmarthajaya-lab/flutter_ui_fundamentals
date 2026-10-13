import 'package:flutter/material.dart';

// Identitas Wajib Sesuai Aturan Praktikum
const String studentName = 'I Putu Agus Martha Jaya';
const String studentId = '2415051097';

void main() {
  runApp(const CourseExplorerApp());
}

class CourseExplorerApp extends StatelessWidget {
  const CourseExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course Explorer v1 - Tahap 3',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CourseHomeScreen(),
    );
  }
}

// PARENT WIDGET: Memiliki Single Source of Truth untuk state
class CourseHomeScreen extends StatefulWidget {
  const CourseHomeScreen({super.key});

  @override
  State<CourseHomeScreen> createState() => _CourseHomeScreenState();
}

class _CourseHomeScreenState extends State<CourseHomeScreen> {
  // Single source of truth untuk status favorit pada course
  bool _isCourse1Favorite = false;
  bool _isCourse2Favorite = false;

  @override
  Widget build(BuildContext context) {
    int totalFavorites = (_isCourse1Favorite ? 1 : 0) + (_isCourse2Favorite ? 1 : 0);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Course Explorer - Tahap 3 (Total Fav: $totalFavorites)'),
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
            const Text(
              'Penerapan Lifting State Up & Single Source of Truth:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            // Mengirim data dan callback ke Child Widget 1
            CourseCardItem(
              title: 'Pemrograman Mobile Flutter',
              isFavorite: _isCourse1Favorite,
              onFavoriteChanged: () {
                setState(() {
                  _isCourse1Favorite = !_isCourse1Favorite;
                });
              },
            ),
            const SizedBox(height: 12),

            // Mengirim data dan callback ke Child Widget 2
            CourseCardItem(
              title: 'Arsitektur Perangkat Lunak',
              isFavorite: _isCourse2Favorite,
              onFavoriteChanged: () {
                setState(() {
                  _isCourse2Favorite = !_isCourse2Favorite;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

// CHILD WIDGET: Bersifat Stateless, menerima data dan memicu callback
class CourseCardItem extends StatelessWidget {
  final String title;
  final bool isFavorite;
  final VoidCallback onFavoriteChanged;

  const CourseCardItem({
    super.key,
    required this.title,
    required this.isFavorite,
    required this.onFavoriteChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ),
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
              ),
              onPressed: onFavoriteChanged, // Memicu callback ke parent
            ),
          ],
        ),
      ),
    );
  }
}