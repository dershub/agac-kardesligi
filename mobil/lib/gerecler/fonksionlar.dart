import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

int dateTimeToIntId(DateTime dt) =>
    int.parse("${dt.year - 2020}${dt.month}${dt.day}${dt.minute}${dt.minute}");

Future<Map> checkUser(String uid) async {
  return {};
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
