import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'sayfalar/anasayfa.dart';

void main() async {
  // Widgetları ekrana getirmeye hazır olduğumuzdan emin oluyoruz
  WidgetsFlutterBinding.ensureInitialized();

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
              return Anasayfa();
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
