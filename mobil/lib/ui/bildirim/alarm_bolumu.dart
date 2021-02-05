

import 'package:flutter/material.dart';

import '../../ui/bitki_ekle/body_orta_bolum/cont_alt_taraf.dart';
import '../../gerecler/renkler.dart';

//TODO: mantığı tekrar gözden geçir.

class AlarmBolumu extends StatefulWidget {
  @override
  _AlarmBolumuState createState() => _AlarmBolumuState();
}

class _AlarmBolumuState extends State<AlarmBolumu> {
  bool _seciliMi=false;

  @override
  Widget build(BuildContext context) {
    if(_seciliMi==false){
      return widget1();
    }else{
      return ListView(
        children: [
          widget2(),
        ],
      );
    }
  }

  Container widget1() {
    return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: Renk.mintYesil,),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Icon(Icons.brightness_1, color: Renk.yesil99,size: 10),
        ),
        RichText(
          text: TextSpan(
            text: "Mısır",
            style: TextStyle(
              color: Renk.koyuYesil,
              fontWeight: FontWeight.bold,),
            children: <TextSpan>[
              TextSpan(
                  text: " bitkinizin",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,),),
              TextSpan(text: " alarmı", style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,),),

            ],
          ),
        ),
        Expanded(
          child: widgetSecenek(),
        )
      ],
    ),
  );
  }

  Widget widgetSecenek() {
    return SwitchListTile(value: _seciliMi, onChanged: (bool value){
            setState(() {
              _seciliMi=value;
            });
          });
  }

  Container widget2() {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Renk.mintYesil,),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Icon(Icons.brightness_1, color: Renk.yesil99,size: 10),
              ),
              RichText(
                text: TextSpan(
                  text: "Mısır",
                  style: TextStyle(
                    color: Renk.koyuYesil,
                    fontWeight: FontWeight.bold,),
                  children: <TextSpan>[
                    TextSpan(
                      text: " bitkinizin",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,),),
                    TextSpan(text: " alarmı", style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,),),

                  ],
                ),
              ),
              Expanded(
                child: widgetSecenek(),
              )
            ],
          ),
          Expanded(child:                       contAltArkaPlan(
            child: Column(
              children: [
                contAltRow(
                  Icons.watch_later_outlined,
                  "Saat",
                  Text(
                    "18:00",
                    style: TextStyle(
                      color: Renk.yaziKoyuYesil,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Divider(
                  color: Colors.white,
                  thickness: 3,
                ),
                contAltRow(
                  Icons.add_alarm_outlined,
                  "Uyarı",
                  Icon(
                    Icons.check_circle,
                    color: Renk.yaziKoyuYesil,
                  ),
                ),
                Divider(
                  color: Colors.white,
                  thickness: 3,
                ),
                contAltRow(
                  Icons.autorenew,
                  "Tekrarla",
                  Text(
                    "Haftalık",
                    style: TextStyle(
                      color: Renk.yaziKoyuYesil,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),)
        ],
      ),
    );
  }
}
