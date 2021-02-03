import 'package:flutter/material.dart';

import '../../../gerecler/renkler.dart';
import '../../../gerecler/resim_yollari.dart';

class UstBilgi extends StatelessWidget {
  final int tohumSayi = 20;
  final int fidanSayi = 30;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        bilgiContainer(context, tohumSayi, "tohum", ResimYollari.tohumResim),
        bilgiContainer(
            context, fidanSayi, "fidan", ResimYollari.bitkiSeverResim),
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
                      text: "Bugün ",
                      style: TextStyle(
                          color: Renk.ustBilgiYesilYazi,
                          fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(
                            text: "$sayi",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                        TextSpan(text: " $dikilen Dikildi"),
                      ],
                    ),
                  ))),
          Expanded(flex: 3, child: Image.asset(resim)),
        ],
      ),
    );
  }
}
