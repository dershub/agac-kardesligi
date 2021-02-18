import 'package:agackardesligi/modeller/bitki.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:path_provider/path_provider.dart';

import '../kontrolculer/anasayfa_kontrolcu.dart';
import '../ui/paylasim_sayfasi/paylasim_body/paylasim_arka_plan.dart';
import '../ui/paylasim_sayfasi/paylasim_ust/ust_bilgi.dart';
import '../ui/safe_arka.dart';

class Anasayfa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AnasayfaKontrolcu anasayfaKontrolcu = Get.put(AnasayfaKontrolcu());
    anasayfaKontrolcu.bitkileriCek();
    anasayfaKontrolcu.bilgileriCek();

    getApplicationDocumentsDirectory().then((value) => print(value));

    // /Users/ma/Library/Developer/CoreSimulator/Devices/5E091F87-72A0-46C6-92B2-AF418ECA3BBC/data/Containers/Data/Application/D75A774C-DE69-44B5-AB3C-80F7E019CA28/Documents/cached_images/ilgili_resim.jpg

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
                            altSatir: paylasimAltRow(bitki: bitki),
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
