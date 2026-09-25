import 'package:flutter/material.dart';
import '../theme/neumorphic_theme.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeoColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Notifications", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: NeoColors.textPrimary)),
              const SizedBox(height: 20),
              _buildNotifCard("Asset Return Reminder", "Please return the Arduino Uno R3 before 5:00 PM today.", Icons.alarm_rounded, NeoColors.warning),
              const SizedBox(height: 16),
              _buildNotifCard("Locker Access Successful", "Locker L-03 has been successfully locked again automatically.", Icons.lock_rounded, NeoColors.success),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotifCard(String title, String desc, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: NeoBox.glass(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.15), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: NeoColors.textPrimary, fontSize: 14)),
                const SizedBox(height: 4),
                Text(desc, style: const TextStyle(color: NeoColors.textSecondary, fontSize: 12)),
              ],
            ),
          )
        ],
      ),
    );
  }
}