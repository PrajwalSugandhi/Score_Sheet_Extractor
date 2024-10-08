import 'dart:io';
import 'dart:typed_data';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';


class FileStorage {
  static Future<String> getExternalDocumentPath() async {
    // To check whether permission is given for this app or not.
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      // If not, we will ask for permission first
      await Permission.storage.request();
    }

    io.Directory _directory;
    if (io.Platform.isAndroid) {
      // Redirects it to the download folder in Android
      _directory = io.Directory("/storage/emulated/0/Download");
    } else {
      _directory = await getApplicationDocumentsDirectory();
    }

    final exPath = _directory.path;
    print("Saved Path: $exPath");
    await io.Directory(exPath).create(recursive: true);
    return exPath;
  }

  static Future<String> get _localPath async {
    final String directory = await getExternalDocumentPath();
    return directory;
  }

  static Future<File> writeCounter(Uint8List bytes, String name) async {
    final path = await _localPath;
    File file = File('$path/$name');
    print("Save file");

    // Write the data in the file you have created
    return file.writeAsBytes(bytes);
  }
}