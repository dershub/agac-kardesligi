import 'dart:io';

import 'package:agackardesligi/modeller/bitki.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../gerecler/listeler.dart';
import '../gerecler/renkler.dart';
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
  File _resim;
  String _evre = "Tohum", _baslik, _aciklama, _isim = Liste.bitkiIsimleri.first;
  ValueNotifier<double> _yuklenmeOraniHabercisi = ValueNotifier<double>(0);
  ValueNotifier<bool> _yuklenmeIslemiBasladi = ValueNotifier<bool>(false);

  void _evreSecimi(String gonderilenEvre) {
    _evre = gonderilenEvre;
    print("_evreSecimi");
    print(_evre);
  }

  Future<void> _resimSec() async {
    PickedFile secilenResim =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (secilenResim != null)
      _resim = File(secilenResim.path);
    else
      _resim = null;

    setState(() {});
  }

  Future<void> _bitkiyiPaylas() async {
    _yuklenmeIslemiBasladi.value = true;
    String mesaj;
    if (_resim == null)
      mesaj = "Lütfen ekleyeceğiniz bitki için resim seçin!";
    else if ((_baslik ?? '').length < 10)
      mesaj =
          "Lütfen ekleyeceğiniz bitki için en az 20 karakter uzunluğunda bir başlık girin!";
    else if ((_aciklama ?? '').length < 20)
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
      String indirmeLinki = await ref.getDownloadURL();

      Bitki bitki = Bitki(baslik: _baslik, aciklama: _aciklama);
      bitki.resimLinki = "rastgele bir string";

      print(bitki.resimLinki);

      await FirebaseFirestore.instance
          .collection('bitkiler')
          .add(bitki.mapeCevir());

      // Veriyi firestore'dan almak için gelen veri tipini kullandığımız sınıfa dönüştürmek gerekiyor
      Map<String, dynamic> data /* = doc.data()  */;
      Bitki yeniBitki = Bitki.fromMap(bitki.toMap());

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
        appBar: OzelAppBar(
          geriGelsinMi: true,
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
                            onChanged: (yeniDeger) => _baslik = yeniDeger,
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
                    value: _isim,
                    items: Liste.bitkiIsimleri
                        .map((e) =>
                            DropdownMenuItem<String>(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (secilenEleman) =>
                        burayiYenile(() => _isim = secilenEleman),
                  );
                },
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
                          onChanged: (v) => _aciklama = v,
                          maxLines: 5,
                        ),
                      ),
                      Container(
                        height: 160,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Renk.mintYesil,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: Icon(Icons.brightness_1,
                                      color: Renk.yesil99, size: 10),
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: "Mısır",
                                    style: TextStyle(
                                      color: Renk.koyuYesil,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: " bitkinizin",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: " alarmı",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: SwitchListTile(
                                    value: true,
                                    onChanged: (bool value) {
                                      setState(() {
                                        //_seciliMi = value;
                                      });
                                    },
                                  ),
                                )
                              ],
                            ),
                            Expanded(
                              child: contAltArkaPlan(
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
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
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
