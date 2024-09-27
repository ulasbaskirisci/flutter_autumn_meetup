import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';

class SharePlusGallery extends StatefulWidget {
  @override
  _SharePlusGalleryState createState() => _SharePlusGalleryState();
}

class _SharePlusGalleryState extends State<SharePlusGallery> {
  File? _imageFile; // Seçilen görsel dosyası

  // Galeriden görsel seçme fonksiyonu
  Future<void> _pickImageFromGallery() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false, // Tek dosya seçimi
      type: FileType.custom, // Özelleştirilmiş dosya türü
      allowedExtensions: ['jpg', 'png'], // Yalnızca jpg ve png dosyaları
    );

    if (result != null) {
      setState(() {
        _imageFile = File(result.files.first.path!);
      });
    }
  }

  // Seçilen görseli paylaşma fonksiyonu
  Future<void> _shareImage() async {
    if (_imageFile != null) {
      // XFile nesnesi oluşturuyoruz
      final XFile xFile = XFile(_imageFile!.path);

      // shareXFiles fonksiyonu XFile türünde bir liste bekler
      await Share.shareXFiles([xFile], text: 'Bu görseli paylaşın!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Görsel Seç ve Paylaş'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Görsel varsa ekranda göster
            if (_imageFile != null)
              Column(
                children: [
                  Image.file(_imageFile!, height: 300),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _shareImage,
                    child: Text('Görseli Paylaş'),
                  ),
                ],
              ),
            // Görsel seçilmemişse buton göster
            if (_imageFile == null)
              ElevatedButton(
                onPressed: _pickImageFromGallery,
                child: Text('Galeriden Görsel Seç'),
              ),
          ],
        ),
      ),
    );
  }
}
