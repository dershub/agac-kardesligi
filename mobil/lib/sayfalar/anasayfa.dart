import 'package:agackardesligi/modeller/bitki.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';

import '../gerecler/resim_yollari.dart';
import '../ui/paylasim_sayfasi/paylasim_body/paylasim_arka_plan.dart';
import '../ui/paylasim_sayfasi/paylasim_ust/ust_bilgi.dart';
import '../ui/safe_arka.dart';
import '../kontrolculer/anasayfa_kontrolcu.dart';

class Anasayfa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AnasayfaKontrolcu anasayfaKontrolcu = Get.put(AnasayfaKontrolcu());
    anasayfaKontrolcu.bitkileriCek();

    return SafeArka(
      child: Scaffold(
        body: Center(
          child: ListView(
            children: [
              UstBilgi(),
              Obx(
                () {
                  return Column(
                    children: [
                      for (Bitki bitki in anasayfaKontrolcu.bitkiler)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: paylasimArkaPlan(
                            resim: paylasimResim(bitki.resimLinki),
                            altSatir: paylasimAltRow(
                              ekleyenID: bitki.ekleyen,
                              dikilen: bitki.evre,
                              begeniSayisi: 25,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
