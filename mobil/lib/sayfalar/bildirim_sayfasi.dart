
import 'package:agackardesligi/ui/bildirim/genel_bildirim.dart';
import 'package:flutter/material.dart';

import '../ui/safe_arka.dart';
import '../ui/bolum_basligi.dart';
import '../ui/bildirim/kisisel_bildirim.dart';
import '../ui/ozel_appbar.dart';
import '../ui/bildirim/alarm_bolumu.dart';

//TODO: modelde özel-genel bildirim alanı oluştur.
//bunları yeni listede zamana göre sıra.
//bu listeyi ui/bildirimler/bildirim_bolumundeki listview.builder'a gönder.
//TODO: daha önce yapılan bottomBar eklenecek.
class BildirimSayfasi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArka(
      child: Scaffold(
          appBar: OzelAppBar(geriGelsinMi: true,),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [

                BolumBasligi(iconAdi: Icons.notifications, bolumBasligi: "Bildirimler"),
                SizedBox(height: 20),
                GenelBildirim(),
                SizedBox(height: 20),
                Expanded(child: KisiselBildirim()),
                SizedBox(height: 20),
                BolumBasligi(iconAdi: Icons.access_time, bolumBasligi: "Alarmlar"),
                SizedBox(height: 20),
                Expanded(flex:2, child: Align(alignment: Alignment.topCenter,child: AlarmBolumu())),

              ],
            ),
          )),
    );
  }
}
