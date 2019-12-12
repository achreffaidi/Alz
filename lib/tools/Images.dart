import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;

import 'package:path_provider/path_provider.dart';


class Images {
  File originalFile;

  Images(this.originalFile);

  Future<File> CompressAndGetFile() async {
    var result = await FlutterImageCompress.compressAndGetFile(
        originalFile.absolute.path, originalFile.absolute.path + "_compressed",
        quality: 50, minHeight: 600, minWidth: 600,rotate: 90);

    print(originalFile.lengthSync());
    print(result.lengthSync());

    return result;
  }



  Future get _localPath async {
    // Application documents directory: /data/user/0/{package_name}/{app_name}
    final applicationDirectory = await getApplicationDocumentsDirectory();

    // External storage directory: /storage/emulated/0
    final externalDirectory = await getExternalStorageDirectory();

    // Application temporary directory: /data/user/0/{package_name}/cache
    final tempDirectory = await getTemporaryDirectory();

    return tempDirectory.path;
  }

  Future get _localFile async {
    final path = await _localPath;

    return File('$path' + '/tempFile.file').create(recursive: true);
  }

  Future<String> uploadImage(url) async {
    var uri = Uri.parse(url);
    print(url);
    var request = new http.MultipartRequest("GET", uri);

    request.files.add(new http.MultipartFile.fromBytes(
        "file", originalFile.readAsBytesSync(),
        filename: DateTime.now().toIso8601String()));

    var response = await request.send();

    print(response.headers);

    switch(response.statusCode){
      case 200 : return response.headers["name"]+"|"+response.headers["userdata"] ;
      case 300 : return "Unable To Detect Any Face| " ;
      case 301 : return "Unable To Recongnize The Face | ";
    }
    return " | ";
  }
}

