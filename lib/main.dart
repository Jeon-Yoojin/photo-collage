import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recall_scanner/provider/change_notifier.dart';
import 'app/app.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => TemplateProvider(), child: const MyApp()));
}
