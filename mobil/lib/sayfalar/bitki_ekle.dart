import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../ui/safe_arka.dart';

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
          /* actions: [
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () async {
                if ((await GoogleSignIn().isSignedIn())) {
                  await GoogleSignIn().signOut();
                  await GoogleSignIn().disconnect();
                }
                await FirebaseAuth.instance.signOut();
              },
            ),
          ], */
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
                            color: Color(0xFFECECEC),
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
