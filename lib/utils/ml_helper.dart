import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:image/image.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class MLHelper {
  static late Interpreter _interpreter;
  static bool _isInitialized = false;

  static Future<void> initialize() async {
    if (_isInitialized) return;

    final options = InterpreterOptions();
    _interpreter = await Interpreter.fromAsset('assets/models/model.tflite', options: options);
    
    print('Input details: ${_interpreter.getInputTensor(0)}');
    print('Output details: ${_interpreter.getOutputTensor(0)}');
    
    _isInitialized = true;
  }

  static Future<String> classifyImage(File imageFile) async {
    if (!_isInitialized) await initialize();

    // 1. Load and decode image
    final imageBytes = await imageFile.readAsBytes();
    final image = img.decodeImage(imageBytes);
    if (image == null) throw Exception("Failed to load image");

    // 2. Preprocess image
    final input = _preprocessImage(image);

    // 3. Prepare output
    final outputShape = _interpreter.getOutputTensor(0).shape;
    final output = _createOutputArray(outputShape);

    // 4. Run inference
    _interpreter.run(input, output);

    // 5. Process results
    return _interpretResults(output[0]);
  }

  static List<List<List<List<double>>>> _preprocessImage(img.Image image) {
    const inputSize = 224;
    
    // Resize image to 224x224
    image = img.copyResize(image, width: inputSize, height: inputSize);
    
    // Create empty array with shape [1,224,224,3]
    final inputArray = List.generate(1, (_) => 
        List.generate(inputSize, (_) => 
            List.generate(inputSize, (_) => 
                List.filled(3, 0.0))));

    // Get RGB pixels and normalize to [-1, 1]
    final pixels = image.getBytes(order: ChannelOrder.rgb);
    int pixelIndex = 0;
    
    for (int y = 0; y < inputSize; y++) {
      for (int x = 0; x < inputSize; x++) {
        inputArray[0][y][x][0] = (pixels[pixelIndex++] / 127.5) - 1.0; // R
        inputArray[0][y][x][1] = (pixels[pixelIndex++] / 127.5) - 1.0; // G
        inputArray[0][y][x][2] = (pixels[pixelIndex++] / 127.5) - 1.0; // B
      }
    }

    return inputArray;
  }

  static List<List<double>> _createOutputArray(List<int> shape) {
    final elements = shape.reduce((a, b) => a * b);
    return [List.filled(elements, 0.0)];
  }

  static String _interpretResults(List<double> output) {
    final labels = ['Sangat Segar', 'Segar', 'Tidak Segar'];
    final prediction = _getPrediction(output);
    return '${labels[prediction.index]} (${(prediction.confidence * 100).toStringAsFixed(1)}%)';
  }

  static ({int index, double confidence}) _getPrediction(List<double> probabilities) {
    int maxIndex = 0;
    double maxProb = probabilities[0];
    
    for (int i = 1; i < probabilities.length; i++) {
      if (probabilities[i] > maxProb) {
        maxIndex = i;
        maxProb = probabilities[i];
      }
    }
    
    return (index: maxIndex, confidence: maxProb);
  }
}