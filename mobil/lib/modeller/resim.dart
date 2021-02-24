import 'package:cloud_firestore/cloud_firestore.dart';

class Resim {
  String link;
  String aciklama;
  DateTime tarih;
  List<String> sikayetler;

  Resim(this.link, this.aciklama, this.tarih, this.sikayetler);

  Resim.fromJson(Map<String, dynamic> jsonData) {
    this.link = jsonData['link'];
    this.aciklama = jsonData['aciklama'];
    this.tarih = (jsonData['tarih'] as Timestamp).toDate();
    this.sikayetler = (jsonData['sikayetler'] ?? []).cast<String>();
  }

  Map<String, dynamic> toJson() {
    return {
      "link": this.link,
      "tarih": this.tarih,
      "aciklama": this.aciklama,
      "sikayetler": this.sikayetler,
    };
  }
}
