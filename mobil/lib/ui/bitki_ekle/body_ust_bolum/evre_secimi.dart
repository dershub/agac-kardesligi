import 'package:flutter/material.dart';

import '../../../gerecler/resim_yollari.dart';
import 'cont_icon.dart';

class EvreSecimi extends StatefulWidget {
  @override
  _EvreSecimiState createState() => _EvreSecimiState();
}

class _EvreSecimiState extends State<EvreSecimi> {
  String _seciliEvre = "Tohum";
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () => setState(() {
            _seciliEvre = "Tohum";
          }),
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
            onTap: () => setState(() {
              _seciliEvre = "Fidan";
            }),
            child: contIconGenis(
              ResimYollari.fidanIcon,
              _seciliEvre == "Fidan" ? "Fidan" : null,
            ),
          ),
        ),
        InkWell(
          onTap: () => setState(() {
            _seciliEvre = "Ağaç";
          }),
          child: contIconGenis(
            ResimYollari.agacIcon,
            _seciliEvre == "Ağaç" ? "Ağaç" : null,
          ),
        ),
      ],
    );
  }
}
