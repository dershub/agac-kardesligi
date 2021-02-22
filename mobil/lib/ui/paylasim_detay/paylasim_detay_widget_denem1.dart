import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../gerecler/fonksionlar.dart';
import '../../modeller/bitki.dart';
import '../resim_ekle.dart';

class PaylasimDetayWidgetDeneme1 extends StatelessWidget {
  final Bitki bitki;

  const PaylasimDetayWidgetDeneme1({Key key, @required this.bitki})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return FutureBuilder<String>(
      future: checkImagePath(bitki.resimLinki),
      builder: (context, snapshot) {
        bool resimGeldi =
            snapshot.hasData && !snapshot.data.startsWith(':error:');

        return Container(
          child: Stack(
            children: [
              if (resimGeldi)
                AspectRatio(
                  aspectRatio: 1.5,
                  child: SizedBox(
                    width: width,
                    child: Image.file(
                      File(snapshot.data),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              Positioned(
                top: 28,
                left: 8,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: CircleAvatar(
                    backgroundColor: Colors.black26,
                    child: Icon(Icons.chevron_left),
                  ),
                ),
              ),
              SafeArea(
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return Scaffold(
                      backgroundColor: Color(0),
                      body: ListView(
                        physics: ClampingScrollPhysics(),
                        children: [
                          Stack(
                            children: [
                              SizedBox(
                                width: double.maxFinite,
                                height:
                                    (width - (height - constraints.maxHeight)) /
                                        1.55,
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
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  child: FutureBuilder<String>(
                                                    future: checkImagePath(
                                                        kullanici['photoUrl']),
                                                    builder:
                                                        (context, snapshot) {
                                                      bool resimGeldi = snapshot
                                                              .hasData &&
                                                          !snapshot.data
                                                              .startsWith(
                                                                  ':error:');

                                                      return resimGeldi
                                                          ? AspectRatio(
                                                              aspectRatio: 1,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        2.0),
                                                                child: ClipOval(
                                                                  child: Image
                                                                      .file(
                                                                    File(snapshot
                                                                        .data),
                                                                    fit: BoxFit
                                                                        .cover,
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
                                              borderRadius:
                                                  BorderRadius.circular(20),
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
                                                  zamanFarkiBul(
                                                      bitki.eklemeTarihi),
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
                          Container(
                            color: Colors.white,
                            height: height -
                                ((width - (height - constraints.maxHeight)) /
                                    1.43),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(),
                                  SizedBox(height: 8),
                                  Container(
                                    color: Colors.grey.shade200,
                                    child: Row(
                                      children: [
                                        Text("${bitki.eklemeTarihi}"
                                            .split(' ')
                                            .first),
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
                                  SizedBox(height: 8),
                                  Text(
                                    bitki.baslik,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(bitki.aciklama),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      "${bitki.begenenler.length} Beğenme",
                                    ),
                                  ),
                                  Spacer(),
                                  if (bitki.ekleyen ==
                                      FirebaseAuth.instance.currentUser.uid)
                                    Container(
                                      height: 100,
                                      color: Colors.white,
                                      padding: EdgeInsets.all(8),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            height: 84,
                                            child: ResimEkle(
                                                resimDegisti: (resim) {}),
                                          ),
                                          SizedBox(width: 4),
                                          Expanded(
                                            child: TextField(
                                              maxLines: 5,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText:
                                                    "Açıklama (isteğe bağlı)",
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 4),
                                          SizedBox(
                                            height: 84,
                                            child: IconButton(
                                              icon: Icon(Icons.send),
                                              onPressed: () {},
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
