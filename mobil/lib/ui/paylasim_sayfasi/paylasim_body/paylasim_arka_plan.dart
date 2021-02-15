import 'package:agackardesligi/gerecler/renkler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
Widget paylasimResim(resimUrl) {
  return Container(
    margin: EdgeInsets.all(10),
    alignment: Alignment.bottomLeft,
    height: 150,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: Renk.koyuGri,
      image: DecorationImage(
        image: NetworkImage(resimUrl),
        fit: BoxFit.cover,
      ),
    ),
    child: Center(),
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
Widget paylasimAltRow({String ekleyenID, String dikilen, int begeniSayisi}) {
  print("ekleyenID");
  print(ekleyenID);
  return Padding(
    padding: EdgeInsets.only(top: 15, bottom: 15, right: 15),
    child: Row(
      children: [
        Expanded(
          flex: 2,
          child: FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('kullanicilar')
                .doc(ekleyenID)
                .get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return LinearProgressIndicator();
              else {
                Map kullanici = snapshot.data.data() ??
                    {
                      'photoUrl':
                          "https://i.pinimg.com/originals/a9/61/55/a961559e319e9bdc6ceaf71de13aa596.jpg",
                      'displayName': "Anonym",
                    };
                return Row(
                  children: [
                    Expanded(
                      child: CircleAvatar(
                        child: Image.network(kullanici['photoUrl']),
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
                                text: dikilen,
                                style: TextStyle(
                                    color: Renk.ustBilgiYesilYazi,
                                    fontWeight: FontWeight.bold)),
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
