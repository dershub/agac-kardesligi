/* {
        'resimLinki': indirmeLinki,
        'baslik': _baslik,
        'aciklama': _aciklama,
        'eklemeTarihi': FieldValue.serverTimestamp(),
        'isim': _isim,
        'evre': _evre,
        'ekleyen': FirebaseAuth.instance.currentUser.uid,
      } */

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../gerecler/listeler.dart';
import 'resim.dart';

class Bitki {
  String id;
  String resimLinki;
  String baslik;
  String aciklama;
  DateTime /* Timestamp */ eklemeTarihi;
  String isim;
  String evre;
  String ekleyen;
  List<Resim> resimler;
  List<String> begenenler;

  Bitki({
    @required this.id,
    @required this.resimLinki,
    @required this.baslik,
    @required this.aciklama,
    @required this.eklemeTarihi,
    @required this.isim,
    @required this.evre,
    @required this.ekleyen,
    @required this.resimler,
    @required this.begenenler,
  });

  /// Bu açıklama olarak görünür
  Bitki.yeni({
    this.baslik = "",
    this.aciklama = "",
    this.evre = "Tohum",
    this.resimler = const [],
    this.begenenler = const [],
  }) {
    this.isim = Liste.bitkiIsimleri.first;
    this.eklemeTarihi = DateTime.now();
    this.ekleyen = FirebaseAuth.instance.currentUser.uid;
  }

  Bitki.fromJson(Map<String, dynamic> jsonData, String id) {
    this.id = id;
    this.resimLinki = jsonData['resimLinki'];
    this.baslik = jsonData['baslik'];
    this.aciklama = jsonData['aciklama'];
    this.eklemeTarihi = (jsonData['eklemeTarihi'] as Timestamp).toDate();
    this.isim = jsonData['isim'];
    this.evre = jsonData['evre'];
    this.ekleyen = jsonData['ekleyen'];
    this.resimler = (jsonData['resimler'] ?? {})
        .values
        .toList()
        .cast<Map>()
        .map((e) => Resim.fromJson(e))
        .toList()
        .cast<Resim>();

    this.begenenler = (jsonData['begenenler'] ?? []).cast<String>();
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "resimLinki": this.resimLinki,
      "baslik": this.baslik,
      "aciklama": this.aciklama,
      "eklemeTarihi": this.eklemeTarihi,
      "isim": this.isim,
      "evre": this.evre,
      "ekleyen": this.ekleyen,
      "resimler": this.resimler.map((e) => e.toJson()).toList(),
      "begenenler": this.begenenler,
    };
  }
}
