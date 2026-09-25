import 'package:flutter/material.dart';
import 'screens/login_screen.dart'; // Direct import login screen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Locker App',
      home: const LoginScreen(), // Terus buka Login Screen
    );
  }
}