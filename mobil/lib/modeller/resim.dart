import 'package:cloud_firestore/cloud_firestore.dart';

class Resim {
  String link;
  DateTime tarih;
  List<String> begenenler;

  Resim.fromJson(Map<String, dynamic> jsonData) {
    this.link = jsonData['link'];
    this.tarih = (jsonData['tarih'] as Timestamp).toDate();
    this.begenenler = jsonData['begenenler'];
  }

  Map<String, dynamic> toJson() {
    return {
      "link": this.link,
      "tarih": this.tarih,
      "begenenler": this.begenenler,
    };
  }
}
