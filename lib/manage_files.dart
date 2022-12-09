import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

///this class contains all the functions necessary to
///create,delete and move files and directories.


///this function save a File into the application directory,
///given the name and the content of the file.
Future<bool> saveFile(String fileName, String text) async {
  Directory directory;
  try {
    if (Platform.isAndroid) {
      if (await _requestPermission(Permission.storage)) {
        directory = await getApplicationDocumentsDirectory();
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

      String finalString = "";                                //parsing
      List<String> strings = text.split('\n');
      for(int i=0; i<strings.length; i++) {
        String string = strings[i];
        if(string.length==4) string="\n";  //if the row is empty
        else {
          int start = 3;
          int end = string.length - 3;
          string = string.substring(start, end);
          if (i != strings.length - 1) string = '$string\n';
        }
        finalString = finalString + string;
      }

      saveTxtFile.writeAsString(finalString);
      return true;
    }
    return false;
  } catch (e) {
    print(e);
    return false;
  }
}

///this function is used to guarantee that we have all the permissions
///from the user
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

///this function deletes a file given its name and the directory it is into
Future<void> deleteFile(String fileName, Directory directory) async {
  File TxtFile = File("${directory.path}/$fileName.txt");
  TxtFile.deleteSync();
}

///this function checks if a file is already existent,
///given the name of the file and the directory
Future <bool> checkFiles(String fileName, Directory dir) async {
  List<String> names = List.filled(0, "", growable: true);
  List<FileSystemEntity> list;
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

///this function allow us to move a file (ToMove)
///from a directory (from) to another (to).
Future<void> moveFile(String toMove, Directory from, Directory to) async {
  if(from==to) return;

      File file = File("${from.path}/$toMove.txt");
      String text = file.readAsStringSync();
      File saveTxtFile = File("${to.path}/$toMove.txt");

      saveTxtFile.writeAsString(text);
      file.deleteSync();
}

///this function checks if a directory is already existent,
///given his name and where it is located
bool checkDirs(String name, Directory dir){
  List<String> names = List.filled(0, "", growable: true);
  List<FileSystemEntity> list;
  list = dir.listSync();
  for(FileSystemEntity entity in list){
    if(entity is Directory) {
      String string = entity.path.split("/").last;
      names.add(string);
    }
  }

  if(name=="" || names.contains(name))
    return false;
  return true;
}

///this function allow us to create a directory
Future<bool> createDir(String name, Directory dir) async {
  try {
    if(name==""){
      return false;
    }
    if (await dir.exists()){
      Directory newDir = Directory("${dir.path}/$name");
      newDir.create(recursive: true);
      return true;
    }
    return false;
  } catch (e) {
    print(e);
    return false;
  }
}

///this method deletes the chosen directory
void deleteDirectory(Directory dir){ //it doesn't work if i am not in the root directory
  dir.deleteSync();
}