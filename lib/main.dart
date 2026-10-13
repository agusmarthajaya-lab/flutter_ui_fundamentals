import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Identitas Wajib Sesuai Aturan Praktikum
const String studentName = 'I Putu Agus Martha Jaya';
const String studentId = '2415051097';

// 1. CLASS COURSE PROVIDER (ChangeNotifier)
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
  runApp(
    // Membungkus aplikasi dengan ChangeNotifierProvider di root
    ChangeNotifierProvider(
      create: (_) => CourseState(),
      child: const CourseExplorerApp(),
    ),
  );
}

class CourseExplorerApp extends StatelessWidget {
  const CourseExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course Explorer v1 - Tahap 7',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CourseHomeScreen(),
    );
  }
}

class CourseHomeScreen extends StatelessWidget {
  const CourseHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Course Explorer - Tahap 7 (Watch, Read, Consumer)'),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Daftar Kursus (Watch & Read):',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                // Menggunakan Builder agar context.watch() mendapatkan BuildContext turunan yang valid
                Builder(
                  builder: (innerContext) {
                    final totalFav = innerContext.watch<CourseState>().favorites.length;
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
            
            // Course Card 1 menggunakan Consumer
            Consumer<CourseState>(
              builder: (context, courseState, child) {
                const courseId = 'c1';
                final isFav = courseState.isFavorite(courseId);
                return Card(
                  child: ListTile(
                    title: const Text('Pemrograman Mobile Flutter'),
                    subtitle: const Text('Menggunakan context.watch, read, dan Consumer'),
                    trailing: IconButton(
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        // Menggunakan context.read untuk memanggil aksi tanpa listen
                        context.read<CourseState>().toggleFavorite(courseId);
                      },
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),

            // Course Card 2 menggunakan Consumer
            Consumer<CourseState>(
              builder: (context, courseState, child) {
                const courseId = 'c2';
                final isFav = courseState.isFavorite(courseId);
                return Card(
                  child: ListTile(
                    title: const Text('Arsitektur Perangkat Lunak'),
                    subtitle: const Text('Optimasi rebuild dengan Consumer widget'),
                    trailing: IconButton(
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        context.read<CourseState>().toggleFavorite(courseId);
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