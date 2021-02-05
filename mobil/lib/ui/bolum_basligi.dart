
import 'package:flutter/material.dart';

import '../gerecler/renkler.dart';

class BolumBasligi extends StatelessWidget {
  final IconData iconAdi;
  final String bolumBasligi;

  const BolumBasligi({Key key, this.iconAdi, this.bolumBasligi}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(this.iconAdi, color: Renk.yesil99, size: 30),
        Text(this.bolumBasligi, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),)
      ],
    );
  }
}
