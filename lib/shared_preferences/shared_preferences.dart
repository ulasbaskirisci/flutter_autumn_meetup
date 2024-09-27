import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesExample extends StatefulWidget {
  const SharedPreferencesExample({super.key});

  // İsim değiştirildi
  @override
  // ignore: library_private_types_in_public_api
  _SharedPreferencesExampleState createState() =>
      _SharedPreferencesExampleState();
}

class _SharedPreferencesExampleState extends State<SharedPreferencesExample> {
  final TextEditingController _controller = TextEditingController();
  String _savedText = "Henüz kaydedilmiş veri yok";

  @override
  void initState() {
    super.initState();
    _loadSavedText(); // Uygulama başladığında kaydedilen metni yükle
  }

  // Kaydedilen veriyi yükleme
  Future<void> _loadSavedText() async {
    final prefs =
        await SharedPreferences.getInstance(); // getInstance çağrısı doğru oldu
    setState(() {
      _savedText = prefs.getString('savedText') ?? "Henüz kaydedilmiş veri yok";
    });
  }

  // Veriyi kaydetme
  Future<void> _saveText() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('savedText', _controller.text);
    setState(() {
      _savedText = _controller.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shared Preferences Örneği'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Metin girin',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveText,
              child: const Text('Kaydet'),
            ),
            const SizedBox(height: 20),
            Text(
              'Kaydedilen Metin: $_savedText',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
