import 'package:agackardesligi/gerecler/listeler.dart';
import 'package:agackardesligi/gerecler/resim_yollari.dart';

class Kullanici {
  String ad, soyad, fotoUrl;
  int tohumSayisi, fidanSayisi, agacSayisi;

  Kullanici(this.ad, this.soyad, this.fotoUrl, this.tohumSayisi,
      this.fidanSayisi, this.agacSayisi);
}

class AktifKullanici {
  List<Kullanici> _aktifKullanici;

  AktifKullanici() {
    _aktifKullanici = [];

    _aktifKullanici
        .add(Kullanici("Eren", "Demir", ResimYollari.profil, 120, 24, 5));
    _aktifKullanici
        .add(Kullanici("Fatih", "Demir", ResimYollari.profil, 10, 2, 0));
  }

  List<Kullanici> get getAktifKullanici => _aktifKullanici;
}
