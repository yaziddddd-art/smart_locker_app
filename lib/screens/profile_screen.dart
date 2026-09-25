import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../theme/neumorphic_theme.dart';
import 'admin_panel_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  final String _adminPin = "1234";

  void _showAdminPinDialog(BuildContext context) {
    final TextEditingController pinController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: NeoColors.background,
        title: const Text(
          "Admin Verification",
          style: TextStyle(color: NeoColors.textPrimary, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Masukkan PIN Admin untuk teruskan:",
              style: TextStyle(color: NeoColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: pinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter Admin PIN",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: NeoColors.primary),
            onPressed: () {
              if (pinController.text == _adminPin) {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminPanelScreen()),
                );
              } else {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('AKSES DITOLAK: PIN Admin Salah!'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text("Sahkan", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: NeoColors.background,
      appBar: AppBar(
        backgroundColor: NeoColors.background,
        elevation: 0,
        title: const Text(
          "User Profile",
          style: TextStyle(color: NeoColors.textPrimary, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Profile Avatar
            Center(
              child: Container(
                padding: const EdgeInsets.all(25),
                decoration: const BoxDecoration(
                  color: NeoColors.background,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Colors.white, offset: Offset(-6, -6), blurRadius: 12),
                    BoxShadow(color: Color(0xFFAEBECB), offset: Offset(6, 6), blurRadius: 12),
                  ],
                ),
                child: const Icon(Icons.person_rounded, size: 60, color: NeoColors.primary),
              ),
            ),
            const SizedBox(height: 16),

            // STREAM BUILDER: DENGAR DATA NAMA SECARA REALTIME
            StreamBuilder<DatabaseEvent>(
              stream: user != null
                  ? FirebaseDatabase.instance.ref('users/${user.uid}').onValue
                  : null,
              builder: (context, snapshot) {
                String displayName = '';

                // 1. Ambil nama dari Firebase Auth Display Name dulu
                if (user?.displayName != null && user!.displayName!.isNotEmpty) {
                  displayName = user.displayName!;
                }

                // 2. Jika tiada, semak dalam Realtime Database (users/UID)
                if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                  final Map<dynamic, dynamic> data =
                      Map<dynamic, dynamic>.from(snapshot.data!.snapshot.value as Map);

                  // Cari medan 'name', 'username', atau 'fullName'
                  displayName = data['name'] ??
                      data['username'] ??
                      data['fullName'] ??
                      data['displayName'] ??
                      displayName;
                }

                // 3. Jika langsung tiada nama dalam DB, potong email jadi nama (cth: abc123)
                if (displayName.isEmpty && user?.email != null) {
                  displayName = user!.email!.split('@')[0];
                }

                return Text(
                  displayName.isNotEmpty ? displayName : "User Account",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: NeoColors.textPrimary,
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // Butang Admin Panel
            GestureDetector(
              onTap: () => _showAdminPinDialog(context),
              child: Container(
                height: 55,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: NeoColors.background,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(color: Colors.white, offset: Offset(-4, -4), blurRadius: 8),
                    BoxShadow(color: Color(0xFFAEBECB), offset: Offset(4, 4), blurRadius: 8),
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.admin_panel_settings_rounded, color: NeoColors.primary),
                    SizedBox(width: 10),
                    Text(
                      "ADMIN PANEL",
                      style: TextStyle(color: NeoColors.primary, fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // Logout
            GestureDetector(
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, '/login');
                }
              },
              child: Container(
                height: 55,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: NeoColors.background,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(color: Colors.white, offset: Offset(-4, -4), blurRadius: 8),
                    BoxShadow(color: Color(0xFFAEBECB), offset: Offset(4, 4), blurRadius: 8),
                  ],
                ),
                child: const Center(
                  child: Text("LOGOUT", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}