import 'package:flutter/material.dart';
import '../theme/neumorphic_theme.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Transaction History", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: NeoColors.textPrimary)),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    _historyItem("Solenoid Valve L-03", "Dipulangkan", "12 Julai 2026", "12 Julai 2026", NeoColors.success),
                    _historyItem("Arduino Uno R3", "Sedang Dipinjam", "10 Julai 2026", "Belum Pulang", NeoColors.warning),
                    _historyItem("NFC Reader PN532", "Dipulangkan", "05 Julai 2026", "05 Julai 2026", NeoColors.success),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _historyItem(String name, String status, String borrowDate, String returnDate, Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(18),
      decoration: NeoBox.flat(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: NeoColors.textPrimary)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: statusColor.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                child: Text(status, style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Borrow Date", style: TextStyle(color: NeoColors.textSecondary, fontSize: 11)),
                  Text(borrowDate, style: const TextStyle(color: NeoColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text("Return Date", style: TextStyle(color: NeoColors.textSecondary, fontSize: 11)),
                  Text(returnDate, style: const TextStyle(color: NeoColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}