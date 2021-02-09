import 'package:agackardesligi/mainsayfa.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  // Widgetları ekrana getirmeye hazır olduğumuzdan emin oluyoruz
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter('weynehive');
  String yol = (await getApplicationDocumentsDirectory()).path;
  (await Hive.openBox('ayarlar')).put('yol', yol);
  (await Hive.openBox('mainsayfa')).put('aktifSayfa', 0);

  // Firebase ilklendirme
  await Firebase.initializeApp();

  runApp(Baslangic());
}

class Baslangic extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: FutureBuilder(
          future: Future.microtask(() async {
            if (FirebaseAuth.instance.currentUser == null)
              await FirebaseAuth.instance.signInAnonymously();
          }),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return MainSayfa(girisYapildiMi: true);
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
