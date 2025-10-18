import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

// Share Plus 12.0.0 ile gelişmiş paylaşım özelliklerini gösteren ana widget sınıfı
class SharePlusNewExample extends StatefulWidget {
  const SharePlusNewExample({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SharePlusNewExampleState createState() => _SharePlusNewExampleState();
}

class _SharePlusNewExampleState extends State<SharePlusNewExample> {
  // Seçilen resim dosyasını tutan değişken
  File? _selectedImage;

  // TextController - paylaşılacak metni yönetmek için
  final TextEditingController _textController = TextEditingController();

  // Paylaşım geçmişini tutan liste
  List<String> _shareHistory = [];

  @override
  void dispose() {
    // TextController'ı temizle (memory leak'i önlemek için)
    _textController.dispose();
    super.dispose();
  }

  // Resim seçme fonksiyonu - galeriden resim seçer
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  // Kameradan resim çekme fonksiyonu
  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  // Sadece metin paylaşımı yapan fonksiyon
  Future<void> _shareText() async {
    final String text = _textController.text.trim();

    if (text.isEmpty) {
      _showSnackBar('Lütfen paylaşmak için bir metin girin!', Colors.orange);
      return;
    }

    try {
      // Share.share ile metni paylaş
      await Share.share(text);
      _addToHistory(
          'Metin paylaşıldı: ${text.length > 50 ? '${text.substring(0, 50)}...' : text}');
    } catch (e) {
      _showSnackBar('Metin paylaşımında hata: $e', Colors.red);
    }
  }

  // Resim paylaşımı yapan fonksiyon
  Future<void> _shareImage() async {
    if (_selectedImage == null) {
      _showSnackBar('Lütfen önce bir resim seçin!', Colors.orange);
      return;
    }

    try {
      // XFile ile resim paylaş
      await Share.shareXFiles([XFile(_selectedImage!.path)]);
      _addToHistory(
          'Resim paylaşıldı: ${_selectedImage!.path.split('/').last}');
    } catch (e) {
      _showSnackBar('Resim paylaşımında hata: $e', Colors.red);
    }
  }

  // Metin ve resim birlikte paylaşımı yapan fonksiyon
  Future<void> _shareTextWithImage() async {
    if (_selectedImage == null) {
      _showSnackBar('Lütfen önce bir resim seçin!', Colors.orange);
      return;
    }

    final String text = _textController.text.trim();
    if (text.isEmpty) {
      _showSnackBar('Lütfen paylaşmak için bir metin girin!', Colors.orange);
      return;
    }

    try {
      // Hem resim hem de metin paylaş
      await Share.shareXFiles(
        [XFile(_selectedImage!.path)],
        text: text,
      );
      _addToHistory(
          'Resim + Metin paylaşıldı: ${text.length > 30 ? '${text.substring(0, 30)}...' : text}');
    } catch (e) {
      _showSnackBar('Resim ve metin paylaşımında hata: $e', Colors.red);
    }
  }

  // Birden fazla resim paylaşımı yapan fonksiyon
  Future<void> _shareMultipleImages() async {
    final picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();

    if (images.isEmpty) {
      _showSnackBar('Hiç resim seçilmedi!', Colors.orange);
      return;
    }

    try {
      // Birden fazla resmi paylaş
      await Share.shareXFiles(images);
      _addToHistory('${images.length} adet resim paylaşıldı');
    } catch (e) {
      _showSnackBar('Çoklu resim paylaşımında hata: $e', Colors.red);
    }
  }

  // URL paylaşımı yapan fonksiyon
  Future<void> _shareUrl() async {
    const String url = 'https://flutter.dev';
    const String subject = 'Flutter Framework';

    try {
      // URL'yi subject ile birlikte paylaş
      await Share.share(
        url,
        subject: subject,
      );
      _addToHistory('URL paylaşıldı: $url');
    } catch (e) {
      _showSnackBar('URL paylaşımında hata: $e', Colors.red);
    }
  }

  // Dosya paylaşımı yapan fonksiyon - örnek PDF oluşturur
  Future<void> _shareFile() async {
    try {
      // Geçici bir dosya oluştur
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/example.txt');

      // Dosyaya örnek içerik yaz
      await file.writeAsString(
          'Bu bir örnek dosyadır.\nShare Plus 12.0.0 ile paylaşıldı.\nTarih: ${DateTime.now()}');

      // Dosyayı paylaş
      await Share.shareXFiles([XFile(file.path)]);
      _addToHistory('Dosya paylaşıldı: example.txt');

      // Geçici dosyayı sil
      await file.delete();
    } catch (e) {
      _showSnackBar('Dosya paylaşımında hata: $e', Colors.red);
    }
  }

  // Gelişmiş paylaşım seçenekleri ile paylaşım yapan fonksiyon
  Future<void> _shareWithOptions() async {
    final String text = _textController.text.trim();

    if (text.isEmpty) {
      _showSnackBar('Lütfen paylaşmak için bir metin girin!', Colors.orange);
      return;
    }

    try {
      // Gelişmiş seçeneklerle paylaş
      await Share.share(
        text,
        subject: 'Flutter App\'ten Paylaşım',
        sharePositionOrigin:
            Rect.fromLTWH(0, 0, 100, 100), // Paylaşım menüsünün pozisyonu
      );
      _addToHistory('Gelişmiş seçeneklerle paylaşıldı');
    } catch (e) {
      _showSnackBar('Gelişmiş paylaşımda hata: $e', Colors.red);
    }
  }

  // Paylaşım geçmişine ekleme fonksiyonu
  void _addToHistory(String entry) {
    setState(() {
      _shareHistory.insert(
          0, '${DateTime.now().toString().substring(11, 19)} - $entry');
      // Geçmişi 15 öğe ile sınırla
      if (_shareHistory.length > 15) {
        _shareHistory.removeLast();
      }
    });
  }

  // SnackBar gösterme fonksiyonu
  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share Plus'),
        backgroundColor: Colors.green[600],
        foregroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.green[50]!,
              Colors.white,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Metin girişi bölümü
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Paylaşılacak Metin',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _textController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Paylaşmak istediğiniz metni buraya yazın...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              BorderSide(color: Colors.green[600]!, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Resim seçimi bölümü
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Resim Seçimi',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _pickImage,
                            icon: const Icon(Icons.photo_library),
                            label: const Text('Galeri'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[600],
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _takePhoto,
                            icon: const Icon(Icons.camera_alt),
                            label: const Text('Kamera'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple[600],
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_selectedImage != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            _selectedImage!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Paylaşım butonları
            Text(
              'Paylaşım Seçenekleri',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),

            // Paylaşım butonları grid
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.5,
                children: [
                  _buildShareButton(
                    'Metin Paylaş',
                    Icons.text_fields,
                    Colors.orange,
                    _shareText,
                  ),
                  _buildShareButton(
                    'Resim Paylaş',
                    Icons.image,
                    Colors.blue,
                    _shareImage,
                  ),
                  _buildShareButton(
                    'Resim + Metin',
                    Icons.perm_media,
                    Colors.purple,
                    _shareTextWithImage,
                  ),
                  _buildShareButton(
                    'Çoklu Resim',
                    Icons.photo_library_outlined,
                    Colors.teal,
                    _shareMultipleImages,
                  ),
                  _buildShareButton(
                    'URL Paylaş',
                    Icons.link,
                    Colors.indigo,
                    _shareUrl,
                  ),
                  _buildShareButton(
                    'Dosya Paylaş',
                    Icons.attach_file,
                    Colors.brown,
                    _shareFile,
                  ),
                  _buildShareButton(
                    'Gelişmiş Seçenekler',
                    Icons.settings,
                    Colors.red,
                    _shareWithOptions,
                  ),
                  _buildHistoryButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Paylaşım butonu oluşturan yardımcı fonksiyon
  Widget _buildShareButton(
      String title, IconData icon, Color color, VoidCallback onPressed) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [color, color.withOpacity(0.8)],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Geçmiş butonu oluşturan yardımcı fonksiyon
  Widget _buildHistoryButton() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showHistoryDialog(),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [Colors.grey[600]!, Colors.grey[500]!],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.history,
                size: 32,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              Text(
                'Geçmiş (${_shareHistory.length})',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Geçmiş dialog'unu gösteren fonksiyon
  void _showHistoryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Paylaşım Geçmişi'),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: _shareHistory.isEmpty
                ? const Center(
                    child: Text('Henüz paylaşım geçmişi yok'),
                  )
                : ListView.builder(
                    itemCount: _shareHistory.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.green[100],
                          child: Icon(
                            Icons.share,
                            color: Colors.green[600],
                            size: 20,
                          ),
                        ),
                        title: Text(
                          _shareHistory[index],
                          style: const TextStyle(fontSize: 12),
                        ),
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _shareHistory.clear();
                });
                Navigator.of(context).pop();
              },
              child: const Text('Temizle'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Kapat'),
            ),
          ],
        );
      },
    );
  }
}
