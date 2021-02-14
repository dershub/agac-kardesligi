import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../main.dart';
import '../mainsayfa.dart';
import '../modeller/bitki.dart';
import 'fonksionlar.dart';

const MethodChannel platform = MethodChannel('com.dershub.agackardesligi');

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

Future<void> hatirlaticiIptalEt(Bitki bitki) async {
  await flutterLocalNotificationsPlugin
      .cancel(dateTimeToIntId(bitki.eklemeTarihi));
}

Future<void> hatirlaticiEkle(Bitki bitki, TimeOfDay _hatirlaticiAn) async {
  AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'your other channel id',
    'your other channel name',
    'your other channel description',
    importance: Importance.max,
    priority: Priority.high,
  );

  IOSNotificationDetails iOSPlatformChannelSpecifics = IOSNotificationDetails();
  NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: iOSPlatformChannelSpecifics,
  );

  await flutterLocalNotificationsPlugin.zonedSchedule(
    dateTimeToIntId(bitki.eklemeTarihi),
    "Resim Hatırlatıcı",
    "Bitkinize Resim Eklemeyi Hatırlatıyorum",
    tz.TZDateTime(
      tz.local,
      bitki.eklemeTarihi.year,
      bitki.eklemeTarihi.month,
      bitki.eklemeTarihi.day,
      _hatirlaticiAn.hour,
      _hatirlaticiAn.minute,
    ),
    platformChannelSpecifics,
    payload: "resim-ekle-sayfasina-git",
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
  );
}
