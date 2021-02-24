import 'dart:io';
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../gerecler/fonksionlar.dart';
import '../../modeller/bitki.dart';

class ResimSlayt extends StatelessWidget {
  final Bitki bitki;

  const ResimSlayt({Key key, @required this.bitki}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> resimler = [
      bitki.resimLinki,
      ...bitki.resimler
          .where((e) => (e.sikayetler ?? []).length < 3)
          .map((e) => e.link)
    ];

    final List<String> tarihler = [
      "${bitki.eklemeTarihi}".split(' ').first,
      ...bitki.resimler
          .where((e) => (e.sikayetler ?? []).length < 3)
          .map((e) => "${e.tarih}".split(' ').first)
    ];

    final ValueNotifier<int> resimIndexHaberci = ValueNotifier<int>(0);

    return Column(
      children: [
        Stack(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: AspectRatio(
                aspectRatio: 1.5,
                child: SizedBox(
                  width: double.maxFinite,
                  child: ValueListenableBuilder<int>(
                    valueListenable: resimIndexHaberci,
                    builder: (_, resimIndex, __) {
                      return FutureBuilder(
                        future: checkImagePath(resimler[resimIndex]),
                        builder: (_, snapshot) {
                          bool resimGeldi = snapshot.hasData &&
                              !snapshot.data.startsWith(':error:');

                          if (resimGeldi)
                            return Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: FileImage(File(snapshot.data)),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(),
                            );
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: FutureBuilder<Map>(
                future: checkUser(bitki.ekleyen),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return LinearProgressIndicator();
                  else {
                    Map kullanici = snapshot.data;

                    return Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                child: FutureBuilder<String>(
                                  future: checkImagePath(kullanici['photoUrl']),
                                  builder: (context, snapshot) {
                                    bool resimGeldi = snapshot.hasData &&
                                        !snapshot.data.startsWith(':error:');

                                    return resimGeldi
                                        ? AspectRatio(
                                            aspectRatio: 1,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: ClipOval(
                                                child: Image.file(
                                                  File(snapshot.data),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          )
                                        : CircularProgressIndicator();
                                  },
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                "${kullanici['displayName']}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8),
                        Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.all(6),
                          child: Row(
                            children: [
                              Icon(
                                Icons.alarm,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8),
                              Text(
                                zamanFarkiBul(bitki.eklemeTarihi),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Container(
          color: Colors.grey.shade200,
          child: SizedBox(
            height: 60,
            child: Row(
              children: [
                IconButton(
                  iconSize: 48,
                  icon: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(math.pi),
                    child: Icon(
                      Icons.next_plan,
                    ),
                  ),
                  onPressed: () {
                    if (resimIndexHaberci.value > 0) resimIndexHaberci.value--;
                  },
                ),
                Spacer(),
                ValueListenableBuilder<int>(
                  valueListenable: resimIndexHaberci,
                  builder: (_, resimIndex, __) {
                    String uid = FirebaseAuth.instance.currentUser.uid;

                    bool sikayetEdildi =
                        bitki.resimler[resimIndex].sikayetler.contains(uid);

                    return Column(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(tarihler[resimIndex]),
                          ),
                        ),
                        if (!sikayetEdildi)
                          SizedBox(
                            height: 20,
                            child: TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (c) => AlertDialog(
                                    title: Text("Şikayet Uyarısı"),
                                    content: Text(
                                        "Resmi şikayet etmek istediğinizden emin misiniz?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("Vazgeç"),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          bitki.resimler[resimIndex + 1]
                                              .sikayetler
                                              .add(uid);

                                          await FirebaseFirestore.instance
                                              .collection('bitkiler')
                                              .doc(bitki.id)
                                              .update(bitki.toJson());

                                          Fluttertoast.showToast(
                                              msg:
                                                  "Şikayetiniz ulaştı, katkınızdan dolayı teşekkür ederiz!");
                                          Navigator.pop(context);
                                        },
                                        child: Text("Şikayet Et"),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Text("şikayet et"),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  vertical: 0,
                                  horizontal: 0,
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                Spacer(),
                IconButton(
                  iconSize: 48,
                  icon: Icon(Icons.next_plan),
                  onPressed: () {
                    if (resimIndexHaberci.value < resimler.length - 1)
                      resimIndexHaberci.value++;
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
