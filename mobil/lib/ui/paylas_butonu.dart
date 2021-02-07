import 'package:flutter/material.dart';
import '../gerecler/renkler.dart';

//İlgili yerler olmadığı için ekleme yaptım

//Butonumuz
Widget paylasButonu(Function onPressed) {
  return Container(
    alignment: Alignment.centerLeft,
    child: RaisedButton(
      color: Renk.yesil99,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
        side: BorderSide(color: Renk.yesil99, width: 5),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 16),
          child: Text(
            'Paylaş !',
            style: TextStyle(color: Colors.white, fontSize: 26),
          ),
        ),
      ),
      onPressed: onPressed,
    ),
  );
}
