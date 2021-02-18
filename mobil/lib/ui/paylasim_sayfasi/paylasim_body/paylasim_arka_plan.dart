import 'dart:io';

import 'package:agackardesligi/gerecler/fonksionlar.dart';
import 'package:agackardesligi/gerecler/renkler.dart';
import 'package:agackardesligi/modeller/bitki.dart';
import 'package:flutter/material.dart';

//1- Paylasim ArkaPlan Container
Widget paylasimArkaPlan({Widget resim, Widget altSatir}) {
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
Widget paylasimResim(String resimUrl) {
  return FutureBuilder<String>(
    future: checkImagePath(resimUrl),
    builder: (context, snapshot) {
      bool resimGeldi =
          snapshot.hasData && !snapshot.data.startsWith(':error:');

      return Container(
        margin: EdgeInsets.all(10),
        alignment: Alignment.bottomLeft,
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Renk.koyuGri,
          image: resimGeldi
              ? DecorationImage(
                  image: FileImage(File(snapshot.data)),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: Center(child: resimGeldi ? null : CircularProgressIndicator()),
      );
    },
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
Widget paylasimAltRow({Bitki bitki}) {
  return Padding(
    padding: EdgeInsets.only(top: 15, bottom: 15, right: 15),
    child: Row(
      children: [
        Expanded(
          flex: 2,
          child: FutureBuilder<Map>(
            future: checkUser(bitki.ekleyen),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return LinearProgressIndicator();
              else {
                Map kullanici = snapshot.data;

                return Row(
                  children: [
                    Expanded(
                      child: CircleAvatar(
                        backgroundColor: Colors.amber,
                        child: FutureBuilder<String>(
                          future: checkImagePath(kullanici['photoUrl']),
                          builder: (context, snapshot) {
                            bool resimGeldi = snapshot.hasData &&
                                !snapshot.data.startsWith(':error:');

                            return resimGeldi
                                ? AspectRatio(
                                    aspectRatio: 1,
                                    child: ClipOval(
                                      child: Image.file(
                                        File(snapshot.data),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                : CircularProgressIndicator();
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: RichText(
                        text: TextSpan(
                          text: "${kullanici['displayName']}, ",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                          children: <TextSpan>[
                            TextSpan(
                              text: bitki.evre,
                              style: TextStyle(
                                color: Renk.ustBilgiYesilYazi,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(text: " dikti."),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: Text(
              "${bitki.begenenler.length}",
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
