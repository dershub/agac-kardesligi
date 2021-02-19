import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../modeller/bitki.dart';

class AnasayfaKontrolcu extends GetxController {
  RxList<Bitki> bitkiler = <Bitki>[].obs;
  RxInt bitkiSayisi = 0.obs;
  RxInt kullaniciSayisi = 0.obs;

  Future<void> bitkileriCek() async {
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection('bitkiler')
        .orderBy('eklemeTarihi', descending: true)
        .limit(20)
        .get();

    bitkiler
        .assignAll(qs.docs.map((qds) => Bitki.fromJson(qds.data(), qds.id)));
  }

  Future<void> bilgileriCek() async {
    CollectionReference cr =
        FirebaseFirestore.instance.collection('genel-bilgiler');

    DocumentSnapshot ds = await cr.doc('eklenen-bitkiler').get();

    bitkiSayisi.value = ds
        .data()
        .values
        .fold(0, (previousValue, element) => previousValue + element);

    DocumentSnapshot ds2 = await cr.doc('kullanici-sayilari').get();

    kullaniciSayisi.value = ds2
        .data()
        .values
        .fold(0, (previousValue, element) => previousValue + element);
  }
}
