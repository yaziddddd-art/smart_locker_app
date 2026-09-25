import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SmartLockScreen(),
  ));
}

class SmartLockScreen extends StatefulWidget {
  const SmartLockScreen({super.key});

  @override
  State<SmartLockScreen> createState() => _SmartLockScreenState();
}

class _SmartLockScreenState extends State<SmartLockScreen> {
  final TextEditingController _ipController = TextEditingController(text: "192.168.1.50");
  bool _isLoading = false;
  String _statusMessage = "Sistem Bersedia";
  Color _statusColor = Colors.grey;

  Future<void> sendUnlockRequest() async {
    setState(() {
      _isLoading = true;
      _statusMessage = "Menghantar arahan buka...";
      _statusColor = Colors.orange;
    });

    final ip = _ipController.text.trim();
    final url = Uri.parse('http://$ip/unlock');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 4));
      if (response.statusCode == 200) {
        setState(() {
          _statusMessage = "PINTU BERJAYA DIBUKA!";
          _statusColor = Colors.green;
        });
      } else {
        setState(() {
          _statusMessage = "Ralat ESP32: Status ${response.statusCode}";
          _statusColor = Colors.red;
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = "Gagal Sambung! Semak IP / WiFi.";
        _statusColor = Colors.red;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('ESP32 Smart Lock System'),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _ipController,
                  decoration: const InputDecoration(
                    labelText: 'Alamat IP ESP32',
                    hintText: 'Contoh: 192.168.1.50',
                    prefixIcon: Icon(Icons.wifi),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              decoration: BoxDecoration(
                color: _statusColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: _statusColor, width: 2),
              ),
              child: Text(
                _statusMessage,
                style: TextStyle(color: _statusColor, fontWeight: FontWeight.bold, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: 200,
              height: 200,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isLoading ? Colors.grey : Colors.indigo,
                  shape: const CircleBorder(),
                  elevation: 8,
                ),
                onPressed: _isLoading ? null : sendUnlockRequest,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 5)
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.lock_open_rounded, size: 64, color: Colors.white),
                          SizedBox(height: 8),
                          Text(
                            'BUKA PINTU',
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}