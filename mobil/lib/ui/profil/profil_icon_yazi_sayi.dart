import 'package:flutter/material.dart';

import '../../gerecler/renkler.dart';

class ProfilIconYaziSayi extends StatelessWidget {
  final String iconResim;
  final String iconYazi;
  final int ekilenSayi;

  ProfilIconYaziSayi(this.iconResim, this.iconYazi, this.ekilenSayi);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Container(
                  width: width * 0.06, child: Image.asset(this.iconResim)),
            ),
            Text(
              this.iconYazi,
              style: TextStyle(
                color: Renk.yaziKoyuYesil,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          width: width * 0.25,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Renk.mintYesil,
              border: Border.all(
                width: 2,
                color: Renk.ustBilgiYesilYazi.withOpacity(0.1),
              )),
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text("${this.ekilenSayi}", style: TextStyle(
                color: Renk.ustBilgiYesilYazi,
                fontWeight: FontWeight.bold,
              ),),
            ),
          ),
        )
      ],
    );
  }
}
