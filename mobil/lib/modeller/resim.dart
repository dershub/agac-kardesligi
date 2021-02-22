import 'package:cloud_firestore/cloud_firestore.dart';

class Resim {
  String link;
  String aciklama;
  DateTime tarih;

  Resim(this.link, this.aciklama, this.tarih);

  Resim.fromJson(Map<String, dynamic> jsonData) {
    this.link = jsonData['link'];
    this.aciklama = jsonData['aciklama'];
    this.tarih = (jsonData['tarih'] as Timestamp).toDate();
  }

  Map<String, dynamic> toJson() {
    return {
      "link": this.link,
      "tarih": this.tarih,
      "aciklama": this.aciklama,
    };
  }
}
