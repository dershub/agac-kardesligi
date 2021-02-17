import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

int dateTimeToIntId(DateTime dt) =>
    int.parse("${dt.year - 2020}${dt.month}${dt.day}${dt.minute}${dt.minute}");

Future<Map> checkUser(String uid) async {
  Box userBox = Hive.box('users');
  Map userMap;

  if (userBox.containsKey(uid)) {
    userMap = userBox.get(uid);
    print("kullanıcı veritabanında var: $uid");
  } else {
    print("kullanıcı veritabanında yok: $uid");
    DocumentSnapshot dsUser = await FirebaseFirestore.instance
        .collection('kullanicilar')
        .doc(uid)
        .get();

    if (dsUser.exists) {
      await userBox.put(uid, dsUser.data());

      userMap = dsUser.data();
    } else
      userMap = {
        'photoUrl':
            "https://i.pinimg.com/originals/a9/61/55/a961559e319e9bdc6ceaf71de13aa596.jpg",
        'displayName': "Anonym",
      };
  }
  return userMap;
}

Future<String> checkImagePath(String url) async {
  String folderPath =
      (await getApplicationDocumentsDirectory()).path + '/cached_images/';

  Directory folderDirectory = Directory(folderPath);
  if (!folderDirectory.existsSync())
    await folderDirectory.create(recursive: true);

  String imageName = url.split('/').last;

  if (imageName.contains('?alt=media&token'))
    imageName = imageName.split('?alt=media&token').first;

  Directory imageDirectory = Directory(folderDirectory.path + imageName);

  if (folderDirectory.listSync().toString().contains(imageDirectory.path)) {
    return imageDirectory.path;
  } else {
    try {
      http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        if (response.headers['content-type'].startsWith('image')) {
          File file = File(imageDirectory.path);
          file.writeAsBytesSync(response.bodyBytes);
          print(response.bodyBytes);
          return imageDirectory.path;
        } else
          return ":error: url does not contain image";
      } else
        return ":error: Failed to load image : statusCode: ${response.statusCode}";
    } on PlatformException catch (e) {
      print(":error: PlatformException catch: $e");
      return ":error: PlatformException catch: $e";
    } catch (e) {
      print(":error: catch: $e");
      return ":error: catch: $e";
    }
  }
}
