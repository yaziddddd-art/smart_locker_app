import 'package:flutter/material.dart';
import '../theme/neumorphic_theme.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Welcome & Notification Icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome Back,",
                        style: TextStyle(
                          fontSize: 14,
                          color: NeoColors.textSecondary,
                        ),
                      ),
                      Text(
                        "Smart Asset Locker",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: NeoColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  // Icon Notifikasi Bulat (BoxShape.circle SAHAJA)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: NeoColors.background,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.white, offset: Offset(-3, -3), blurRadius: 6),
                        BoxShadow(color: Color(0xFFAEBECB), offset: Offset(3, 3), blurRadius: 6),
                      ],
                    ),
                    child: const Icon(Icons.notifications_outlined, color: NeoColors.primary),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              
              // Card Status Sistem (borderRadius SAHAJA)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: NeoColors.background,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(color: Colors.white, offset: Offset(-6, -6), blurRadius: 12),
                    BoxShadow(color: Color(0xFFAEBECB), offset: Offset(6, 6), blurRadius: 12),
                  ],
                ),
                child: const Row(
                  children: [
                    Icon(Icons.lock_clock_rounded, size: 40, color: NeoColors.primary),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "System Status",
                          style: TextStyle(
                            fontSize: 12,
                            color: NeoColors.textSecondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "All Lockers Operational",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}