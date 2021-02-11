import 'package:agackardesligi/gerecler/renkler.dart';
import 'package:flutter/material.dart';

class GenelBildirim extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Renk.genelBildirimAP,),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(Icons.favorite, color: Renk.genelBildirimIcon,),
          ),
          Text("21 Mart Orman Haftanız kutlu olsun.", style: TextStyle(fontWeight: FontWeight.bold),)
        ],
      ),
    );
  }
}
