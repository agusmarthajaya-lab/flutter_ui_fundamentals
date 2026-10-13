import 'package:flutter/material.dart';
import '../models/course.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final bool isFavorite;
  final VoidCallback onFavoritePressed;
  final VoidCallback onTap;

  const CourseCard({
    super.key,
    required this.course,
    required this.isFavorite,
    required this.onFavoritePressed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12.0),
      child: ListTile(
        onTap: onTap,
        title: Text(
          course.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Kode: ${course.code} | SKS: ${course.credits} | Status: ${course.status}'),
        trailing: IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: Colors.red,
          ),
          onPressed: onFavoritePressed,
        ),
      ),
    );
  }
}