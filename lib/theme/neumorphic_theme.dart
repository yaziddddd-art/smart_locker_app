import 'package:flutter/material.dart';

class NeoColors {
  static const Color background = Color(0xFFEEF2F7);
  static const Color surface = Color(0xFFF6F8FB);
  static const Color card = Color(0xFFF8FAFC);
  static const Color primary = Color(0xFF2563EB);
  static const Color secondary = Color(0xFF10B981);
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
}

class NeoBox {
  // Kesan Kad Timbul (Concave / Convex Light)
  static BoxDecoration flat() {
    return BoxDecoration(
      color: NeoColors.background,
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        const BoxShadow(
          color: Colors.white,
          offset: Offset(-8, -8),
          blurRadius: 16,
        ),
        BoxShadow(
          color: const Color(0xFFE6EBF2).withOpacity(0.08),
          offset: const Offset(8, 8),
          blurRadius: 16,
        ),
      ],
    );
  }

  // Kesan Kad Tenggelam / Inset (Sesuai untuk TextField / Input)
  static BoxDecoration sunken() {
    return BoxDecoration(
      color: const Color(0xFFE6EBF2),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: Colors.white.withOpacity(0.5), width: 1),
    );
  }

  // Kesan Glassmorphism Moden (Gabungan Neumorphism)
  static BoxDecoration glass() {
    return BoxDecoration(
      color: Colors.white.withOpacity(0.65),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.5),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }
}