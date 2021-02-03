import 'package:agackardesligi/gerecler/renkler.dart';
import 'package:flutter/material.dart';

//1- Paylasim ArkaPlan Container
Widget paylasimArkaPlan({Widget resim, altSatir}) {
  return Container(
    margin: EdgeInsets.only(left: 15, right: 15),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20), color: Renk.mintYesil),
    child: Column(
      children: [resim, altSatir],
    ),
  );
}

//2- Paylasim Resim Bölümü
Widget paylasimResim({Widget child}) {
  return Container(
    margin: EdgeInsets.all(10),
    alignment: Alignment.bottomLeft,
    height: 150,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20), color: Renk.koyuGri),
    child: child,
  );
}

//3- Paylasim Etiket
Widget paylasimEtiket({String etiket}) {
  return Container(
    margin: EdgeInsets.all(10),
    padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15), color: Renk.koyuYesil),
    child: Text(
      etiket,
      style: TextStyle(fontSize: 14, color: Colors.white),
    ),
  );
}

//4-Paylasim Alt Satır
Widget paylasimAltRow(
    {String photoUrl, kullaniciAdi, dikilen, int begeniSayisi}) {
  return Padding(
    padding: EdgeInsets.only(top: 15, bottom: 15, right: 15),
    child: Row(
      children: [
        Expanded(
          child: CircleAvatar(
            child: Image.asset(photoUrl),
          ),
        ),
        Expanded(
          flex: 2,
          child: RichText(
            text: TextSpan(
              text: "$kullaniciAdi, ",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              children: <TextSpan>[
                TextSpan(
                    text: dikilen,
                    style: TextStyle(
                        color: Renk.ustBilgiYesilYazi,
                        fontWeight: FontWeight.bold)),
                TextSpan(text: " dikti."),
              ],
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: Text(
              "$begeniSayisi",
              textAlign: TextAlign.end,
              style: TextStyle(
                color: Renk.ustBilgiYesilYazi.withOpacity(0.8),
              ),
            ),
          ),
        ),
        CircleAvatar(
          backgroundColor: Renk.ustBilgiYesilYazi,
          child: Icon(
            Icons.favorite,
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
}

//Örnet kullanım
/*   paylasimArkaPlan(
      resim: paylasimResim(),
      altSatir: paylasimAltRow(
          photoUrl: ResimYollari.tohumResim,
          kullaniciAdi: "Ahmet",
          dikilen: "tohum",
          begeniSayisi: 25)
      ),
*/
