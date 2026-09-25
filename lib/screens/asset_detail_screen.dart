import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../theme/neumorphic_theme.dart';

class AssetDetailScreen extends StatelessWidget {
  final Map<dynamic, dynamic> asset;
  final String assetKey;

  const AssetDetailScreen({
    super.key,
    required this.asset,
    this.assetKey = 'asset_001',
  });

  // Fungsi hantar isyarat unlock ke Firebase
  Future<void> _unlockLocker(BuildContext context) async {
    try {
      final DatabaseReference dbRef = FirebaseDatabase.instance.ref();

      // 1. Tukar status asset kepada 'In Use'
      await dbRef.child('assets/$assetKey/status').set('In Use');

      // 2. Hantar arahan unlock ke nod lockers untuk hardware
      final String lockerId = asset['locker_id']?.toString() ?? 'Locker A';
      await dbRef.child('lockers/$lockerId/command').set('UNLOCK');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Locker ($lockerId) Unlocked Successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to unlock: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String assetName = asset['name']?.toString() ?? 'Raspberry Pi 4';
    final String status = asset['status']?.toString() ?? 'Available';
    final String lockerId = asset['locker_id']?.toString() ?? 'Locker A';

    return Scaffold(
      backgroundColor: NeoColors.background,
      appBar: AppBar(
        backgroundColor: NeoColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: NeoColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Asset Details",
          style: TextStyle(color: NeoColors.textPrimary, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Kad Maklumat Aset
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: NeoColors.background,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(color: Colors.white, offset: Offset(-8, -8), blurRadius: 16),
                  BoxShadow(color: Color(0xFFAEBECB), offset: Offset(8, 8), blurRadius: 16),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: NeoColors.background,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.white, offset: Offset(-4, -4), blurRadius: 8),
                          BoxShadow(color: Color(0xFFAEBECB), offset: Offset(4, 4), blurRadius: 8),
                        ],
                      ),
                      child: const Icon(Icons.memory_rounded, size: 50, color: NeoColors.primary),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildDetailRow("ASSET NAME", assetName),
                  const Divider(height: 32),
                  _buildDetailRow("LOCATION ", lockerId),
                  const Divider(height: 32),
                  _buildDetailRow("STATUS", status, isStatus: true),
                ],
              ),
            ),
            const Spacer(),
            
            // Butang UNLOCK LOCKER
            GestureDetector(
              onTap: () => _unlockLocker(context),
              child: Container(
                height: 60,
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
                  child: Text(
                    "UNLOCK LOCKER",
                    style: TextStyle(
                      color: NeoColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isStatus = false}) {
    Color valueColor = NeoColors.textPrimary;
    if (isStatus) {
      valueColor = value.toLowerCase() == 'available' ? Colors.green : Colors.orange;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: NeoColors.textSecondary),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: valueColor),
        ),
      ],
    );
  }
}