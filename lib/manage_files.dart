import 'dart:ffi';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'create_view_files.dart';


Future<bool> saveFile(String fileName, String text) async {

  Directory directory;
  try {
    if (Platform.isAndroid) {
      if (await _requestPermission(Permission.storage)) {
        directory = await getApplicationDocumentsDirectory();
        /*String newPath = "";
          List<String> paths = directory.path.split("/");
          for (int x = 1; x < paths.length; x++) {
            String folder = paths[x];
            if (folder != "Android") {
              newPath += "/" + folder;
            } else {
              break;
            }
          }
          newPath = newPath + "/TextFiles";
          directory = Directory(newPath);*/
      } else {
        return false;
      }
    } else {
      if (await _requestPermission(Permission.storage)) {
        directory = await getTemporaryDirectory();
      } else {
        return false;
      }
    }

    if(fileName==""){
      return false;
    }
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    if (await directory.exists()) {
      File saveTxtFile = File("${directory.path}/$fileName.txt");

      /*String finalString = "";                                //parsing
      List<String> strings = text.split('\n');
      for(int i=0; i<strings.length; i++) {
        String string = strings[i];
        int start = 3;
        int end = string.length - 3;
        string = string.substring(start, end);
        if(i!=strings.length-1) string = '$string\n';
        finalString = finalString + string;
      }*/

      saveTxtFile.writeAsString(text);
      return true;
    }
    return false;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> _requestPermission(Permission permission) async {
  if (await permission.isGranted) {
    return true;
  } else {
    var result = await permission.request();
    if (result == PermissionStatus.granted) {
      return true;
    }
  }
  return false;
}

Future<void> deleteFile(String fileName) async {
  Directory directory = await getApplicationDocumentsDirectory();
  File TxtFile = File("${directory.path}/$fileName.txt");
  TxtFile.deleteSync();
}

Future <bool> checkFiles(String fileName) async {
  Directory directory = await getApplicationDocumentsDirectory();
  List<String> names = List.filled(0, "", growable: true);
  List<FileSystemEntity> list;
  Directory dir = await getApplicationDocumentsDirectory();
  list = dir.listSync();
  for(FileSystemEntity file in list){
    if(file.path.endsWith("txt")) {
        String string = file.path.split("/").last;
        int start = 0;
        int end = string.lastIndexOf(".");
        string = string.substring(start, end);
        names.add(string);
      }
    }

  if(fileName=="" || names.contains(fileName))
    return false;
  return true;
}

/*
Future <void> renameFile(String oldfileName, String newfileName) async{
  Directory dir = await getApplicationDocumentsDirectory();
  File file = File("${dir.path}/$oldfileName.txt");
  String text = file.readAsStringSync();
  deleteFile(oldfileName);
  saveFile(newfileName, text);
}*/