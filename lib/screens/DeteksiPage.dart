import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import '../utils/ml_helper.dart';
import 'HasilDeteksiPage.dart';

class DeteksiPage extends StatefulWidget {
  const DeteksiPage({super.key});

  @override
  _DeteksiPageState createState() => _DeteksiPageState();
}

class _DeteksiPageState extends State<DeteksiPage> {
  File? _image;
  bool _isProcessing = false;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      _cropImage(File(pickedFile.path));
    }
  }

  Future<void> _cropImage(File imageFile) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 100,
      maxWidth: 500,
      maxHeight: 500,
    );

    if (croppedFile != null) {
      setState(() {
        _image = File(croppedFile.path);
        _isProcessing = true;
      });
      
      final result = await _classifyImage(_image!);
      
      if (!mounted) return;
      
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HasilDeteksiPage(
            imageFile: _image!,
            result: result,
          ),
        ),
      );
      
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<String> _classifyImage(File image) async {
    try {
      return await MLHelper.classifyImage(image);
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deteksi Kesegaran Ikan Bandeng'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_image != null && !_isProcessing)
              Container(
                margin: const EdgeInsets.only(bottom: 30),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.file(_image!, height: 200, fit: BoxFit.cover),
              )
            else if (_isProcessing)
              const Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('Memproses gambar...'),
                ],
              )
            else
              Container(
                height: 200,
                margin: const EdgeInsets.only(bottom: 30),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image, size: 50, color: Colors.grey),
                      SizedBox(height: 10),
                      Text('Belum ada gambar', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.camera_alt),
                  onPressed: () => _pickImage(ImageSource.camera),
                  label: const Text('Ambil Foto'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton.icon(
                  icon: const Icon(Icons.photo_library),
                  onPressed: () => _pickImage(ImageSource.gallery),
                  label: const Text('Pilih dari Galeri'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}