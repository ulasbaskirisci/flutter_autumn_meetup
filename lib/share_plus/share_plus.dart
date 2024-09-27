import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ShareExample extends StatelessWidget {
  // Metin Paylaşımı
  void _shareText(String text) {
    Share.share(text); // Paylaşılacak metni Share.share() ile paylaşıyoruz
  }

  @override
  Widget build(BuildContext context) {
    // Paylaşılacak metin
    String textToShare = 'Bu Flutter ile paylaşılan basit bir metin!';

    return Scaffold(
      appBar: AppBar(
        title: Text('Share Plus Örneği'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _shareText(textToShare); // Butona tıklanınca metni paylaşır
              },
              child: Text('Metin Paylaş'),
            ),
          ],
        ),
      ),
    );
  }
}
