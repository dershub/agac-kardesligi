import 'dart:io';

import 'package:agackardesligi/modeller/resim.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../modeller/bitki.dart';
import '../../ui/resim_ekle.dart';
import 'resim_slayt.dart';

class PaylasimDetayWidget extends StatelessWidget {
  final Bitki bitki;

  PaylasimDetayWidget({Key key, @required this.bitki}) : super(key: key);

  final ValueNotifier<File> _resimHaberci = ValueNotifier<File>(null);
  final ValueNotifier<double> _yuklemeOraniHaberci = ValueNotifier<double>(0);
  final ValueNotifier<String> _aciklamaHaberci = ValueNotifier<String>("");

  Future<void> _resimEkle() async {
    String mesaj;
    if (_resimHaberci.value == null)
      mesaj = "Lütfen bitkiye eklemek için resim seçin!";
    else {
      Reference ref = FirebaseStorage.instance
          .ref('bitki-resimleri/' + _resimHaberci.value.path.split('/').last);

      UploadTask yuklemeGorevi = ref.putFile(_resimHaberci.value);

      yuklemeGorevi.snapshotEvents.listen((event) {
        switch (event.state) {
          case TaskState.running:
            _yuklemeOraniHaberci.value =
                yuklemeGorevi.snapshot.bytesTransferred /
                    yuklemeGorevi.snapshot.totalBytes;
            break;

          case TaskState.error:
            Fluttertoast.showToast(
                msg: "Resim sunucuya yüklenirken hata oluştu");
            break;
          default:
        }
      });

      await yuklemeGorevi.whenComplete(() {});
      String resimLinki = await ref.getDownloadURL();

      Resim resim = Resim(resimLinki, _aciklamaHaberci.value, DateTime.now());

      bitki.resimler.add(resim);

      await FirebaseFirestore.instance
          .collection('bitkiler')
          .doc(bitki.id)
          .update(bitki.toJson());

      mesaj = "İşlem başarıyla gerçekleşti";
    }

    await Fluttertoast.showToast(
      msg: mesaj,
      timeInSecForIosWeb: 3,
      toastLength: Toast.LENGTH_LONG,
    );

    _yuklemeOraniHaberci.value = 1;
  }

  @override
  Widget build(BuildContext context) {
    final bool bitkiSahibi =
        bitki.ekleyen == FirebaseAuth.instance.currentUser.uid;

    /* final bool bugunResimEklendi =
        "${bitki.resimler.last.tarih}".split(' ').first ==
            "${DateTime.now()}".split(' ').first; */

    final bool son24Saat =
        DateTime.now().difference(bitki.resimler.last.tarih).inHours > 24;

    return Container(
      color: Colors.white38,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(bitki.baslik),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                ResimSlayt(bitki: bitki),
                SizedBox(height: 8),
                Text(
                  bitki.baslik,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 8),
                Text(bitki.aciklama),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "${bitki.begenenler.length} Beğenme",
                  ),
                ),
                if (bitkiSahibi && !son24Saat)
                  Text(
                      "son 24 saatte resim eklediğiniz için teşekkür ederiz ${DateTime.now().difference(bitki.resimler.last.tarih).inHours}"),
                if (bitkiSahibi && son24Saat)
                  Container(
                    height: 100,
                    color: Colors.white,
                    padding: EdgeInsets.all(8),
                    alignment: Alignment.center,
                    child: ValueListenableBuilder<double>(
                        valueListenable: _yuklemeOraniHaberci,
                        builder: (_, yuklemeOrani, __) {
                          if (yuklemeOrani > 0 && yuklemeOrani < 1)
                            return CircularProgressIndicator(
                              value: yuklemeOrani != 1 ? yuklemeOrani : null,
                            );
                          else
                            return Row(
                              children: [
                                SizedBox(
                                  height: 84,
                                  child: ResimEkle(
                                    resimDegisti: (resim) =>
                                        _resimHaberci.value = resim,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Expanded(
                                  child: TextField(
                                    maxLines: 5,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: "Açıklama (isteğe bağlı)",
                                    ),
                                    onChanged: (d) =>
                                        _aciklamaHaberci.value = d,
                                  ),
                                ),
                                SizedBox(width: 4),
                                SizedBox(
                                  height: 84,
                                  child: Center(
                                    child: ClipOval(
                                      child: Card(
                                        margin: EdgeInsets.zero,
                                        child: IconButton(
                                          icon: Icon(Icons.send),
                                          onPressed: _resimEkle,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                        }),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
