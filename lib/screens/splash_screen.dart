import 'package:flutter/material.dart';
import '../theme/neumorphic_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Auto navigate to Login Screen after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Floating Neumorphic Logo
            Container(
              width: 130,
              height: 130,
              decoration: NeoBox.flat(),
              child: const Icon(Icons.lock_person_rounded, size: 60, color: NeoColors.primary),
            ),
            const SizedBox(height: 40),
            const Text(
              "SMART ASSET LOCKER",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: NeoColors.textPrimary,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Management System v1.0",
              style: TextStyle(fontSize: 14, color: NeoColors.textSecondary, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 60),
            // Minimalist Premium Progress
            const SizedBox(
              width: 40,
              child: LinearProgressIndicator(
                color: NeoColors.primary,
                backgroundColor: Color(0xFFE6EBF2),
              ),
            )
          ],
        ),
      ),
    );
  }
}