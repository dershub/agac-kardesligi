import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../gerecler/listeler.dart';
import '../gerecler/renkler.dart';
import '../main.dart';
import '../modeller/bitki.dart';
import '../ui/bitki_ekle/body_orta_bolum/cont_alt_taraf.dart';
import '../ui/bitki_ekle/body_ust_bolum/evre_secimi.dart';
import '../ui/ozel_appbar.dart';
import '../ui/paylas_butonu.dart';
import '../ui/safe_arka.dart';

class BitkiEkle extends StatefulWidget {
  @override
  _BitkiEkleState createState() => _BitkiEkleState();
}

class _BitkiEkleState extends State<BitkiEkle> {
  Bitki _bitki = Bitki.yeni();
  File _resim;
  ValueNotifier<double> _yuklenmeOraniHabercisi = ValueNotifier<double>(0);
  ValueNotifier<bool> _yuklenmeIslemiBasladi = ValueNotifier<bool>(false);
  ValueNotifier<bool> _hatirlaticiHabercisi = ValueNotifier<bool>(false);
  TimeOfDay _hatirlaticiAn;
  Set _hatirlaticiPeriyotlari = {"Aylik", "Haftalik", "Günlük"};

  AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'your other channel id',
    'your other channel name',
    'your other channel description',
    importance: Importance.max,
    priority: Priority.high,
  );

  IOSNotificationDetails iOSPlatformChannelSpecifics = IOSNotificationDetails();

  void _evreSecimi(String gonderilenEvre) {
    _bitki.evre = gonderilenEvre;
    print("_evreSecimi");
    print(_bitki.evre);
  }

  Future<void> _resimSec() async {
    PickedFile secilenResim =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (secilenResim != null)
      _resim = File(secilenResim.path);
    else
      _resim = null;

    await Future.delayed(Duration(seconds: 3));
    if (mounted) setState(() {});
  }

  Future<void> _hatirlaticiEkle() async {
    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    flutterLocalNotificationsPlugin
        //.zonedSchedule(id, title, body, scheduledDate, notificationDetails, uiLocalNotificationDateInterpretation: null, androidAllowWhileIdle: null)
        .periodicallyShow(
      123,
      "Resim Hatırlatıcı",
      "Bitkinize Resim Eklemeyi Hatırlatıyorum",
      RepeatInterval.daily,
      NotificationDetails(),
      payload: "gizli bilgiler",
    );
    DateTime simdi = DateTime.now();

    await flutterLocalNotificationsPlugin.zonedSchedule(
      123,
      "Resim Hatırlatıcı",
      "Bitkinize Resim Eklemeyi Hatırlatıyorum",
      tz.TZDateTime(
        tz.local,
        simdi.year,
        simdi.month,
        simdi.day,
        _hatirlaticiAn.hour,
        _hatirlaticiAn.minute,
      ),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  Future<void> _bitkiyiPaylas() async {
    _yuklenmeIslemiBasladi.value = true;
    String mesaj;
    if (_resim == null)
      mesaj = "Lütfen ekleyeceğiniz bitki için resim seçin!";
    else if (_bitki.baslik.length < 10)
      mesaj =
          "Lütfen ekleyeceğiniz bitki için en az 20 karakter uzunluğunda bir başlık girin!";
    else if (_bitki.aciklama.length < 20)
      mesaj =
          "Lütfen ekleyeceğiniz bitki için en az 40 karakter uzunluğunda bir açıklama girin!";
    else {
      Reference ref =
          FirebaseStorage.instance.ref('bitki-resimleri/bitkiresimi.jpg');
      UploadTask yuklemeGorevi = ref.putFile(_resim);
      yuklemeGorevi.snapshotEvents.listen((event) {
        switch (event.state) {
          case TaskState.running:
            _yuklenmeOraniHabercisi.value =
                yuklemeGorevi.snapshot.bytesTransferred /
                    yuklemeGorevi.snapshot.totalBytes;
            break;
          case TaskState.success:
            _yuklenmeOraniHabercisi.value = 1;
            break;
          case TaskState.error:
            Fluttertoast.showToast(
                msg: "Resim sunucuya yüklenirken hata oluştu");
            break;
          default:
        }
      });

      await yuklemeGorevi.whenComplete(() {});
      _bitki.resimLinki = await ref.getDownloadURL();

      print(_bitki.resimLinki);

      // Spread operatörü ile bitki map eklenmeTarihi key'ine tekrar atama yapılması
      await FirebaseFirestore.instance.collection('bitkiler').add(
          {..._bitki.toJson(), 'eklemeTarihi': FieldValue.serverTimestamp()});

      if (_hatirlaticiHabercisi.value) await _hatirlaticiEkle();

      mesaj = "İşlem başarıyla gerçekleşti";
    }

    await Fluttertoast.showToast(
      msg: mesaj,
      timeInSecForIosWeb: 3,
      toastLength: Toast.LENGTH_LONG,
    );

    _yuklenmeIslemiBasladi.value = false;
    if (_yuklenmeOraniHabercisi.value > 0.9) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArka(
      child: Scaffold(
        appBar: OzelAppBar(geriGelsinMi: true),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Stack(
                        children: [
                          DottedBorder(
                            color: Colors.black26,
                            strokeWidth: 2,
                            borderType: BorderType.RRect,
                            radius: Radius.circular(18),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Renk.acikGri,
                                borderRadius: BorderRadius.circular(18),
                                image: _resim == null
                                    ? null
                                    : DecorationImage(
                                        image: FileImage(_resim),
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              child: FlatButton(
                                onPressed: _resimSec,
                                child: Center(),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkWell(
                              onTap: _resimSec,
                              child: Icon(
                                Icons.add_circle,
                                color: Renk.yesil99,
                                size: 36,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    flex: 3,
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Buraya başlık giriniz",
                            ),
                            onChanged: (yeniDeger) => _bitki.baslik = yeniDeger,
                          ),
                          Expanded(
                            child: EvreSecimi(evreDegistir: _evreSecimi),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              StatefulBuilder(
                builder: (ctx, burayiYenile) {
                  return DropdownButton<String>(
                    value: _bitki.isim,
                    items: Liste.bitkiIsimleri
                        .map((e) =>
                            DropdownMenuItem<String>(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (secilenEleman) =>
                        burayiYenile(() => _bitki.isim = secilenEleman),
                  );
                },
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Renk.acikGri,
                  borderRadius: BorderRadius.circular(20),
                ),
                height: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Buraya açıklama giriniz",
                          hintStyle: TextStyle(color: Renk.koyuGri),
                          border: InputBorder.none,
                        ),
                        onChanged: (v) => _bitki.aciklama = v,
                        maxLines: 5,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Renk.mintYesil,
                      ),
                      child: ValueListenableBuilder<bool>(
                        valueListenable: _hatirlaticiHabercisi,
                        builder: (ctx, hatirlatici, w) {
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    // • bullet symbol => madde işareti
                                    child: Icon(
                                      Icons.brightness_1,
                                      color: Renk.yesil99,
                                      size: 10,
                                    ),
                                  ),
                                  Text("Resim ekleme hatırlatıcısı"),
                                  Expanded(
                                    child: SwitchListTile(
                                      value: hatirlatici,
                                      onChanged: (v) {
                                        _hatirlaticiHabercisi.value = v;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              if (hatirlatici)
                                IntrinsicHeight(
                                  child: contAltArkaPlan(
                                    child: Column(
                                      children: [
                                        contAltRow(
                                          Icons.watch_later_outlined,
                                          "Saat",
                                          InkWell(
                                            onTap: () {
                                              showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.now(),
                                                builder: (BuildContext context,
                                                    Widget child) {
                                                  return MediaQuery(
                                                    data: MediaQuery.of(context)
                                                        .copyWith(
                                                      alwaysUse24HourFormat:
                                                          true,
                                                    ),
                                                    child: child,
                                                  );
                                                },
                                              ).then((value) => setState(() {
                                                    _hatirlaticiAn = value;
                                                  }));
                                            },
                                            child: Text(
                                              "${_hatirlaticiAn == null ? 'Seçiniz' : _hatirlaticiAn.format(context)}",
                                              style: TextStyle(
                                                color: Renk.yaziKoyuYesil,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Divider(
                                          color: Colors.white,
                                          thickness: 3,
                                        ),
                                        contAltRow(
                                          Icons.autorenew,
                                          "Tekrarla",
                                          Text(
                                            "Günlük",
                                            style: TextStyle(
                                              color: Renk.yaziKoyuYesil,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              ValueListenableBuilder<double>(
                valueListenable: _yuklenmeOraniHabercisi,
                builder: (ctx, yuklenmeOrani, w) {
                  if (yuklenmeOrani == 0 || yuklenmeOrani == 1)
                    return SizedBox();
                  else
                    return Stack(
                      children: [
                        SizedBox(
                          height: 48,
                          child: LinearProgressIndicator(
                            value: yuklenmeOrani,
                          ),
                        ),
                        Positioned.fill(
                          child: Center(
                            child: Text("%${(yuklenmeOrani * 100).round()}"),
                          ),
                        ),
                      ],
                    );
                },
              ),
              SizedBox(height: 12),
              ValueListenableBuilder<bool>(
                valueListenable: _yuklenmeIslemiBasladi,
                builder: (ctx, yuklenmeBasladi, w) {
                  if (yuklenmeBasladi)
                    return SizedBox();
                  else
                    return paylasButonu(_bitkiyiPaylas);
                },
              ),
              SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
