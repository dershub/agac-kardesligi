import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../gerecler/fonksionlar.dart';
import '../../gerecler/renkler.dart';
import '../../modeller/bitki.dart';

class PaylasimWidget extends StatelessWidget {
  final Bitki bitki;

  const PaylasimWidget({Key key, @required this.bitki}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<int> bitkiDegisimHaberci =
        ValueNotifier<int>(bitki.begenenler.length);

    return Container(
      margin: EdgeInsets.only(left: 15, right: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Renk.mintYesil,
      ),
      child: Column(
        children: [
          FutureBuilder<String>(
            future: checkImagePath(bitki.resimLinki),
            builder: (context, snapshot) {
              bool resimGeldi =
                  snapshot.hasData && !snapshot.data.startsWith(':error:');

              return Stack(
                children: [
                  Container(
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
                      child: resimGeldi ? null : CircularProgressIndicator(),
                    ),
                  ),
                  Positioned(
                    left: 8,
                    bottom: 8,
                    child: Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Renk.koyuYesil,
                      ),
                      child: Text(
                        bitki.isim ?? "boş",
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                  ),
                ],
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
                                    fontWeight: FontWeight.bold,
                                  ),
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
                    child: ValueListenableBuilder<int>(
                      valueListenable: bitkiDegisimHaberci,
                      builder: (context, begenmeSayisi, w) {
                        print("bitki değişim oldu");
                        print(DateTime.now());
                        return Text(
                          "$begenmeSayisi",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: Renk.ustBilgiYesilYazi.withOpacity(0.8),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Renk.ustBilgiYesilYazi,
                  child: IconButton(
                    onPressed: () {
                      User user = FirebaseAuth.instance.currentUser;
                      if (!user.isAnonymous) {
                        String uid = user.uid;

                        FieldValue fv;
                        if (bitki.begenenler.contains(uid)) {
                          fv = FieldValue.arrayRemove(
                              [FirebaseAuth.instance.currentUser.uid]);

                          bitki.begenenler.remove(uid);
                        } else {
                          fv = FieldValue.arrayUnion(
                              [FirebaseAuth.instance.currentUser.uid]);

                          bitki.begenenler.add(uid);
                        }

                        bitkiDegisimHaberci.value = bitki.begenenler.length;

                        FirebaseFirestore.instance
                            .collection('bitkiler')
                            .doc(bitki.id)
                            .update({'begenenler': fv});
                      } else
                        Fluttertoast.showToast(
                            msg: "İşlem yapmak için lütfen giriş yapın!");
                    },
                    icon: Icon(
                      Icons.favorite,
                      color: Colors.white,
                    ),
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
