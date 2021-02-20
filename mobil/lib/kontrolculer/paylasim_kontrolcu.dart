import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../modeller/bitki.dart';

class PaylasimKontrolcu extends GetxController {
  RxInt begenmeSayisi = 0.obs;

  void begenmeSayisiniCek(Bitki b) {
    begenmeSayisi.value = b.begenenler.length ?? 0;
    print('Listeden gelen ${b.begenenler.length},  bitki id: ${b.id}');
  }

  bool begenmeSayisiGuncelleme(Bitki bitki) {
    bool durum;
    User user = FirebaseAuth.instance.currentUser;
    if (!user.isAnonymous) {
      String uid = user.uid;

      FieldValue fv;
      if (bitki.begenenler.contains(uid)) {
        fv = FieldValue.arrayRemove([uid]);

        bitki.begenenler.remove(uid);
      } else {
        fv = FieldValue.arrayUnion([uid]);

        bitki.begenenler.add(uid);
      }

      bitki.begenenler.add(uid);

      FirebaseFirestore.instance
          .collection('bitkiler')
          .doc(bitki.id)
          .update({'begenenler': fv});

      durum = true;
    } else
      durum = false;
    begenmeSayisiniCek(bitki);
    return durum;
  }
}
