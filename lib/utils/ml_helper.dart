import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class MLHelper {
  static late Interpreter _interpreter;
  static late Map<String, dynamic> _metadata;

  /// Inisialisasi model dan metadata
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

  /// Fungsi utama klasifikasi tanpa normalisasi
  static Future<String> classifyImage(File imageFile) async {
    try {
      // 1. Decode gambar
      final rawBytes = await imageFile.readAsBytes();
      final originalImage = img.decodeImage(rawBytes);
      if (originalImage == null) throw Exception('Gagal decode gambar');

      // 2. Log ukuran dan RGB awal
      final oriPixel = originalImage.getPixelSafe(0, 0);
      print('🖼️ Original Size: ${originalImage.width} x ${originalImage.height}');
      print('🔎 Original RGB (0,0): R=${oriPixel.r}, G=${oriPixel.g}, B=${oriPixel.b}');

      // 3. Resize
      final inputSize = _metadata['preprocess']['input_size'];
      final width = inputSize[0];
      final height = inputSize[1];
      final resized = img.copyResize(originalImage, width: width, height: height);

      final resizedPixel = resized.getPixelSafe(0, 0);
      print('📐 Resized Size: ${resized.width} x ${resized.height}');
      print('🧪 Resized RGB (0,0): R=${resizedPixel.r}, G=${resizedPixel.g}, B=${resizedPixel.b}');

      // 4. Buat input tensor tanpa normalisasi (langsung pakai nilai RGB 0-255)
      final input = Float32List(width * height * 3);
      int index = 0;

      for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
          final p = resized.getPixelSafe(x, y);

          input[index++] = p.r.toDouble();
          input[index++] = p.g.toDouble();
          input[index++] = p.b.toDouble();

          if (x == 0 && y == 0) {
            print('⚙️ Input tanpa normalisasi (0,0): R=${p.r.toDouble()}, G=${p.g.toDouble()}, B=${p.b.toDouble()}');
          }
        }
      }

      // 5. Inferensi
      final inputTensor = input.reshape([1, height, width, 3]);
      final output = List.filled(1 * 3, 0.0).reshape([1, 3]);

      _interpreter.run(inputTensor, output);

      // 6. Interpretasi hasil
      final labels = List<String>.from(_metadata['labels']);
      final probs = output[0];

      print('\n📊 Probabilitas Kelas:');
      for (int i = 0; i < probs.length; i++) {
        print('${labels[i]}: ${(probs[i] * 100).toStringAsFixed(2)}%');
      }

      int maxIndex = 0;
      double maxProb = probs[0];
      for (int i = 1; i < probs.length; i++) {
        if (probs[i] > maxProb) {
          maxIndex = i;
          maxProb = probs[i];
        }
      }

      final result = '${labels[maxIndex]} (${(maxProb * 100).toStringAsFixed(1)}%)';
      print('\n🎯 Hasil Akhir: $result');
      return result;
    } catch (e) {
      throw Exception('❌ Classification error: ${e.toString()}');
    }
  }
}
