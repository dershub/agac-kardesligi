
import 'package:flutter/material.dart';

import 'package:agackardesligi/gerecler/renkler.dart';

// 1- Container alt taraf arka planı
Widget contAltArkaPlan ({Widget child}){
  return Container(
      decoration: BoxDecoration(
      color: Renk.mintYesil,
      borderRadius: BorderRadius.circular(20)
  ),
  child: child);
}

//2- Container alt taraf 1 satır. diğer satırlar column içinde bu satırdan türetilecek.
Widget contAltRow(IconData icon, String text, Widget child) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Icon(icon, color: Renk.yaziKoyuYesil, size: 40,),
          ),
          Expanded(flex: 3,child: Text(text, style: TextStyle(fontSize: 20, color: Renk.yaziKoyuYesil, fontWeight: FontWeight.bold),)),
          Expanded(flex: 1,child: Center(child: child))
        ],
      ),
    );
  }


//1- Örnek Kullanım
/* contAltArkaPlan(
                child: Column(
                  children: [
                    contAltRow(Icons.watch_later_outlined, "Saat", Text("data",style: TextStyle(fontSize: 20, color: Renk.yaziKoyuYesil, fontWeight: FontWeight.bold))),
                    Divider(color: Colors.white,thickness: 3,),
                    contAltRow(Icons.add_alarm_outlined, "Uyarıss", Icon(Icons.check_circle,color: Renk.yaziKoyuYesil, size: 40,),),
                    Divider(color: Colors.white,thickness: 3,),
                    contAltRow(Icons.autorenew, "Tekrarla", Text("Haftalık",style: TextStyle(fontSize: 20, color: Renk.yaziKoyuYesil, fontWeight: FontWeight.bold)))

                  ],
                ),
              )*/

//2-ornek kullanım
/* child: Column(
     children: [
       contAltRow(Icons.watch_later_outlined, "Saat", Text("data",style: TextStyle(fontSize: 20, color: Renk.yaziKoyuYesil, fontWeight: FontWeight.bold))),
       Divider(color: Colors.white,thickness: 3,),
       contAltRow(Icons.add_alarm_outlined, "Uyarı", Icon(Icons.check_circle,color: Renk.yaziKoyuYesil, size: 40,),),
       Divider(color: Colors.white,thickness: 3,),
       contAltRow(Icons.autorenew, "Tekrarla", Text("Haftalık",style: TextStyle(fontSize: 20, color: Renk.yaziKoyuYesil, fontWeight: FontWeight.bold))),
],),*/

