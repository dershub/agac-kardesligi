import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:hive_listener/hive_listener.dart';
import 'package:rxdart/rxdart.dart';

import 'gerecler/listeler.dart';
import 'gerecler/local_bildirim.dart';
import 'gerecler/renkler.dart';
import 'main.dart';
import 'sayfalar/anasayfa.dart';
import 'sayfalar/bitki_ekle.dart';
import 'sayfalar/giris_yap.dart';

final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

class MainSayfa extends StatefulWidget {
  final bool girisYapildiMi;

  const MainSayfa({Key key, @required this.girisYapildiMi}) : super(key: key);
  @override
  _MainSayfaState createState() => _MainSayfaState();
}

class _MainSayfaState extends State<MainSayfa> {
  int _seciliSayfa = 0;
  Box _mainSayfaBox = Hive.box('mainsayfa');
  _sayfaDegistir(int i) {
    _seciliSayfa = i;
    _mainSayfaBox.put('aktifSayfa', i);
    print(_seciliSayfa);
  }

  _sayfaGetir(int a) {
    switch (a) {
      case 0:
        return Anasayfa();
      case 1:
        return BitkiEkle();
      case 2:
        return Anasayfa();
      case 3:
        return GirisYap();
        break;
      default:
    }
    setState(() {});
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body)
              : null,
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                /* await Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        SecondPage(receivedNotification.payload),
                  ),
                ); */
              },
              child: const Text('Ok'),
            ),
          ],
        ),
      );
    });
  }

  void _requestPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    /* flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        ); */
  }

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _configureDidReceiveLocalNotificationSubject();
  }

  @override
  void dispose() {
    didReceiveLocalNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HiveListener(
        box: _mainSayfaBox,
        keys: ['aktifSayfa'],
        builder: (b) {
          return _sayfaGetir(b.get('aktifSayfa'));
        },
      ),
      bottomNavigationBar: widget.girisYapildiMi == true
          ? Container(
              decoration: BoxDecoration(
                color: Renk.beyaz,
              ),
              height: 70,
              child: Stack(
                children: [
                  HiveListener(
                      box: _mainSayfaBox,
                      builder: (box) {
                        print(box.get('aktifSayfa'));
                        return Container(
                          margin: EdgeInsets.only(left: 16, right: 16),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Renk.yesil99.withOpacity(0.5),
                                spreadRadius: 7,
                                blurRadius: 50,
                                offset:
                                    Offset(0, -5), // changes position of shadow
                              ),
                            ],
                            color: Renk.beyaz,
                            borderRadius: BorderRadius.circular(40.0),
                            border: Border.all(
                                color: Renk.griDA.withOpacity(0.3), width: 3),
                          ),
                          child: BottomNavigationBar(
                            showSelectedLabels: false,
                            showUnselectedLabels: false,
                            backgroundColor: Colors.transparent,
                            type: BottomNavigationBarType.fixed,
                            unselectedIconTheme:
                                IconThemeData(color: Renk.griDA, size: 25.0),
                            selectedIconTheme:
                                IconThemeData(color: Renk.yesil99, size: 30.0),
                            currentIndex:
                                box.get('aktifSayfa', defaultValue: 0),
                            elevation: 0.0,
                            onTap: (int i) {
                              _sayfaDegistir(i);
                              _sayfaGetir(i);
                            },
                            items: [
                              for (IconData m in Liste.bottomElemanlar)
                                BottomNavigationBarItem(
                                    backgroundColor: Renk.siyah,
                                    icon: Icon(m),
                                    label: ""),
                            ],
                          ),
                        );
                      }),
                  Align(
                    alignment: Alignment(0.0, -6.0),
                    child: Container(
                      height: 60.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Renk.yesil99,
                        boxShadow: [
                          BoxShadow(
                            color: Renk.yesil99.withOpacity(0.5),
                            spreadRadius: 7,
                            blurRadius: 10,
                            offset: Offset(0, 0), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Center(
                        child: IconButton(
                          color: Renk.beyaz,
                          icon: Icon(Icons.add),
                          iconSize: 30.0,
                          onPressed: () {
                            if (FirebaseAuth.instance.currentUser.isAnonymous)
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (c) => GirisYap(),
                                ),
                              );
                            else
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (c) => BitkiEkle(),
                                ),
                              );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Container(
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                color: Renk.beyaz,
                borderRadius: BorderRadius.circular(40.0),
                boxShadow: [
                  BoxShadow(
                    color: Renk.yesil99.withOpacity(0.5),
                    spreadRadius: 7,
                    blurRadius: 50,
                    offset: Offset(0, -5), // changes position of shadow
                  ),
                ],
              ),
              height: 70,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (c) => GirisYap()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(FontAwesomeIcons.userPlus, color: Renk.griAE),
                    SizedBox(width: 20.0),
                    Text(
                      "Giriş Yap",
                      style: TextStyle(color: Renk.griAE, fontSize: 20.0),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
