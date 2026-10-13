import 'package:flutter/material.dart';

// Identitas Wajib Sesuai Aturan Praktikum
const String studentName = 'I Putu Agus Martha Jaya';
const String studentId = '2415051097';

// 1. CLASS CHANGENOTIFIER (Digabung dalam satu file agar bebas dari error import)
class CourseState extends ChangeNotifier {
  final Set<String> _favorites = {};

  Set<String> get favorites => _favorites;

  bool isFavorite(String id) {
    return _favorites.contains(id);
  }

  void toggleFavorite(String id) {
    if (_favorites.contains(id)) {
      _favorites.remove(id);
    } else {
      _favorites.add(id);
    }
    notifyListeners();
  }
}

void main() {
  runApp(const CourseExplorerApp());
}

class CourseExplorerApp extends StatelessWidget {
  const CourseExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course Explorer v1 - Tahap 5',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CourseHomeScreen(),
    );
  }
}

class CourseHomeScreen extends StatefulWidget {
  const CourseHomeScreen({super.key});

  @override
  State<CourseHomeScreen> createState() => _CourseHomeScreenState();
}

class _CourseHomeScreenState extends State<CourseHomeScreen> {
  // Inisialisasi object ChangeNotifier
  final CourseState _courseState = CourseState();

  @override
  void dispose() {
    _courseState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Course Explorer - Tahap 5 (ChangeNotifier)'),
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
            // Menampilkan informasi jumlah favorit secara reaktif dari ChangeNotifier
            AnimatedBuilder(
              animation: _courseState,
              builder: (context, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Daftar Kursus (ChangeNotifier):',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Chip(
                      backgroundColor: Colors.blue.shade50,
                      label: Text(
                        'Total Favorit: ${_courseState.favorites.length}',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            
            // Course Card 1
            AnimatedBuilder(
              animation: _courseState,
              builder: (context, child) {
                const courseId = 'c1';
                final isFav = _courseState.isFavorite(courseId);
                return Card(
                  child: ListTile(
                    title: const Text('Pemrograman Mobile Flutter'),
                    subtitle: const Text('Menggunakan ChangeNotifier & notifyListeners()'),
                    trailing: IconButton(
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        _courseState.toggleFavorite(courseId);
                      },
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),

            // Course Card 2
            AnimatedBuilder(
              animation: _courseState,
              builder: (context, child) {
                const courseId = 'c2';
                final isFav = _courseState.isFavorite(courseId);
                return Card(
                  child: ListTile(
                    title: const Text('Arsitektur Perangkat Lunak'),
                    subtitle: const Text('Pemisahan logika state dari UI'),
                    trailing: IconButton(
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        _courseState.toggleFavorite(courseId);
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}