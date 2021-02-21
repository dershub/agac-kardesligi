import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../gerecler/renkler.dart';

class ResimEkle extends StatelessWidget {
  final ValueChanged<File> resimDegisti;

  ResimEkle({@required this.resimDegisti});

  final ValueNotifier<File> _fileNotifier = ValueNotifier<File>(null);

  Future<void> _resimSec() async {
    PickedFile secilenResim = await ImagePicker()
        .getImage(source: ImageSource.gallery, maxWidth: 600);

    if (secilenResim != null)
      _fileNotifier.value = File(secilenResim.path);
    else
      _fileNotifier.value = null;

    resimDegisti(_fileNotifier.value);
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: [
          DottedBorder(
            color: Colors.black26,
            strokeWidth: 2,
            borderType: BorderType.RRect,
            radius: Radius.circular(18),
            child: ValueListenableBuilder<File>(
              valueListenable: _fileNotifier,
              builder: (_, file, __) {
                return Container(
                  decoration: BoxDecoration(
                    color: Renk.acikGri,
                    borderRadius: BorderRadius.circular(18),
                    image: file == null
                        ? null
                        : DecorationImage(
                            image: FileImage(file),
                            fit: BoxFit.cover,
                          ),
                  ),
                  child: FlatButton(
                    onPressed: _resimSec,
                    child: Center(),
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: InkWell(
              onTap: _resimSec,
              child: Icon(
                Icons.add_circle,
                color: Renk.yesil99,
                size: 36,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
