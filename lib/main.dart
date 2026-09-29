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
          child: Text(
            '$studentId\n$studentName',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 30),
          ),
        ),
      ),
    );
  }
}