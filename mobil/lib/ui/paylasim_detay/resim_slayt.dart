import 'dart:io';

import 'package:flutter/material.dart';

import '../../gerecler/fonksionlar.dart';
import '../../modeller/bitki.dart';

class ResimSlayt extends StatelessWidget {
  final Bitki bitki;

  const ResimSlayt({Key key, @required this.bitki}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Card(
              child: AspectRatio(
                aspectRatio: 1.5,
                child: SizedBox(
                  width: double.maxFinite,
                  child: FutureBuilder(
                    future: checkImagePath(bitki.resimLinki),
                    builder: (_, snapshot) {
                      bool resimGeldi = snapshot.hasData &&
                          !snapshot.data.startsWith(':error:');

                      if (resimGeldi)
                        return Image.file(
                          File(snapshot.data),
                          fit: BoxFit.cover,
                        );
                      return Center(
                        child: CircularProgressIndicator(),
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
          child: Row(
            children: [
              Text("${bitki.eklemeTarihi}".split(' ').first),
              Spacer(),
              IconButton(
                icon: Icon(
                  Icons.play_arrow_outlined,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
