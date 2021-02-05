import 'package:flutter/material.dart';

class ProfilFoto extends StatelessWidget {
  final String fotoUrl;

  const ProfilFoto({Key key, this.fotoUrl}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircleAvatar(
        radius: 50,
        backgroundImage: AssetImage(this.fotoUrl,),
      ),
    );
  }
}
