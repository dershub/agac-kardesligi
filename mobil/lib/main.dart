import 'package:agackardesligi/mainsayfa.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function

const MethodChannel platform =
    MethodChannel('dexterx.dev/flutter_local_notifications_example');

class ReceivedNotification {
  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });

  final int id;
  final String title;
  final String body;
  final String payload;
}

String selectedNotificationPayload;

Future yerelBildirimOnAyarlariYap() async {
  final NotificationAppLaunchDetails notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    selectedNotificationPayload = notificationAppLaunchDetails.payload;
  }

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');

  /// Note: permissions aren't requested here just to demonstrate that can be
  /// done later
  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
          onDidReceiveLocalNotification:
              (int id, String title, String body, String payload) async {
            didReceiveLocalNotificationSubject.add(ReceivedNotification(
                id: id, title: title, body: body, payload: payload));
          });

  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }

    selectedNotificationPayload = payload;
  });
}

void main() async {
  // Widgetları ekrana getirmeye hazır olduğumuzdan emin oluyoruz

  await Hive.initFlutter('bitkihive');
  String yol = (await getApplicationDocumentsDirectory()).path;
  (await Hive.openBox('ayarlar')).put('yol', yol);
  (await Hive.openBox('mainsayfa')).put('aktifSayfa', 0);

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
