import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class ImagePickerExample extends StatefulWidget {
  const ImagePickerExample({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ImagePickerExampleState createState() => _ImagePickerExampleState();
}

class _ImagePickerExampleState extends State<ImagePickerExample> {
  File? _imageFile;
  File? _documentFile;

  Future<void> _pickImageFromCamera() async {
    final picker = ImagePicker();
    XFile? file = await picker.pickImage(source: ImageSource.camera);

    if (file != null) {
      setState(() {
        _imageFile = File(file.path);
      });
    }
  }

  Future<void> _pickImageFromGallery() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false, // Birden fazla dosya seçmeye izin verir
      type: FileType.custom,
      allowedExtensions: [
        'jpg',
        'png'
      ], // Yalnızca JPG ve PNG dosyaları seçilebilir
    );

    if (result != null) {
      setState(() {
        _imageFile = File(result.files.first.path!);
      });
    }
  }

  Future<void> _pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf'], // Yalnızca PDF dosyaları seçilebilir
    );

    if (result != null) {
      setState(() {
        _documentFile = File(result.files.single.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Picker & Document Picker"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_imageFile != null) Image.file(_imageFile!, height: 200),
            if (_documentFile != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Selected Document: ${_documentFile!.path}'),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImageFromCamera,
              child: const Text("Pick Image from Camera"),
            ),
            ElevatedButton(
              onPressed: _pickImageFromGallery,
              child: const Text("Pick Image from Gallery"),
            ),
            ElevatedButton(
              onPressed: _pickDocument,
              child: const Text("Pick Document"),
            ),
          ],
        ),
      ),
    );
  }
}
