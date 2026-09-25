import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UnlockScreen extends StatefulWidget {
  const UnlockScreen({super.key});

  @override
  State<UnlockScreen> createState() => _UnlockScreenState();
}

class _UnlockScreenState extends State<UnlockScreen> {
  // Tetapan IP ESP32 (Boleh diubah terus dari app)
  final TextEditingController _ipController =
      TextEditingController(text: "192.168.1.50");

  bool _isLoading = false;
  String _statusText = "KUNCI TERKUNCI";
  Color _statusColor = Colors.redAccent;
  IconData _lockIcon = Icons.lock_outline_rounded;

  // Fungsi HTTP Unlock ke ESP32
  Future<void> _triggerUnlock() async {
    final ip = _ipController.text.trim();
    if (ip.isEmpty) {
      _showSnackBar("Sila masukkan Alamat IP ESP32!", Colors.orange);
      return;
    }

    setState(() {
      _isLoading = true;
      _statusText = "MENGHANTAR ISYARAT...";
      _statusColor = Colors.amber.shade700;
    });

    try {
      final response = await http
          .get(Uri.parse('http://$ip/unlock'))
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        setState(() {
          _statusText = "PINTU BERJAYA DIBUKA!";
          _statusColor = Colors.green;
          _lockIcon = Icons.lock_open_rounded;
        });
        _showSnackBar("Solenoid ditarik (3 Saat)", Colors.green);

        // Kunci balik status UI selepas 3 saat
        await Future.delayed(const Duration(seconds: 3));
        if (mounted) {
          setState(() {
            _statusText = "KUNCI TERKUNCI";
            _statusColor = Colors.redAccent;
            _lockIcon = Icons.lock_outline_rounded;
          });
        }
      } else {
        setState(() {
          _statusText = "RALAT ESP32: ${response.statusCode}";
          _statusColor = Colors.red;
        });
      }
    } catch (e) {
      setState(() {
        _statusText = "GAGAL SAMBUNG! SEMAK WIFI/IP";
        _statusColor = Colors.red;
      });
      _showSnackBar("Ralat sambungan: $e", Colors.red);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String text, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0E5EC), // Warna Latar Neumorphic
      appBar: AppBar(
        title: const Text('SMART LOCKER SYSTEM',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: const Color(0xFFE0E5EC),
        elevation: 0,
        foregroundColor: Colors.blueGrey.shade800,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Kad Tetapan IP ESP32
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E5EC),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.white, offset: Offset(-3, -3), blurRadius: 6),
                    BoxShadow(
                        color: Color(0xFFA3B1C6), offset: Offset(3, 3), blurRadius: 6),
                  ],
                ),
                child: TextField(
                  controller: _ipController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.wifi, color: Colors.indigo),
                    border: InputBorder.none,
                    labelText: 'Alamat IP ESP32',
                    hintText: '192.168.1.50',
                  ),
                ),
              ),

              // Status Pintu
              Column(
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Icon(_lockIcon,
                        key: ValueKey(_lockIcon), size: 80, color: _statusColor),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _statusText,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _statusColor,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),

              // Butang Utama Unlock (Neumorphic Style)
              GestureDetector(
                onTap: _isLoading ? null : _triggerUnlock,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFE0E5EC),
                    boxShadow: _isLoading
                        ? [
                            const BoxShadow(
                                color: Color(0xFFA3B1C6),
                                offset: Offset(-2, -2),
                                blurRadius: 4),
                            const BoxShadow(
                                color: Colors.white,
                                offset: Offset(2, 2),
                                blurRadius: 4),
                          ]
                        : [
                            const BoxShadow(
                                color: Colors.white,
                                offset: Offset(-6, -6),
                                blurRadius: 12),
                            const BoxShadow(
                                color: Color(0xFFA3B1C6),
                                offset: Offset(6, 6),
                                blurRadius: 12),
                          ],
                  ),
                  child: Center(
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.indigo)
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.power_settings_new_rounded,
                                  size: 54, color: Colors.indigo.shade700),
                              const SizedBox(height: 8),
                              Text(
                                "BUKA PINTU",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo.shade900,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),

              const Text(
                "Pastikan telefon & ESP32 berada dalam Wi-Fi yang sama.",
                style: TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}