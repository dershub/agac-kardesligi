import 'dart:io';


import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../gerecler/renkler.dart';
import '../ui/bitki_ekle/body_orta_bolum/cont_alt_taraf.dart';
import '../ui/bitki_ekle/body_ust_bolum/evre_secimi.dart';
import '../ui/safe_arka.dart';
import '../ui/ozel_appbar.dart';

class BitkiEkle extends StatefulWidget {
  @override
  _BitkiEkleState createState() => _BitkiEkleState();
}

class _BitkiEkleState extends State<BitkiEkle> {
  File _resim;
  Future<void> _resimSec() async {
    PickedFile secilenResim =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (secilenResim != null)
      _resim = File(secilenResim.path);
    else
      _resim = null;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArka(
      child: Scaffold(
        appBar: OzelAppBar(geriGelsinMi: true,),
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
