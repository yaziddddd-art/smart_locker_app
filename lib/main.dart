import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/login_screen.dart';

void main() async {
  // 1. Wajib dipanggil agar Flutter binding siap sebelum inisialisasi async
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inisialisasi Firebase App
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Locker',
      home: const LoginScreen(),
      routes: {
        '/dashboard': (context) => const Scaffold(
              body: Center(child: Text("Dashboard")),
            ), // Sesuaikan dengan route dashboard kamu
      },
    );
  }
}