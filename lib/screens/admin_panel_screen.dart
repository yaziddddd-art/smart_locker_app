import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../theme/neumorphic_theme.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  final _database = FirebaseDatabase.instance.ref();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _uidController = TextEditingController();
  String _selectedLocker = 'Locker 1';
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _listenToLastScannedCard();
  }

  // Dengar UID kad yang baru ditepuk kat LCD/ESP32 secara Live
  void _listenToLastScannedCard() {
    _database.child('system/last_scanned_card').onValue.listen((event) {
      if (event.snapshot.exists && event.snapshot.value != null) {
        final scannedUid = event.snapshot.value.toString();
        setState(() {
          _uidController.text = scannedUid;
        });
      }
    });
  }

  // Simpan Kad & User Baru ke Firebase Database
  Future<void> _registerNewCard() async {
    if (_nameController.text.trim().isEmpty || _uidController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Make sure to fill in both Owner Name and NFC Card UID!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final cardUid = _uidController.text.trim();
      
      // Simpan under path 'registered_cards/UID'
      await _database.child('registered_cards/$cardUid').set({
        'uid': cardUid,
        'assigned_to': _nameController.text.trim(),
        'assigned_locker': _selectedLocker,
        'status': 'active',
        'created_at': DateTime.now().toIso8601String(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully registered NFC Card ($cardUid) for ${_nameController.text}!'),
            backgroundColor: Colors.green,
          ),
        );
        _nameController.clear();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
          "Admin Control Panel",
          style: TextStyle(color: NeoColors.textPrimary, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // KOTAK KAD NFC TERAKHIR DITAP (LIVE FROM ESP32/LCD)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: NeoColors.background,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(color: Colors.white, offset: Offset(-4, -4), blurRadius: 8),
                  BoxShadow(color: Color(0xFFAEBECB), offset: Offset(4, 4), blurRadius: 8),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.nfc_rounded, size: 40, color: NeoColors.primary),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "NFC Card Detected (Live):",
                          style: TextStyle(fontSize: 12, color: NeoColors.textSecondary),
                        ),
                        Text(
                          _uidController.text.isEmpty ? "Tap Card At Reader..." : _uidController.text,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: NeoColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),
            const Text(
              "Register New NFC Card",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: NeoColors.textPrimary),
            ),
            const SizedBox(height: 15),

            // INPUT NAMA PENGGUNA
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Owner Name",
                prefixIcon: const Icon(Icons.person_outline_rounded),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 15),

            // INPUT UID (AUTO-FILL ATAU MANUAL)
            TextField(
              controller: _uidController,
              decoration: InputDecoration(
                labelText: "NFC Card UID",
                prefixIcon: const Icon(Icons.credit_card_rounded),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 15),

            // PILIH LOKER
            DropdownButtonFormField<String>(
              value: _selectedLocker,
              decoration: InputDecoration(
                labelText: "Select Locker Access",
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: ['Locker 1', 'Locker 2', 'Locker 3', 'All Lockers']
                  .map((locker) => DropdownMenuItem(value: locker, child: Text(locker)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedLocker = val!),
            ),
            const SizedBox(height: 25),

            // BUTANG SIMPAN
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: NeoColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _isSaving ? null : _registerNewCard,
                child: _isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Register New NFC Card",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}