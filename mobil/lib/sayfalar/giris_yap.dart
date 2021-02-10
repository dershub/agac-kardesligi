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
  final _firebaseAuth=FirebaseAuth.instance;

  Future<User> signInWithGoogle() async {
    //FİREBASE ILE ILGILI BIR HATA VAR DEVELOPER EXCEPTION OLARAK BULDUM HATA KAYNAGINI
    GoogleSignIn _googleSignIn = GoogleSignIn();
    GoogleSignInAccount _googleUser = await _googleSignIn.signIn();
    String _googleUserEmail = _googleUser.email;
    if (_googleUser != null) {
      GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
      if (_googleAuth.idToken != null && _googleAuth.accessToken != null) {
        UserCredential sonuc = await _firebaseAuth.signInWithCredential(
            GoogleAuthProvider.credential(
                idToken: _googleAuth.idToken,
                accessToken: _googleAuth.accessToken));
        User _user = sonuc.user;
        sonuc.user.updateEmail(_googleUserEmail);
        print("USER INFOS "+_user.email,);
      } else {
        return null;
      }
    } else {
      return null;
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
                  GoogleAuthButton(onPressed: signInWithGoogle),
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