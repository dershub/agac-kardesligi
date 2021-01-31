import 'package:auth_buttons/auth_buttons.dart';

import '../gerecler/renkler.dart';
import 'package:flutter/material.dart';

class GirisYap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF083A1D),
      child: SafeArea(
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
                        style: TextStyle(color: Renk.yesilYazi),
                      ),
                    ),
                    SizedBox(height: 16),
                    GoogleAuthButton(
                      onPressed: () {},
                    ),
                    SizedBox(height: 16),
                    AppleAuthButton(
                      onPressed: () {},
                    ),
                    SizedBox(height: 16),
                    // TODO Sonradan aktifleştirilecek
                    Center(
                      child: Text(
                        "Hesabınız yoksa buradan kayıt olun.",
                        style: TextStyle(color: Renk.yesilYazi),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
