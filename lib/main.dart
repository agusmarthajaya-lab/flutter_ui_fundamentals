import 'package:flutter/material.dart';

const String studentName = 'I Putu Agus Martha Jaya';
const String studentId = '2415051097';

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
        body: Center(
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
              const SizedBox(height: 24),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        '8',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('Widget'),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        '4',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('Layout'),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        '1',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('State'),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}