
import 'package:agackardesligi/gerecler/resim_yollari.dart';
import 'package:agackardesligi/ui/paylasim_sayfasi/paylasim_body/paylasim_arka_plan.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import '../ui/safe_arka.dart';
import '../gerecler/renkler.dart';

class BitkiEkle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArka(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0),
          title: CircleAvatar(
            backgroundColor: Color(0),
            child: Image.asset('assets/images/Logo.png'),
          ),
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: DottedBorder(
                        color: Colors.black26,
                        strokeWidth: 2,
                        borderType: BorderType.RRect,
                        radius: Radius.circular(18),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Renk.acikGri,
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      color: Colors.blueAccent,
                      child: Center(),
                    ),
                  ),
                ],
              ),
           ],
          ),
        ),
      ),
    );
  }
}