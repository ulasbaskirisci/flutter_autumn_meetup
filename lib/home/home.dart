import 'package:flutter/material.dart';
import 'package:flutter_ankara_1/date/date.dart';
import 'package:flutter_ankara_1/image_picker/image_picker.dart';
import 'package:flutter_ankara_1/main.dart';
import 'package:flutter_ankara_1/share_plus/share_plus.dart';
import 'package:flutter_ankara_1/share_plus/share_plus_camera.dart';
import 'package:flutter_ankara_1/shared_preferences/shared_preferences.dart';
import 'package:flutter_ankara_1/show_case/show_case.dart';
import 'package:flutter_ankara_1/show_case/show_case_two.dart';
import 'package:showcaseview/showcaseview.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            // Arka plan resmi
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/icons/background.jpg"),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            // Dikey olarak sıralanan butonlar
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ShowCaseWidget(
                              builder: (context) =>
                                  MyAppDnm(), // MyAppDnm() should be used as a widget, not a method
                            ),
                          ),
                        );
                      },
                      child: Text('Show Case 1'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 40,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ShowCaseWidget(
                              builder: (context) =>
                                  MyAppDnmTwo(), // MyAppDnm() should be used as a widget, not a method
                            ),
                          ),
                        );
                      },
                      child: Text('Show Case 2'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 40,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ImagePickerExample()));
                      },
                      child: Text('İmage Picker'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 40,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ShareExample()));
                      },
                      child: const Text('Share Plus'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 40,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SharePlusGallery()));
                      },
                      child: const Text('Share Plus Camera'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 40,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SharedPreferencesExample()));
                      },
                      child: const Text('Shared Preferences'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 40,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => DateFormatExample()));
                      },
                      child: const Text('Date Time'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 40,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
