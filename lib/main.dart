import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// 1. Buat konstanta apiUrl sesuai endpoint latihan
const String apiUrl = 'https://jsonplaceholder.typicode.com/posts';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Tahap2Screen(),
    );
  }
}

class Tahap2Screen extends StatefulWidget {
  const Tahap2Screen({super.key});

  @override
  State<Tahap2Screen> createState() => _Tahap2ScreenState();
}

class _Tahap2ScreenState extends State<Tahap2Screen> {
  // Identitas Mahasiswa
  final String nama = 'I Putu Agus Martha Jaya';
  final String nim = '2415051097';

  int itemCount = 0;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    loadCourses();
  }

  // 2. Panggil GET melalui function asynchronous
  Future<List<dynamic>> fetchCourses() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    }

    throw Exception('HTTP ${response.statusCode}');
  }

  void loadCourses() async {
    try {
      final data = await fetchCourses();
      setState(() {
        itemCount = data.length;
        isLoading = false;
      });

      // 3. Tampilkan jumlah item pada debugPrint
      debugPrint('========================================');
      debugPrint('Praktikum Tahap 2');
      debugPrint('Nama : $nama');
      debugPrint('NIM  : $nim');
      debugPrint('Jumlah item berhasil dimuat: $itemCount');
      debugPrint('========================================');
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
      debugPrint('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Praktikum Tahap 2 - HTTP GET'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Tampilan Nama dan NIM pada Editor & UI
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Nama: $nama',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'NIM: $nim',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Status Loading / Error / Hasil Jumlah Item
              if (isLoading)
                const CircularProgressIndicator()
              else if (errorMessage.isNotEmpty)
                Text(
                  'Terjadi Kesalahan:\n$errorMessage',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                )
              else
                // 3. Tampilkan jumlah item pada UI
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Text(
                    'Jumlah Item: $itemCount',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}