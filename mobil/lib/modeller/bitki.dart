/* {
        'resimLinki': indirmeLinki,
        'baslik': _baslik,
        'aciklama': _aciklama,
        'eklemeTarihi': FieldValue.serverTimestamp(),
        'ismi': _isim,
        'evre': _evre,
        'ekleyen': FirebaseAuth.instance.currentUser.uid,
      } */

import 'package:flutter/material.dart';

class Bitki {
  String _resimLinki;
  String baslik;
  String aciklama;
  DateTime /* Timestamp */ eklemeTarihi;
  String ismi;
  String evre;
  String ekleyen;

  // kapsüllemenin 2 anahtar kavramı => set ve get

  set resimLinki(String link) {
    if (link.startsWith("https://"))
      _resimLinki = link;
    else
      print("resimlinkini değiştirmek için doğru bir link girin");
  }

  String get resimLinki {
    return _resimLinki.split('/').last;
  }

  // Default Constructor
  Bitki({
    @required String resimLinki,
    @required this.baslik,
    @required this.aciklama,
    @required this.eklemeTarihi,
    @required this.ismi,
    @required this.evre,
    @required this.ekleyen,
  }) {
    this.resimLinki = resimLinki;
  }
  /*  {
    this.resimLinki = resimLinki;
    this.baslik = baslik;
    this.aciklama = aciklama;
  } */

  // named constructor
  Bitki.fromMap(Map<String, dynamic> data) {
    this.aciklama = data['aciklama'];
    this.baslik = data['baslik'];
    this.eklemeTarihi = data['eklemeTarihi'];
    this.resimLinki = data['resimLinki'];
  }

  // named constructor
  Bitki.agactan({
    @required this.resimLinki,
    @required this.baslik,
    @required this.aciklama,
    @required this.eklemeTarihi,
    @required this.ismi,
    @required this.ekleyen,
  }) {
    this.evre = "Ağaç";
  }

  Map<String, dynamic> toMap() {
    return {
      'resimLinki': resimLinki,
      'baslik': baslik,
      'aciklama': aciklama,
      'eklemeTarihi': eklemeTarihi,
    };
  }
}
