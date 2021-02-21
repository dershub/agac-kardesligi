import 'dart:io';

import 'package:agackardesligi/ui/resim_ekle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../gerecler/listeler.dart';
import '../gerecler/local_bildirim.dart';
import '../gerecler/renkler.dart';
import '../kontrolculer/bitki_ekle_kontrolcu.dart';
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

  TimeOfDay _hatirlaticiAn;

  final BitkiEkleKontrolcu _bitkiEkleKontrolcu = Get.put(BitkiEkleKontrolcu());

  void _evreSecimi(String gonderilenEvre) {
    _bitki.evre = gonderilenEvre;
    print("_evreSecimi");
    print(_bitki.evre);
  }

  Future<void> _bitkiyiPaylas() async {
    // await hatirlaticiEkle(_bitki, _hatirlaticiAn);
    // await hatirlaticiIptalEt(_bitki);
    _bitkiEkleKontrolcu.yuklenmeIslemiBasladiDegistir(true);

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
      Reference ref = FirebaseStorage.instance
          .ref('bitki-resimleri/' + _resim.path.split('/').last);
      UploadTask yuklemeGorevi = ref.putFile(_resim);
      yuklemeGorevi.snapshotEvents.listen((event) {
        switch (event.state) {
          case TaskState.running:
            _bitkiEkleKontrolcu.yuklemeOraniDegistir(
                yuklemeGorevi.snapshot.bytesTransferred /
                    yuklemeGorevi.snapshot.totalBytes);
            break;
          case TaskState.success:
            _bitkiEkleKontrolcu.yuklemeOraniDegistir(1);
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

      //TODO Daha sonra transaction olarak düzenlenecek
      await FirebaseFirestore.instance
          .collection('bitkiler')
          .add(_bitki.toJson());

      await FirebaseFirestore.instance
          .collection('genel-bilgiler')
          .doc('eklenen-bitkiler')
          .update({'toplam${_bitki.evre}Sayisi': FieldValue.increment(1)});

      if (_bitkiEkleKontrolcu.hatirlaticiAktif.isTrue)
        await hatirlaticiEkle(_bitki, _hatirlaticiAn);

      mesaj = "İşlem başarıyla gerçekleşti";
    }

    await Fluttertoast.showToast(
      msg: mesaj,
      timeInSecForIosWeb: 3,
      toastLength: Toast.LENGTH_LONG,
    );

    _bitkiEkleKontrolcu.yuklenmeIslemiBasladiDegistir(false);

    if (_bitkiEkleKontrolcu.yuklenmeOrani.value > 0.9)
      Navigator.of(context).pop();
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
                    child: ResimEkle(
                      resimDegisti: (resim) => _resim = resim,
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
                      child: Obx(() {
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
                                    value: _bitkiEkleKontrolcu
                                        .hatirlaticiAktif.value,
                                    onChanged: (v) {
                                      _bitkiEkleKontrolcu
                                          .hatirlaticiAktifDegistir(v);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            if (_bitkiEkleKontrolcu.hatirlaticiAktif.isTrue)
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
                                                    alwaysUse24HourFormat: true,
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
                      }),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              Obx(() {
                double yo = _bitkiEkleKontrolcu.yuklenmeOrani.value;
                if (yo == 0 || yo == 1)
                  return SizedBox();
                else
                  return Stack(
                    children: [
                      SizedBox(
                        height: 48,
                        child: LinearProgressIndicator(
                          value: yo,
                        ),
                      ),
                      Positioned.fill(
                        child: Center(
                          child: Text("%${(yo * 100).round()}"),
                        ),
                      ),
                    ],
                  );
              }),
              SizedBox(height: 12),
              Obx(() {
                if (_bitkiEkleKontrolcu.yuklenmeIslemiBasladi.isTrue)
                  return SizedBox();
                else
                  return paylasButonu(_bitkiyiPaylas);
              }),
              SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
