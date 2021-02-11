
import 'package:flutter/material.dart';

import '../../modeller/bildirim.dart';
import '../../gerecler/renkler.dart';

class KisiselBildirim extends StatelessWidget {

 final BildirimListe _bildirimListe=BildirimListe();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _bildirimListe.getBildirimListe.length,
        itemBuilder: (ctx, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Container(padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Renk.mintYesil,),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(Icons.favorite, color: Renk.yesil99,),
                  ),
                  RichText(
                    text: TextSpan(
                      text: "Ektiğiniz ",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,),
                      children: <TextSpan>[
                        TextSpan(
                            text: _bildirimListe.getBildirimListe[index].ekilen,
                            style: TextStyle(
                              color: Renk.koyuYesil,
                              fontWeight: FontWeight.bold,)),
                        TextSpan(text: " ${_bildirimListe.getBildirimListe[index]
                            .begeniSayisi}",),
                        TextSpan(text: " kişi tarafından beğenildi."),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }
    );
  }
}
