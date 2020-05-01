import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';


Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}
Future<File> get _localFile async {
  final path = await _localPath;
  // print('$path');
  // var systemTempDir = Directory.systemTemp;

  // // List directory contents, recursing into sub-directories,
  // // but not following symbolic links.
  // systemTempDir.list(recursive: true, followLinks: false)
  //   .listen((FileSystemEntity entity) {
  //     print(entity.path);
  //   });
  return File('$path/counter.txt');
}

Future<File> writeCounter(int counter) async {
  final file = await _localFile;

  // Write the file.
  return file.writeAsString('$counter');
}

Future<String> readCounter() async {
  try {
    final file = await _localFile;
    
    // Read the file.
    String contents = await file.readAsString();
    print('readCounter');

    return contents;
  } catch (e) {
    // If encountering an error, return 0.
    return 'no search file';
  }
}


