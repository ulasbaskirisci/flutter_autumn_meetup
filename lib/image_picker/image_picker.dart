// Gerekli import'lar
import 'dart:io'; // Dosya işlemleri için
import 'package:flutter/material.dart'; // Flutter UI bileşenleri için
import 'package:image_picker/image_picker.dart'; // Kamera ve galeri erişimi için
import 'package:file_picker/file_picker.dart'; // Dosya seçimi için

// Ana widget sınıfı - StatefulWidget kullanarak dinamik durum yönetimi
class ImagePickerExample extends StatefulWidget {
  const ImagePickerExample({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ImagePickerExampleState createState() => _ImagePickerExampleState();
}

// Widget'ın durum yönetimini yapan sınıf
class _ImagePickerExampleState extends State<ImagePickerExample> {
  // Seçilen resim dosyasını tutan değişken
  File? _imageFile;
  // Seçilen döküman dosyasını tutan değişken (şu an kullanılmıyor)
  File? _documentFile;

  // Kameradan resim çekme fonksiyonu
  Future<void> _pickImageFromCamera() async {
    final picker = ImagePicker(); // ImagePicker instance'ı oluştur
    // Kameradan resim seç ve XFile olarak al
    XFile? file = await picker.pickImage(source: ImageSource.camera);

    // Eğer resim seçildiyse
    if (file != null) {
      setState(() {
        // Seçilen resmi File nesnesine çevir ve _imageFile'a ata
        _imageFile = File(file.path);
      });
    }
  }

  // Galeriden resim seçme fonksiyonu
  Future<void> _pickImageFromGallery() async {
    // FilePicker kullanarak dosya seçimi yap
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false, // Birden fazla dosya seçmeye izin verme
      type: FileType.custom, // Özel dosya tipi seçimi
      allowedExtensions: [
        'jpg',
        'png'
      ], // Yalnızca JPG ve PNG dosyaları seçilebilir
    );

    // Eğer dosya seçildiyse
    if (result != null) {
      setState(() {
        // Seçilen ilk dosyayı File nesnesine çevir ve _imageFile'a ata
        _imageFile = File(result.files.first.path!);
      });
    }
  }

  // UI'yi oluşturan build metodu
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Üst çubuk (AppBar)
      appBar: AppBar(
        title: const Text("Image Picker & Document Picker"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Eğer resim seçildiyse, resmi göster
            if (_imageFile != null) Image.file(_imageFile!, height: 200),
            // Eğer döküman seçildiyse, dosya yolunu göster (şu an kullanılmıyor)
            if (_documentFile != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Selected Document: ${_documentFile!.path}'),
              ),
            // Bileşenler arası boşluk
            const SizedBox(height: 20),
            // Kameradan resim çekme butonu
            ElevatedButton(
              onPressed: _pickImageFromCamera,
              child: const Text("Pick Image from Camera"),
            ),
            // Galeriden resim seçme butonu
            ElevatedButton(
              onPressed: _pickImageFromGallery,
              child: const Text("Pick Image from Gallery"),
            ),
          ],
        ),
      ),
    );
  }
}
