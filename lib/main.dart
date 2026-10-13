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
      title: 'Course Explorer v1 - Tahap 2',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CourseHomeScreen(),
    );
  }
}

// PARENT WIDGET: Menyimpan Shared State (favorites count / status)
class CourseHomeScreen extends StatefulWidget {
  const CourseHomeScreen({super.key});

  @override
  State<CourseHomeScreen> createState() => _CourseHomeScreenState();
}

class _CourseHomeScreenState extends State<CourseHomeScreen> {
  // Shared state yang akan di-drill ke child widgets
  bool _isCourse1Favorite = false;
  bool _isCourse2Favorite = false;

  @override
  Widget build(BuildContext context) {
    int totalFavorites = (_isCourse1Favorite ? 1 : 0) + (_isCourse2Favorite ? 1 : 0);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Course Explorer - Tahap 2 (Fav: $totalFavorites)'),
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
              'Simulasi Prop Drilling dengan setState():',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            
            // CHILD WIDGET 1: Menerima prop dan callback
            CourseCard(
              courseTitle: 'Pemrograman Mobile Flutter',
              isFavorite: _isCourse1Favorite,
              onFavoriteChanged: (val) {
                setState(() {
                  _isCourse1Favorite = val;
                });
              },
            ),
            const SizedBox(height: 12),

            // CHILD WIDGET 2: Menerima prop dan callback
            CourseCard(
              courseTitle: 'Arsitektur Perangkat Lunak',
              isFavorite: _isCourse2Favorite,
              onFavoriteChanged: (val) {
                setState(() {
                  _isCourse2Favorite = val;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

// CHILD WIDGET (harus menerima data lewat constructor / prop drilling)
class CourseCard extends StatelessWidget {
  final String courseTitle;
  final bool isFavorite;
  final ValueChanged<bool> onFavoriteChanged;

  const CourseCard({
    super.key,
    required this.courseTitle,
    required this.isFavorite,
    required this.onFavoriteChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                courseTitle,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
              ),
              onPressed: () {
                // Memanggil callback ke parent untuk mengubah state
                onFavoriteChanged(!isFavorite);
              },
            ),
          ],
        ),
      ),
    );
  }
}