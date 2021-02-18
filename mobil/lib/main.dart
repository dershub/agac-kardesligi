import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'gerecler/local_bildirim.dart';
import 'mainsayfa.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  await Hive.initFlutter('bitkihive');
  // Widgetları ekrana getirmeye hazır olduğumuzdan emin oluyoruz
  tz.initializeTimeZones();
  // final String timeZoneName = await platform.invokeMethod('getTimeZoneName');
  tz.setLocalLocation(tz.getLocation("Europe/Istanbul"));

  String yol = (await getApplicationDocumentsDirectory()).path;
  (await Hive.openBox('ayarlar')).put('yol', yol);
  (await Hive.openBox('mainsayfa')).put('aktifSayfa', 0);
  await Hive.openBox('users');

  // Firebase ilklendirme
  await Firebase.initializeApp();

  await yerelBildirimOnAyarlariYap();

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
