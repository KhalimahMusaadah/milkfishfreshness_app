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
    Color resultColor;
    if (result.contains('Tidak Segar')) {
      resultColor = Colors.red;
    } else if (result.contains('Segar')) {
      resultColor = Colors.orange;
    } else {
      resultColor = Colors.green;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Deteksi'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10)),
              child: Image.file(imageFile, height: 300, fit: BoxFit.cover),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: resultColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: resultColor),
              ),
              child: Column(
                children: [
                  const Text(
                    'Hasil Deteksi Kesegaran:',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    result.split(' (')[0],
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: resultColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Tingkat Keyakinan: ${result.split('(')[1]}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const Text('Kembali ke Deteksi'),
            ),
          ],
        ),
      ),
    );
  }
}