import 'package:get/get.dart';

class BitkiEkleKontrolcu extends GetxController {
  RxDouble yuklenmeOrani = 0.0.obs;
  RxBool yuklenmeIslemiBasladi = false.obs;
  RxBool hatirlaticiAktif = false.obs;

  yuklemeOraniDegistir(double yo) {
    yuklenmeOrani.value = yo;
  }

  yuklenmeIslemiBasladiDegistir(bool yb) {
    yuklenmeIslemiBasladi.value = yb;
  }

  hatirlaticiAktifDegistir(bool hb) {
    hatirlaticiAktif.value = hb;
    print("hatirlaticiAktifDegistir");
    print(hb);
  }
}
