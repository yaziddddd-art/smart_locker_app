import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../theme/neumorphic_theme.dart';
import 'asset_detail_screen.dart';

class AssetListScreen extends StatelessWidget {
  const AssetListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Tarik nod 'assets' dari Firebase
    final DatabaseReference dbRef = FirebaseDatabase.instance.ref('assets');

    return Scaffold(
      backgroundColor: NeoColors.background,
      appBar: AppBar(
        backgroundColor: NeoColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "Asset List",
          style: TextStyle(color: NeoColors.textPrimary, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: dbRef.onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Jika ada error atau data kosong kat Firebase
          if (snapshot.hasError || !snapshot.hasData || snapshot.data?.snapshot.value == null) {
            return const Center(
              child: Text(
                "No assets found in Firebase.",
                style: TextStyle(color: NeoColors.textSecondary),
              ),
            );
          }

          // Processing data dari Firebase
          final Map<dynamic, dynamic> map =
              snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          final List<MapEntry<dynamic, dynamic>> assetList = map.entries.toList();

          return ListView.builder(
            padding: const EdgeInsets.all(24.0),
            itemCount: assetList.length,
            itemBuilder: (context, index) {
              final String key = assetList[index].key.toString();
              final Map<dynamic, dynamic> item =
                  Map<dynamic, dynamic>.from(assetList[index].value as Map);

              final String name = item['name']?.toString() ?? 'Unnamed Asset';
              final String status = item['status']?.toString() ?? 'Unknown';

              return GestureDetector(
                onTap: () {
                  // Tekan item terus buka AssetDetailScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AssetDetailScreen(
                        asset: item,
                        assetKey: key,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: NeoColors.background,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(color: Colors.white, offset: Offset(-4, -4), blurRadius: 8),
                      BoxShadow(color: Color(0xFFAEBECB), offset: Offset(4, 4), blurRadius: 8),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: NeoColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Status: $status",
                            style: TextStyle(
                              fontSize: 12,
                              color: status.toLowerCase() == 'available'
                                  ? Colors.green
                                  : Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                        color: NeoColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}