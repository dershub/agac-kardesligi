import 'package:agackardesligi/modeller/kullanici.dart';
import 'package:flutter/material.dart';

import '../gerecler/resim_yollari.dart';
import '../ui/profil/profil_foto.dart';
import '../ui/profil/profil_icon_yazi_sayi.dart';
import '../ui/safe_arka.dart';
import '../ui/ozel_appbar.dart';

class ProfilSayfasi extends StatelessWidget {
  final AktifKullanici _aktifKullanici = AktifKullanici();

  @override
  Widget build(BuildContext context) {
    return SafeArka(
        child: Scaffold(
            appBar: OzelAppBar(),
            body: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                ProfilFoto(
                  fotoUrl: _aktifKullanici.getAktifKullanici[0].fotoUrl,
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${_aktifKullanici.getAktifKullanici[0].ad} ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${_aktifKullanici.getAktifKullanici[0].soyad} ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ProfilIconYaziSayi(ResimYollari.kucukTohumIcon, "Tohum",
                        _aktifKullanici.getAktifKullanici[0].tohumSayisi),
                    ProfilIconYaziSayi(ResimYollari.kucukFidanIcon, "Fidan",
                        _aktifKullanici.getAktifKullanici[0].fidanSayisi),
                    ProfilIconYaziSayi(ResimYollari.kucukAgacIcon, "Ağaç",
                        _aktifKullanici.getAktifKullanici[0].agacSayisi),
                  ],
                ),
                SizedBox(height: 30,),
                Text("Devam Edecek"),
              ],
            )));
  }
}
