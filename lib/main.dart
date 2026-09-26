import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/admin_dashboard_screen.dart';
import 'screens/admin_panel_screen.dart';
import 'screens/asset_detail_screen.dart';
import 'screens/asset_list_screen.dart';
import 'screens/history_screen.dart';
import 'screens/notification_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/unlock_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/admin-dashboard': (context) => const AdminDashboardScreen(),
        '/admin-panel': (context) => const AdminPanelScreen(),
        '/asset-list': (context) => const AssetListScreen(),
        '/history': (context) => const HistoryScreen(),
        '/notification': (context) => const NotificationScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/splash': (context) => const SplashScreen(),
        '/unlock': (context) => const UnlockScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/asset-detail') {
          final args = settings.arguments;
          return MaterialPageRoute(
            builder: (context) {
              // Jika data dihantar bersama navigator, pass ke AssetDetailScreen
              if (args is Map<dynamic, dynamic>) {
                return AssetDetailScreen(asset: args);
              }
              // Fallback jika dipanggil tanpa argument
              return const Scaffold(
                body: Center(
                  child: Text("No Asset Data Provided"),
                ),
              );
            },
          );
        }
        return null;
      },
    );
  }
}