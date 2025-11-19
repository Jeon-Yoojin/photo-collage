import 'package:flutter/material.dart';
import '../features/template_selection/presentation/pages/template_selection_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo Collage',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
      ),
      home: SelectPhotoTemplatePage(),
    );
  }
}
