import 'package:flutter/material.dart';

import 'package:agackardesligi/gerecler/renkler.dart';

//1-Icon seçili iken kullanılacak
Widget contIconGenis(String resimYolu, [String yazi]) {
  return Container(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Image.asset(resimYolu),
          if (yazi != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                yazi,
                style: TextStyle(
                  color: Renk.ustBilgiYesilYazi,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
    ),
    height: 50,
    decoration: BoxDecoration(
      color: yazi != null ? Renk.mintYesil : Renk.acikGri,
      borderRadius: BorderRadius.circular(16),
    ),
  );
}

//2-Icon seçili değilken kullanılacak
Widget contIconDar(String resimYolu) {
  return Container(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Image.asset(resimYolu),
    ),
    height: 50,
    decoration: BoxDecoration(
      color: Renk.mintYesil,
      borderRadius: BorderRadius.circular(16),
    ),
  );
}

//1-Örnek Kullanım
/*contIconGenis("assets/icon/resim.jpg", "Tohum")*/

//2-Örnek Kullanım
/*contIconDar("assets/icon/resim2.jpg")*/
