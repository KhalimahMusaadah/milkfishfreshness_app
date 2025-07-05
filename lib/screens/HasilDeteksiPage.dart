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
    const Color primaryColor = Color(0xFF1E66A8);
    const Color selectedBoxColor = Color(0xFF11395D);
    const Color inactiveBoxColor = Color(0xFFE0E0E0);

    // Ambil status dan confidence dari baris pertama result
    final firstLine = result.trim().split('\n').first;
    final labelMatch = RegExp(r'^(.+?)\s*\(([\d.]+)%\)').firstMatch(firstLine);

    String status = 'Tidak Dikenali';
    String confidence = '-';

    if (labelMatch != null) {
      status = labelMatch.group(1) ?? 'Tidak Dikenali';
      confidence = '${labelMatch.group(2)}%';
    }

    // Ekstrak semua probabilitas dari result string
    final Map<String, String> probabilityMap = {};
    final regex = RegExp(r'(.+?)\s*\(([\d.]+)%\)');
    for (final match in regex.allMatches(result)) {
      final label = match.group(1)?.trim() ?? '';
      final value = match.group(2)?.trim() ?? '';
      if (label.isNotEmpty && value.isNotEmpty) {
        probabilityMap[label] = value;
      }
    }

    Widget buildStatusBox(String label) {
      final bool isSelected = status.toLowerCase() == label.toLowerCase();
      return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: isSelected ? 65 : 45,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? selectedBoxColor : inactiveBoxColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: isSelected ? 14 : 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.white : Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hasil Deteksi',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
          ),
        ),
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
            // Preview gambar
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                imageFile,
                height: 260,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),

            // Container status
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'Terdeteksi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: buildStatusBox('Sangat Segar')),
                      Expanded(child: buildStatusBox('Segar')),
                      Expanded(child: buildStatusBox('Tidak Segar')),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Tingkat Keyakinan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Montserrat',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    confidence,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      color: Color(0xFF11395D),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    status,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Montserrat',
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Container probabilitas per kelas
            if (probabilityMap.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Probabilitas Setiap Kelas',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...probabilityMap.entries.map((e) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                e.key,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                              Text(
                                '${e.value}%',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),

            const SizedBox(height: 30),

            // Tombol kembali
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context, true),
              icon: const Icon(Icons.arrow_back),
              label: const Text(
                'Kembali ke Deteksi',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
