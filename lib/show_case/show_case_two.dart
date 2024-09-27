import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class MyAppDnmTwo extends StatelessWidget {
  const MyAppDnmTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      builder: (context) => MaterialApp(
        title: 'Showcase Butonlar',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const ShowCasePageTwo(),
      ),
    );
  }
}

class ShowCasePageTwo extends StatefulWidget {
  const ShowCasePageTwo({super.key});

  @override
  _ShowCasePageTwoState createState() => _ShowCasePageTwoState();
}

class _ShowCasePageTwoState extends State<ShowCasePageTwo> {
  // Showcase için benzersiz GlobalKey'ler
  final GlobalKey _addButtonKey = GlobalKey();
  final GlobalKey _deleteButtonKey = GlobalKey();
  final GlobalKey _editButtonKey = GlobalKey();
  final GlobalKey _connectButtonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ShowCaseWidget.of(context).startShowCase([
        _addButtonKey,
        _deleteButtonKey,
        _editButtonKey,
        _connectButtonKey,
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Showcase Butonlar'),
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(16.0),
        crossAxisCount: 2, // Kare butonlar için 2 sütun kullanıyoruz
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        children: [
          Showcase(
            key: _addButtonKey,
            description: 'Yeni bir öğe eklemek için bu butona tıklayın.',
            child: ElevatedButton(
              onPressed: () {
                // Ekleme işlevi
                _showSnackBar(context, "Ekle butonuna tıklandı.");
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.add, size: 40),
                  SizedBox(height: 8),
                  Text("Ekle"),
                ],
              ),
            ),
          ),
          Showcase(
            key: _deleteButtonKey,
            description: 'Bir öğeyi silmek için bu butona tıklayın.',
            child: ElevatedButton(
              onPressed: () {
                // Silme işlevi
                _showSnackBar(context, "Sil butonuna tıklandı.");
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.delete, size: 40),
                  SizedBox(height: 8),
                  Text("Sil"),
                ],
              ),
            ),
          ),
          Showcase(
            key: _editButtonKey,
            description: 'Bir öğeyi düzenlemek için bu butona tıklayın.',
            child: ElevatedButton(
              onPressed: () {
                // Düzenleme işlevi
                _showSnackBar(context, "Düzenle butonuna tıklandı.");
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.edit, size: 40),
                  SizedBox(height: 8),
                  Text("Düzelt"),
                ],
              ),
            ),
          ),
          Showcase(
            key: _connectButtonKey,
            description: 'Bağlanmak için bu butona tıklayın.',
            child: ElevatedButton(
              onPressed: () {
                // Bağlanma işlevi
                _showSnackBar(context, "Bağlan butonuna tıklandı.");
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.link, size: 40),
                  SizedBox(height: 8),
                  Text("Bağlan"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
