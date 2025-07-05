import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class MLHelper {
  static late Interpreter _interpreter;
  static late Map<String, dynamic> _metadata;

  // Inisialisasi model dan metadata
  static Future<void> initialize() async {
    try {
      final modelData = await rootBundle.load('assets/models/model_quant.tflite');
      final modelBytes = modelData.buffer.asUint8List();
      _interpreter = Interpreter.fromBuffer(modelBytes);

      final metadataStr = await rootBundle.loadString('assets/models/metadata.json');
      _metadata = jsonDecode(metadataStr);

      print('✅ Model dan metadata berhasil dimuat.');
    } catch (e) {
      throw Exception('❌ Gagal inisialisasi MLHelper: ${e.toString()}');
    }
  }

  // Fungsi utama klasifikasi gambar
  static Future<String> classifyImage(File imageFile) async {
    try {
      // 1. Decode gambar
      final rawBytes = await imageFile.readAsBytes();
      final originalImage = img.decodeImage(rawBytes);
      if (originalImage == null) throw Exception('Gagal decode gambar');

      // 2. Resize gambar ke ukuran input model
      final inputSize = _metadata['preprocess']['input_size'];
      final width = inputSize[0];
      final height = inputSize[1];
      final resized = img.copyResize(originalImage, width: width, height: height);

      // 3. Buat input tensor (tanpa normalisasi)
      final input = Float32List(width * height * 3);
      int index = 0;
      for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
          final pixel = resized.getPixelSafe(x, y);
          input[index++] = pixel.r.toDouble();
          input[index++] = pixel.g.toDouble();
          input[index++] = pixel.b.toDouble();
        }
      }

      final inputTensor = input.reshape([1, height, width, 3]);
      final output = List.filled(1 * 3, 0.0).reshape([1, 3]);

      // 4. Jalankan inferensi
      _interpreter.run(inputTensor, output);

      // 5. Interpretasi hasil
      final labels = List<String>.from(_metadata['labels']);
      final probs = output[0];

      print('\n📊 Probabilitas Kelas (unsorted):');
      for (int i = 0; i < probs.length; i++) {
        print('${labels[i]}: ${(probs[i] * 100).toStringAsFixed(2)}%');
      }

      // Urutkan hasil berdasarkan probabilitas tertinggi
      List<int> sortedIndices = List.generate(probs.length, (i) => i)
        ..sort((a, b) => probs[b].compareTo(probs[a]));

      String allResults = '';
      for (int idx in sortedIndices) {
        final label = labels[idx];
        final value = (probs[idx] * 100).toStringAsFixed(1);
        allResults += '$label ($value%)\n';
      }

      allResults = allResults.trim(); // Hapus newline terakhir

      // Print hasil akhir
      final maxIdx = sortedIndices.first;
      print('\n🎯 Hasil Akhir: ${labels[maxIdx]} (${(probs[maxIdx] * 100).toStringAsFixed(1)}%)');

      return allResults;
    } catch (e) {
      return 'Terjadi kesalahan saat memproses gambar: ${e.toString()}';
    }
  }
}
