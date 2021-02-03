
import 'package:flutter/material.dart';


Widget txtfield(){
  return Padding(
    padding: const EdgeInsets.only(left: 16.0, bottom: 12.0),
    child: TextField(
      //textfield içinde hinttext PADDING otomatik boşluk oluşuyor.
      //kaldırmak için main.dart a gidip aşağıdaki değişiklikleri yap.
      // theme: ThemeData(
      // inputDecorationTheme: InputDecorationTheme(
      //   isDense: true,
      //   contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),),
      textAlign: TextAlign.left,
      decoration: InputDecoration(
        hintText: 'Buraya adını yazınız.',
      ),

    ),
  );
}