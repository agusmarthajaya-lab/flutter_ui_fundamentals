import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';

const String studentName = 'I Putu Agus Martha Jaya';
const String studentId = '2415051097';

Future<Map<String, dynamic>> loadStudentData() async {
  final jsonString = await rootBundle.loadString(
    'assets/data/student_data.json',
  );

  return jsonDecode(jsonString) as Map<String, dynamic>;
}

final List<Map<String, dynamic>> topics = [
  {
    'title': 'Git & GitHub',
    'subtitle': 'Version control',
    'done': true,
  },
  {
    'title': 'Dart Fundamentals',
    'subtitle': 'Language basics',
    'done': true,
  },
  {
    'title': 'Flutter UI Fundamentals',
    'subtitle': 'Widgets & layout',
    'done': false,
  },
  {
    'title': '$studentId - $studentName',
    'subtitle': 'Pemilik aplikasi',
    'done': false,
  },
];

final int completed =
    topics.where((item) => item['done'] == true).length;

Widget buildStatCard(String value, String label, IconData icon) {
  return Expanded(
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(label),
          ],
        ),
      ),
    ),
  );
}

// Tahap 9: StatefulWidget
class GreetingCard extends StatefulWidget {
  const GreetingCard({super.key});

  @override
  State<GreetingCard> createState() => _GreetingCardState();
}

class _GreetingCardState extends State<GreetingCard> {
  // Controller untuk menerima input dari TextField
  final TextEditingController controller = TextEditingController();

  // State yang akan berubah
  String message = 'Belum ada pesan';

  // Membersihkan controller ketika widget selesai digunakan
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Tahap 9 - Input & State',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              '$studentId - $studentName',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Masukkan pesan',
                hintText: 'Contoh: Saya sedang belajar Flutter',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  message = controller.text.trim().isEmpty
                      ? 'Input masih kosong'
                      : controller.text.trim();
                });
              },
              child: const Text('Tampilkan'),
            ),

            const SizedBox(height: 12),

            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final data = await loadStudentData();

  debugPrint('DATA JSON: $data');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter UI Fundamentals'),
        ),
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  Text(
                    'Tahap 11 - List Informatif',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '$studentId - $studentName',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            Text(
              '$completed dari ${topics.length} topik selesai',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Expanded(
              child: ListView.builder(
                itemCount: topics.length,
                itemBuilder: (context, index) {
                  final item = topics[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: ListTile(
                      leading: Icon(
                        item['done'] == true
                            ? Icons.check_circle
                            : Icons.schedule,
                      ),
                      title: Text(
                        item['title'] as String,
                      ),
                      subtitle: Text(
                        item['subtitle'] as String,
                      ),
                      trailing: Text(
                        item['done'] == true
                            ? 'Selesai'
                            : 'Belum',
                      ),
                    ),
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