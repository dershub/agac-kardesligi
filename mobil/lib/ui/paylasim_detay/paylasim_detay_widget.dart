import 'dart:io';

import 'package:flutter/material.dart';

import '../../gerecler/fonksionlar.dart';
import '../../modeller/bitki.dart';

class PaylasimDetayWidget extends StatelessWidget {
  final Bitki bitki;

  const PaylasimDetayWidget({Key key, @required this.bitki}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
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
                  aspectRatio: 5 / 9,
                  child: SizedBox(
                    width: double.maxFinite,
                    child: Image.file(
                      File(snapshot.data),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              SafeArea(
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return Scaffold(
                      backgroundColor: Color(0),
                      body: Column(
                        children: [
                          Stack(
                            children: [
                              SizedBox(
                                width: double.maxFinite,
                                height: (MediaQuery.of(context).size.width -
                                        (height - constraints.maxHeight)) *
                                    (5 / 9),
                              ),
                              Positioned(
                                top: 8,
                                left: 8,
                                child: InkWell(
                                  onTap: () => Navigator.pop(context),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.black26,
                                    child: Icon(Icons.chevron_left),
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
                          Expanded(
                            child: Container(
                              color: Colors.white,
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
