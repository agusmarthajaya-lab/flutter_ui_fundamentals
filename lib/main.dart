import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/course_service.dart';
import 'repositories/course_repository.dart';
import 'providers/course_provider.dart';
import 'screens/course_home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<CourseService>(create: (_) => CourseService()),
        ProxyProvider<CourseService, CourseRepository>(
          update: (_, service, __) => CourseRepository(service),
        ),
        ChangeNotifierProxyProvider<CourseRepository, CourseProvider>(
          create: (context) => CourseProvider(context.read<CourseRepository>())..loadCourses(),
          update: (_, repository, previousProvider) => 
              previousProvider ?? CourseProvider(repository),
        ),
      ],
      child: const CourseExplorerApp(),
    ),
  );
}

class CourseExplorerApp extends StatelessWidget {
  const CourseExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Menghilangkan pita merah "DEBUG"
      title: 'Course Explorer v1 - Tahap 13',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CourseHomeScreen(),
    );
  }
}