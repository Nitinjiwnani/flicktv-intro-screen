import 'package:flutter/material.dart';

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
        scaffoldBackgroundColor: const Color(0xFF1A1A1A),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Text(
            'FlickTV Intro - coming soon',
            style: TextStyle(color: Colors.white70),
          ),
        ),
      ),
    );
  }
}