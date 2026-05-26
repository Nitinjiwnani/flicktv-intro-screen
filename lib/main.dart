import 'package:flutter/material.dart';
import 'core/theme/app_colors.dart';

void main() {
  runApp(const FlickTVApp());
}

class FlickTVApp extends StatelessWidget {
  const FlickTVApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nitin Jiwnani',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Inter',
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Text(
            'Assets loaded',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}