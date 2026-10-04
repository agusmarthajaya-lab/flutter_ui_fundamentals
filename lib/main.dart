import 'package:flutter/material.dart';

const String studentName = 'I Putu Agus Martha Jaya';
const String studentId = '2415051097';

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

void main() {
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
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircleAvatar(
                          radius: 46,
                          backgroundImage: AssetImage(
                            'assets/images/profile.jpg',
                          ),
                        ),

                        const SizedBox(height: 12),

                        const Text(
                          studentName,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const Text(
                          studentId,
                          style: TextStyle(fontSize: 18),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          'Saya tertarik mempelajari pemrograman mobile untuk membuat aplikasi.',
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 12),

                        const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.phone_android),
                            SizedBox(width: 8),
                            Text('Mobile Programming Student'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(),
                  ),
                  child: const Column(
                    children: [
                      Text(
                        'Flutter UI Fundamentals',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 8),

                      Text(
                        'Belajar membuat tampilan Flutter dengan widget dasar.',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    buildStatCard(
                      '8',
                      'Widget',
                      Icons.widgets,
                    ),
                    buildStatCard(
                      '4',
                      'Layout',
                      Icons.view_quilt,
                    ),
                    buildStatCard(
                      '1',
                      'State',
                      Icons.sync,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Tahap 9
                const GreetingCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}