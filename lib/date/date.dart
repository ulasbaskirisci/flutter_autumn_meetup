import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateFormatExample extends StatelessWidget {
  // Örnek veri listesi
  final List<Map<String, dynamic>> data = [
    {'id': 1, 'date': '2024-09-10T14:48:00.000Z'},
    {'id': 2, 'date': '2024-09-15T09:30:00.000Z'},
    {'id': 3, 'date': '2024-08-20T20:15:00.000Z'},
    {'id': 4, 'date': '2024-07-25T16:00:00.000Z'},
  ];

// 1. ISO 8601 Formatı
// Bu fonksiyon, verilen bir ISO 8601 formatındaki tarih/zaman dizisini
// ('yyyy-MM-ddTHH:mm:ss.sssZ' gibi) alır ve 'yyyy-MM-ddTHH:mm:ss' formatına çevirir.
  String formatISO8601(String isoDate) {
    DateTime parsedDate = DateTime.parse(isoDate);
    return DateFormat('yyyy-MM-ddTHH:mm:ss').format(parsedDate);
  }

// 2. Sadece Ay ve Yıl Gösterimi
// Bu fonksiyon, verilen bir ISO 8601 tarihini alır ve sadece ay ve yıl
// formatında ('MMMM yyyy', örneğin: 'Eylül 2024') gösterir.
  String formatMonthYear(String isoDate) {
    DateTime parsedDate = DateTime.parse(isoDate);
    return DateFormat('MMMM yyyy').format(parsedDate);
  }

// 3. Yerel Formatlama (Türkçe)
// Bu fonksiyon, verilen bir ISO 8601 tarihini Türkçe yerel ayarları ile formatlar.
// Örnek çıktı: '10 Eylül 2024, Salı' şeklinde tarih ve gün ismiyle gösterir.
  String formatInTurkish(String isoDate) {
    DateTime parsedDate = DateTime.parse(isoDate);
    return DateFormat('dd MMMM yyyy, EEEE', 'tr')
        .format(parsedDate); // Örn: 10 Eylül 2024, Salı
  }

// 4. Saat ve Dakika ile Birlikte Detaylı Tarih Formatlama
// Bu fonksiyon, verilen bir ISO 8601 tarihini gün, ay, yıl, saat ve dakikayı içerecek
// şekilde ('dd MMM yyyy, HH:mm', örneğin: '10 Eyl 2024, 14:30') formatlar.
  String formatDetailed(String isoDate) {
    DateTime parsedDate = DateTime.parse(isoDate);
    return DateFormat('dd MMM yyyy, HH:mm').format(parsedDate);
  }

// 5. Tam Gün Adı ve Ay İsmi ile Formatlama
// Bu fonksiyon, verilen bir ISO 8601 tarihini tam gün adı, ay ismi ve günü içerecek şekilde
// ('EEEE, MMMM dd, yyyy', örneğin: 'Salı, Eylül 10, 2024') formatlar.
  String formatFullDayAndMonth(String isoDate) {
    DateTime parsedDate = DateTime.parse(isoDate);
    return DateFormat('EEEE, MMMM dd, yyyy').format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Çeşitli Tarih Formatları'),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          final item = data[index];
          return ListTile(
            title: Text("İtem ${item['id']}"),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ISO 8601: ${formatISO8601(item['date'])}'),
                Text('Sadece Ay ve Yıl: ${formatMonthYear(item['date'])}'),
                Text('Türkçe Format: ${formatInTurkish(item['date'])}'),
                Text('Detaylı Format: ${formatDetailed(item['date'])}'),
                Text(
                    'Tam Gün Adı ve Ay: ${formatFullDayAndMonth(item['date'])}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
