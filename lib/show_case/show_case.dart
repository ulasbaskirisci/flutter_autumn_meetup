import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:showcaseview/showcaseview.dart'; // Showcase paketini import ettik

class MyAppDnm extends StatelessWidget {
  const MyAppDnm({super.key});

  @override
  Widget build(BuildContext context) {
    // ShowCaseWidget kullanarak showcase başlatılıyor
    return ShowCaseWidget(
      builder: (context) => MaterialApp(
        title: 'Kişi Listesi',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const PersonListPage(), // Ana sayfa olarak PersonListPage seçildi
      ),
    );
  }
}

class PersonListPage extends StatefulWidget {
  const PersonListPage({super.key});

  @override
  // State sınıfı oluşturuluyor
  _PersonListPageState createState() => _PersonListPageState();
}

class _PersonListPageState extends State<PersonListPage> {
  // Kişi listesi oluşturuluyor
  final List<Person> _people = [
    Person(
      firstName: 'Ahmet',
      lastName: 'Yılmaz',
      avatarUrl: 'https://i.pravatar.cc/150?img=1',
      phone: '555-123-4567',
    ),
    Person(
      firstName: 'Mehmet',
      lastName: 'Kara',
      avatarUrl: 'https://i.pravatar.cc/150?img=2',
      phone: '555-987-6543',
    ),
    // Daha fazla kişi ekleyebilirsiniz
  ];

  // Showcase için benzersiz GlobalKey'ler tanımlanıyor
  final GlobalKey _listKey = GlobalKey();
  final GlobalKey _fabKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Sayfa yüklendikten hemen sonra Showcase başlatılıyor
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ShowCaseWidget.of(context).startShowCase([_fabKey, _listKey]),
    );
  }

  // Kişiyi silmek için kullanılan fonksiyon
  void _deletePerson(int index) {
    setState(() {
      _people.removeAt(index); // Belirtilen indeksteki kişiyi listeden siliyor
    });
  }

  // Kişiyi düzenlemek için kullanılan fonksiyon
  void _editPerson(int index) {
    // Düzenleme formu için bir dialog oluşturuluyor
    showDialog(
      context: context,
      builder: (context) {
        final firstNameController =
            TextEditingController(text: _people[index].firstName);
        final lastNameController =
            TextEditingController(text: _people[index].lastName);
        final phoneController =
            TextEditingController(text: _people[index].phone);

        return AlertDialog(
          title: Text('Kişiyi Düzenle'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: firstNameController, // İsim alanı
                  decoration: InputDecoration(labelText: 'İsim'),
                ),
                TextField(
                  controller: lastNameController, // Soyisim alanı
                  decoration: InputDecoration(labelText: 'Soyisim'),
                ),
                TextField(
                  controller: phoneController, // Cep Telefonu alanı
                  decoration: InputDecoration(labelText: 'Cep Telefonu'),
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
          ),
          actions: [
            // "Kaydet" butonuna tıklanıldığında kişi düzenlenir
            TextButton(
              onPressed: () {
                setState(() {
                  // Düzenlenmiş verilerle kişi güncellenir
                  _people[index] = Person(
                    firstName: firstNameController.text,
                    lastName: lastNameController.text,
                    avatarUrl: _people[index].avatarUrl,
                    phone: phoneController.text,
                  );
                });
                Navigator.of(context).pop(); // Dialog kapanır
              },
              child: Text('Kaydet'),
            ),
            // "İptal" butonuna tıklanıldığında dialog kapanır
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('İptal'),
            ),
          ],
        );
      },
    );
  }

  // Yeni kişi eklemek için kullanılan fonksiyon
  void _addPerson() {
    showDialog(
      context: context,
      builder: (context) {
        // Form kontrolcüleri
        final firstNameController = TextEditingController();
        final lastNameController = TextEditingController();
        final phoneController = TextEditingController();
        final avatarUrlController = TextEditingController(
            text: 'https://i.pravatar.cc/150?img=3'); // Varsayılan avatar

        return AlertDialog(
          title: Text('Yeni Kişi Ekle'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // İsim, soyisim, telefon ve avatar alanları
                TextField(
                  controller: firstNameController,
                  decoration: InputDecoration(labelText: 'İsim'),
                ),
                TextField(
                  controller: lastNameController,
                  decoration: InputDecoration(labelText: 'Soyisim'),
                ),
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(labelText: 'Cep Telefonu'),
                  keyboardType: TextInputType.phone,
                ),
                TextField(
                  controller: avatarUrlController,
                  decoration: InputDecoration(labelText: 'Avatar URL'),
                ),
              ],
            ),
          ),
          actions: [
            // "Ekle" butonuna tıklanıldığında kişi eklenir
            TextButton(
              onPressed: () {
                setState(() {
                  // Yeni kişi listeye eklenir
                  _people.add(
                    Person(
                      firstName: firstNameController.text,
                      lastName: lastNameController.text,
                      avatarUrl: avatarUrlController.text.isNotEmpty
                          ? avatarUrlController.text
                          : 'https://i.pravatar.cc/150?img=3', // Varsayılan resim
                      phone: phoneController.text,
                    ),
                  );
                });
                Navigator.of(context).pop(); // Dialog kapanır
              },
              child: Text('Ekle'),
            ),
            // "İptal" butonuna tıklanıldığında dialog kapanır
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('İptal'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kişi Listesi'), // Sayfa başlığı
      ),
      body: Showcase(
        key: _listKey, // ListKey, Showcase'de kullanılıyor
        description: 'Bu listede kişilerin bilgilerini görebilirsiniz.',
        child: ListView.builder(
          itemCount: _people.length, // Kişi sayısı kadar liste oluşturur
          itemBuilder: (context, index) {
            final person = _people[index];
            return Slidable(
              key: Key(person.phone),
              startActionPane: ActionPane(
                motion: const ScrollMotion(), // Slidable için animasyon
                children: [
                  SlidableAction(
                    onPressed: (_) => _editPerson(index), // Düzenle butonu
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    icon: Icons.edit,
                    label: 'Düzenle',
                  ),
                ],
              ),
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (_) => _deletePerson(index), // Sil butonu
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Sil',
                  ),
                ],
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage:
                      NetworkImage(person.avatarUrl), // Avatar resmi
                ),
                title:
                    Text('${person.firstName} ${person.lastName}'), // Kişi adı
                subtitle: Text(person.phone), // Telefon numarası
              ),
            );
          },
        ),
      ),
      floatingActionButton: Showcase(
        key: _fabKey, // FAB butonunda Showcase kullanılıyor
        description: 'Yeni kişi eklemek için bu butona tıklayın.',
        child: FloatingActionButton(
          onPressed: _addPerson, // Yeni kişi ekleme fonksiyonu
          tooltip: 'Yeni Kişi Ekle',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

// Kişi modelini tanımlıyoruz
class Person {
  String firstName;
  String lastName;
  String avatarUrl;
  String phone;

  Person({
    required this.firstName,
    required this.lastName,
    required this.avatarUrl,
    required this.phone,
  });
}
