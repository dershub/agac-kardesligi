import 'dart:io';

import 'package:flutter/material.dart';

import '../../gerecler/fonksionlar.dart';
import '../../gerecler/renkler.dart';
import '../../modeller/bitki.dart';

class Paylasim extends StatelessWidget {
  final Bitki bitki;

  const Paylasim({Key key, @required this.bitki}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Renk.mintYesil),
      child: Column(
        children: [
          FutureBuilder<String>(
            future: checkImagePath(bitki.resimLinki),
            builder: (context, snapshot) {
              bool resimGeldi =
                  snapshot.hasData && !snapshot.data.startsWith(':error:');

              return Container(
                margin: EdgeInsets.all(10),
                alignment: Alignment.bottomLeft,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Renk.koyuGri,
                  image: resimGeldi
                      ? DecorationImage(
                          image: FileImage(File(snapshot.data)),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: Center(
                    child: resimGeldi ? null : CircularProgressIndicator()),
              );
            },
          ),
          Padding(
            padding: EdgeInsets.only(top: 15, bottom: 15, right: 15),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: FutureBuilder<Map>(
                    future: checkUser(bitki.ekleyen),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return LinearProgressIndicator();
                      else {
                        Map kullanici = snapshot.data;

                        return Row(
                          children: [
                            Expanded(
                              child: CircleAvatar(
                                backgroundColor: Colors.amber,
                                child: FutureBuilder<String>(
                                  future: checkImagePath(kullanici['photoUrl']),
                                  builder: (context, snapshot) {
                                    bool resimGeldi = snapshot.hasData &&
                                        !snapshot.data.startsWith(':error:');

                                    return resimGeldi
                                        ? AspectRatio(
                                            aspectRatio: 1,
                                            child: ClipOval(
                                              child: Image.file(
                                                File(snapshot.data),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          )
                                        : CircularProgressIndicator();
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: RichText(
                                text: TextSpan(
                                  text: "${kullanici['displayName']}, ",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: bitki.evre,
                                      style: TextStyle(
                                        color: Renk.ustBilgiYesilYazi,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(text: " dikti."),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: Text(
                      "${bitki.begenenler.length}",
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: Renk.ustBilgiYesilYazi.withOpacity(0.8),
                      ),
                    ),
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Renk.ustBilgiYesilYazi,
                  child: Icon(
                    Icons.favorite,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Etiket extends StatelessWidget {
  final String etiket;

  const _Etiket({Key key, @required this.etiket}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Renk.koyuYesil),
      child: Text(
        etiket,
        style: TextStyle(fontSize: 14, color: Colors.white),
      ),
    );
  }
}
