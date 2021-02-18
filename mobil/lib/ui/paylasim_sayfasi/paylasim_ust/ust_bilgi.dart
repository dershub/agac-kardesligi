import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../gerecler/renkler.dart';
import '../../../gerecler/resim_yollari.dart';
import '../../../kontrolculer/anasayfa_kontrolcu.dart';

class UstBilgi extends StatelessWidget {
  final int tohumSayi = 20;
  final int fidanSayi = 30;

  final AnasayfaKontrolcu anasayfaKontrolcu = Get.put(AnasayfaKontrolcu());

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Obx(() {
          return bilgiContainer(context, anasayfaKontrolcu.bitkiSayisi.value,
              "bitkimiz oldu", ResimYollari.tohumResim);
        }),
        bilgiContainer(context, anasayfaKontrolcu.kullaniciSayisi.value,
            "kullanıcımız oldu", ResimYollari.bitkiSeverResim),
      ]),
    );
  }

  Widget bilgiContainer(context, int sayi, String dikilen, resim) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width * 0.4,
      height: width * 0.3,
      decoration: BoxDecoration(
          color: Renk.mintYesil, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: RichText(
                text: TextSpan(
                  text: "Toplam ",
                  style: TextStyle(
                      color: Renk.ustBilgiYesilYazi,
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                  children: <TextSpan>[
                    TextSpan(
                      text: "$sayi",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(text: " $dikilen"),
                  ],
                ),
              ),
            ),
          ),
          Expanded(flex: 3, child: Image.asset(resim)),
        ],
      ),
    );
  }
}
