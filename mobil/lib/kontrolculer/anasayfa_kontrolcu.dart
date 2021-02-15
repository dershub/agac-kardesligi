import 'package:agackardesligi/modeller/bitki.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AnasayfaKontrolcu extends GetxController {
  RxList<Bitki> bitkiler = <Bitki>[].obs;

  Future<void> bitkileriCek() async {
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection('bitkiler')
        .orderBy('eklemeTarihi', descending: true)
        .limit(20)
        .get();

    bitkiler
        .assignAll(qs.docs.map((qds) => Bitki.fromJson(qds.data(), qds.id)));
  }
}
