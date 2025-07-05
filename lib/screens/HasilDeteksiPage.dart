import 'dart:io';
import 'package:flutter/material.dart';

class HasilDeteksiPage extends StatelessWidget {
  final File imageFile;
  final String result;

  const HasilDeteksiPage({
    super.key,
    required this.imageFile,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF1E66A8); // warna utama biru

    // Tentukan warna dan icon berdasarkan hasil deteksi
    Color resultColor;
    IconData resultIcon;
    String status;

    if (result.contains('Sangat Segar')) {
      resultColor = const Color(0xFF023E8A);
      resultIcon = Icons.check_circle;
      status = 'Sangat Segar';
    } else if (result.contains('Tidak Segar')) {
      resultColor = const Color(0xFFFF8A5B);
      resultIcon = Icons.warning_amber_rounded;
      status = 'Tidak Segar';
    } else if (result.contains('Segar')) {
      resultColor = const Color(0xFFF8E9A1);
      resultIcon = Icons.info;
      status = 'Segar';
    } else {
      resultColor = Colors.grey;
      resultIcon = Icons.help_outline;
      status = 'Tidak Dikenali';
    }

    // Ambil confidence jika ada
    final confidence = result.contains('(') ? result.split('(')[1].replaceAll(')', '') : '-';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Deteksi'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Gambar ikan
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(imageFile, height: 260, width: double.infinity, fit: BoxFit.cover),
            ),

            const SizedBox(height: 25),

            // Kartu hasil deteksi
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(resultIcon, size: 60, color: resultColor),
                    const SizedBox(height: 12),
                    const Text(
                      'Hasil Deteksi Kesegaran',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      status,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: resultColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tingkat Keyakinan: $confidence',
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Tombol kembali
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Kembali ke Deteksi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
