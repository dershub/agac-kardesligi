import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import '../gerecler/renkler.dart';
import '../ui/bitki_ekle/body_orta_bolum/cont_alt_taraf.dart';
import '../ui/bitki_ekle/body_ust_bolum/evre_secimi.dart';
import '../ui/safe_arka.dart';

class BitkiEkle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArka(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0),
          title: CircleAvatar(
            backgroundColor: Color(0),
            child: Image.asset('assets/images/Logo.png'),
          ),
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
          /* actions: [
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () async {
                if ((await GoogleSignIn().isSignedIn())) {
                  await GoogleSignIn().signOut();
                  await GoogleSignIn().disconnect();
                }
                await FirebaseAuth.instance.signOut();
              },
            ),
          ], */
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: DottedBorder(
                        color: Colors.black26,
                        strokeWidth: 2,
                        borderType: BorderType.RRect,
                        radius: Radius.circular(18),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Renk.acikGri,
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
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
                              hintText: "Buraya adını giriniz",
                            ),
                          ),
                          StatefulBuilder(builder: (ctx, setstate) {
                            return Expanded(
                              child: EvreSecimi(),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Renk.acikGri,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Buraya açıklama giriniz",
                            hintStyle: TextStyle(color: Renk.koyuGri),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      contAltArkaPlan(
                        child: Column(
                          children: [
                            contAltRow(
                              Icons.watch_later_outlined,
                              "Saat",
                              Text(
                                "18:00",
                                style: TextStyle(
                                  color: Renk.yaziKoyuYesil,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Divider(
                              color: Colors.white,
                              thickness: 3,
                            ),
                            contAltRow(
                              Icons.add_alarm_outlined,
                              "Uyarı",
                              Icon(
                                Icons.check_circle,
                                color: Renk.yaziKoyuYesil,
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
                                "Haftalık",
                                style: TextStyle(
                                  color: Renk.yaziKoyuYesil,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              RaisedButton(
                onPressed: () {},
                child: Text("Paylaş"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
