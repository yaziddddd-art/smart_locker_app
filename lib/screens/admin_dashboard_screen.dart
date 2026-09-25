import 'package:flutter/material.dart';
import '../theme/neumorphic_theme.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Admin Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: NeoColors.danger.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text("Admin Panel", style: TextStyle(color: NeoColors.danger, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 4),
                      const Text("Management System", style: TextStyle(color: NeoColors.textSecondary, fontSize: 14)),
                      const Text("Main Utilities", style: TextStyle(color: NeoColors.textPrimary, fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Container(
                    width: 55, height: 55,
                    decoration: NeoBox.flat().copyWith(shape: BoxShape.circle),
                    child: const Icon(Icons.admin_panel_settings_rounded, size: 30, color: NeoColors.danger),
                  )
                ],
              ),
              const SizedBox(height: 35),

              // Status Kesihatan Sistem (System Health)
              const Text("System Health", style: TextStyle(color: NeoColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildAdminCard("Control Logs", "Active", Icons.article_rounded, NeoColors.success)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildAdminCard("NFC Reader", "Ready", Icons.nfc_rounded, NeoColors.primary)),
                ],
              ),
              const SizedBox(height: 35),

              // Menu Pengurusan Admin
              const Text("Admin Management", style: TextStyle(color: NeoColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              
              _buildMenuRow(Icons.inventory_2_rounded, "Manage Assets", "Add, update, or delete assets."),
              const SizedBox(height: 16),
              _buildMenuRow(Icons.people_alt_rounded, "Manage Users", "Approve registration for new staff members."),
              const SizedBox(height: 16),
              _buildMenuRow(Icons.analytics_rounded, "Transaction Reports", "Export loan data to CSV/PDF files."),
              const SizedBox(height: 35),

              // Logout Button
              GestureDetector(
                onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                child: Container(
                  height: 60,
                  width: double.infinity,
                  decoration: NeoBox.flat(),
                  child: const Center(
                    child: Text("Logout", style: TextStyle(color: NeoColors.textSecondary, fontWeight: FontWeight.bold)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdminCard(String title, String status, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 110,
      decoration: NeoBox.flat(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: const TextStyle(color: NeoColors.textSecondary, fontSize: 12)),
              const SizedBox(height: 4),
              Text(status, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.w900)),
            ],
          ),
          Icon(icon, color: color, size: 28),
        ],
      ),
    );
  }

  Widget _buildMenuRow(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: NeoBox.glass(),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: NeoColors.primary.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: NeoColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: NeoColors.textPrimary, fontSize: 15)),
                Text(subtitle, style: const TextStyle(color: NeoColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: NeoColors.textSecondary),
        ],
      ),
    );
  }
}