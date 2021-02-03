import 'package:flutter/material.dart';
import '../gerecler/renkler.dart';

//İlgili yerler olmadığı için ekleme yaptım
class Bitki{}
void bitkiPaylas(Bitki b){}

//Butonumuz
Widget paylasButonu(Bitki _bitki) {
  return Container(
    alignment: Alignment.centerLeft,
    child: RaisedButton(
        color: Renk.yesilYazi,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(color: Renk.acikYesil, width: 5)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal:40.0, vertical: 16),
          child: Text('Paylaş !',
              style: TextStyle(color: Colors.white, fontSize: 26)), 
        ),
        onPressed: () => bitkiPaylas(_bitki)),
  );
}
