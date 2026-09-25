import 'package:flutter/material.dart';
import '../theme/neumorphic_theme.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: NeoColors.textPrimary),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 20),
              const Text("Daftar Akaun Baru", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: NeoColors.textPrimary)),
              const Text("Sila isi maklumat rasmi staff makmal", style: TextStyle(fontSize: 14, color: NeoColors.textSecondary)),
              const SizedBox(height: 30),
              
              _inputField("NAMA PENUH", "Prof. Dr. Irfan"),
              const SizedBox(height: 20),
              _inputField("STAFF ID", "STF4092"),
              const SizedBox(height: 20),
              _inputField("EMEL RASMI", "nama@staff.edu.my"),
              const SizedBox(height: 20),
              _inputField("NOMBOR TELEFON", "+60123456789"),
              const SizedBox(height: 20),
              _inputField("KATA LALUAN", "••••••••", obscure: true),
              const SizedBox(height: 20),
              _inputField("SAHKAN KATA LALUAN", "••••••••", obscure: true),
              
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  height: 60, width: double.infinity,
                  decoration: NeoBox.flat().copyWith(color: NeoColors.primary),
                  child: const Center(child: Text("DAFTAR SEKARANG", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5))),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputField(String label, String hint, {bool obscure = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("  $label", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: NeoColors.textSecondary)),
        const SizedBox(height: 8),
        Container(
          decoration: NeoBox.sunken(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          child: TextField(obscureText: obscure, decoration: InputDecoration(border: InputBorder.none, hintText: hint, hintStyle: const TextStyle(color: Colors.grey, fontSize: 14))),
        ),
      ],
    );
  }
}
