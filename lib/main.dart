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
      title: 'Course Explorer v1 - Tahap 4',
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
        title: const Text('Course Explorer - Tahap 4 (ValueNotifier)'),
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
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: CourseValueNotifierWidget(),
      ),
    );
  }
}

// Widget yang menerapkan ValueNotifier
class CourseValueNotifierWidget extends StatefulWidget {
  const CourseValueNotifierWidget({super.key});

  @override
  State<CourseValueNotifierWidget> createState() => _CourseValueNotifierWidgetState();
}

class _CourseValueNotifierWidgetState extends State<CourseValueNotifierWidget> {
  // 1. Membuat ValueNotifier untuk nilai sederhana (jumlah favorit)
  final ValueNotifier<int> _favoriteCountNotifier = ValueNotifier<int>(0);

  bool _isCourse1Fav = false;
  bool _isCourse2Fav = false;

  @override
  void dispose() {
    _favoriteCountNotifier.dispose(); // Wajib dispose notifier untuk mencegah memory leak
    super.dispose();
  }

  void _toggleCourse1() {
    _isCourse1Fav = !_isCourse1Fav;
    // Mengubah value notifier, otomatis memicu builder pada ValueListenableBuilder
    _favoriteCountNotifier.value = (_isCourse1Fav ? 1 : 0) + (_isCourse2Fav ? 1 : 0);
  }

  void _toggleCourse2() {
    _isCourse2Fav = !_isCourse2Fav;
    _favoriteCountNotifier.value = (_isCourse1Fav ? 1 : 0) + (_isCourse2Fav ? 1 : 0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Daftar Kursus (ValueNotifier):',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            // 2. Menampilkan nilai secara reaktif menggunakan ValueListenableBuilder
            ValueListenableBuilder<int>(
              valueListenable: _favoriteCountNotifier,
              builder: (context, value, child) {
                return Chip(
                  backgroundColor: Colors.blue.shade50,
                  label: Text(
                    'Total Favorit: $value',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            title: const Text('Pemrograman Mobile Flutter'),
            subtitle: const Text('Menggunakan ValueNotifier & ValueListenableBuilder'),
            trailing: IconButton(
              icon: Icon(
                _isCourse1Fav ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
              ),
              onPressed: _toggleCourse1,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: ListTile(
            title: const Text('Arsitektur Perangkat Lunak'),
            subtitle: const Text('Pemisahan reaktifitas state lokal'),
            trailing: IconButton(
              icon: Icon(
                _isCourse2Fav ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
              ),
              onPressed: _toggleCourse2,
            ),
          ),
        ),
      ],
    );
  }
}