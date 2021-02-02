import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../ui/safe_arka.dart';
import 'bitki_ekle.dart';
import 'giris_yap.dart';

class Anasayfa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArka(
      child: Scaffold(
        body: Center(
          child: Text(FirebaseAuth.instance.currentUser.uid),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (FirebaseAuth.instance.currentUser.isAnonymous)
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => GirisYap(),
                ),
              );
            else
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => BitkiEkle(),
                ),
              );
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
