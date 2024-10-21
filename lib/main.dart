import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart'; // Yerel veriler için gerekli
import 'package:flutter_ankara_1/home/home.dart';

void main() async {
  // Türkçe yerel tarih formatlama verilerini başlatıyoruz
  await initializeDateFormatting('tr', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
