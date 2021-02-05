import 'package:flutter/material.dart';

import '../../../gerecler/resim_yollari.dart';
import 'cont_icon.dart';

class EvreSecimi extends StatefulWidget {
  final Function(String) evreDegistir;

  const EvreSecimi({Key key, @required this.evreDegistir}) : super(key: key);

  @override
  _EvreSecimiState createState() => _EvreSecimiState();
}

class _EvreSecimiState extends State<EvreSecimi> {
  String _seciliEvre = "Tohum";

  void _evreDegistir(String evre) {
    widget.evreDegistir(_seciliEvre);
    setState(() {
      _seciliEvre = evre;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () => _evreDegistir("Tohum"),
          child: contIconGenis(
            ResimYollari.tohumIcon,
            _seciliEvre == "Tohum" ? "Tohum" : null,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
          ),
          child: InkWell(
            onTap: () => _evreDegistir("Fidan"),
            child: contIconGenis(
              ResimYollari.fidanIcon,
              _seciliEvre == "Fidan" ? "Fidan" : null,
            ),
          ),
        ),
        InkWell(
          onTap: () => _evreDegistir("Ağaç"),
          child: contIconGenis(
            ResimYollari.agacIcon,
            _seciliEvre == "Ağaç" ? "Ağaç" : null,
          ),
        ),
      ],
    );
  }
}
