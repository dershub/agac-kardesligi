import 'package:auth_buttons/auth_buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Relative (göreceli) path
import '../gerecler/renkler.dart';
import '../ui/safe_arka.dart';

class GirisYap extends StatefulWidget {
  @override
  _GirisYapState createState() => _GirisYapState();
}

class _GirisYapState extends State<GirisYap> {
  GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _googleIleGirisYap() async {
    try {
      if ((await GoogleSignIn().isSignedIn())) {
        await GoogleSignIn().signOut();
        await GoogleSignIn().disconnect();
      }
      final GoogleSignInAccount googleHesabi = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleDogrulama =
          await googleHesabi.authentication;

      // Create a new credential
      final GoogleAuthCredential kimlikBilgileri =
          GoogleAuthProvider.credential(
        accessToken: googleDogrulama.accessToken,
        idToken: googleDogrulama.idToken,
      );

      try {
        // Anonim hesaptan çıkış yap
        await FirebaseAuth.instance.signOut();
        // Google hesabı ile giriş yap
        await FirebaseAuth.instance.signInWithCredential(kimlikBilgileri);

        final DocumentReference dr = FirebaseFirestore.instance
            .collection('kullanicilar')
            .doc(FirebaseAuth.instance.currentUser.uid);

        if ((await dr.get()).exists)
          await dr.update({
            'displayName': FirebaseAuth.instance.currentUser.displayName,
            'email': FirebaseAuth.instance.currentUser.email,
            'photoUrl': FirebaseAuth.instance.currentUser.photoURL,
            'oturumAcmaTarihi': FieldValue.serverTimestamp(),
          });
        else {
          WriteBatch writeBatch = FirebaseFirestore.instance.batch();

          writeBatch.set(dr, {
            'displayName': FirebaseAuth.instance.currentUser.displayName,
            'email': FirebaseAuth.instance.currentUser.email,
            'photoUrl': FirebaseAuth.instance.currentUser.photoURL,
            'kayitTarihi': FieldValue.serverTimestamp(),
          });

          writeBatch.update(
              FirebaseFirestore.instance
                  .collection('genel-bilgiler')
                  .doc('kullanici-sayilari'),
              {'ogrenci': FieldValue.increment(1)});

          await writeBatch.commit();
        }

        Navigator.popUntil(context, (route) => route.isFirst);
      } catch (e) {
        print(e);
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArka(
      child: Scaffold(
        backgroundColor: Renk.koyuYesil,
        appBar: AppBar(
          backgroundColor: Renk.koyuYesil,
          elevation: 0,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: Center()),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: Image.asset('assets/images/logo_isim.png'),
            ),
            Expanded(
              child: Column(
                children: [
                  Center(
                    child: Text(
                      "Hesabınızla giriş yapın.",
                      style: TextStyle(color: Renk.yesil99),
                    ),
                  ),
                  SizedBox(height: 16),
                  GoogleAuthButton(onPressed: _googleIleGirisYap),
                  SizedBox(height: 16),
                  AppleAuthButton(
                    onPressed: () {},
                  ),
                  SizedBox(height: 16),
                  // TODO Sonradan aktifleştirilecek
                  Center(
                    child: Text(
                      "Hesabınız yoksa buradan kayıt olun.",
                      style: TextStyle(color: Renk.yesil99),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
