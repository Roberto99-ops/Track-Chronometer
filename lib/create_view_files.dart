import 'dart:io';

import 'package:app_cronometro/view_of_savelocalfile.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:app_cronometro/manage_files.dart';
import 'package:share/share.dart';
import 'text_editor.dart';
import 'display_text.dart';

//import 'favourites.dart';


class CreateViewFiles extends StatefulWidget {
  final String name;


  const CreateViewFiles({Key? key, required this.name})
      : super(key: key);

  @override
  _View createState() => _View();
}


class _View extends State<CreateViewFiles>{

  late List<String> files;
  late Directory directory;
  late List <String> favouriteFiles; //this list contains the name of the user favourite files

  @override
  void initState(){
    //super.initState(); to remove the warning
    files = List.filled(0, "", growable: true);
    favouriteFiles = List.filled(0, "", growable: true);
    updateFiles();
    //favouriteFiles = getFav();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: files.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
              leading: favourites(files.elementAt(index)),
              title: Text(
                files.elementAt(index),
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              onTap: () async =>
              {//qui ci devo mettere che leggo i file
                setFileName(files.elementAt(index)),
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DisplayText(
                        extractText: getText(files.elementAt(index)),
                  ),
                ),
                ),
              },
              onLongPress: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context){
                      return SizedBox(
                          height: 180,
                          child: Column(
                              children: <Widget>[
                                ListTile(
                                  leading: const Icon(Icons.delete, color: Colors.red),
                                  title: const Text('delete'),
                                  onTap: () {
                                    deleteFile(files[index]);
                                    updateFiles();
                                    Navigator.of(context).pop();
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.text_fields, color: Colors.green),
                                  title: const Text('rename'),
                                  onTap: () async {
                                    var result = await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => ViewSaveFile(text: getText(files.elementAt(index))),
                                      ),
                                    );
                                    if(result==true)
                                      deleteFile(files[index]);
                                    updateFiles();
                                    Navigator.of(context).pop();
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.share, color: Colors.blue),
                                  title: const Text('share'),
                                  onTap: () {
                                    List <String> dir = List.empty(growable: true);
                                    dir.length = 1;
                                    dir[0] = "${directory.path}/${files[index]}.txt";
                                    Share.shareFiles(dir);
                                    Navigator.of(context).pop();
                                  },
                                )
                              ]
                          )
                      );
                    }
                );
              }
          );
        }
    );
  }

  //this function returns the "favourite" widget
  Widget favourites(String name){
    if(favouriteFiles.contains(name)) {
      return IconButton(
        highlightColor: Colors.black,
        splashColor: Colors.black,
        icon: const Icon(
          Icons.star,
          color: Colors.yellow,
          size: 20,
        ),
        onPressed: () { setState(() { favouriteFiles.remove(name);});},
      );
    }
    else{
      return IconButton(
        highlightColor: Colors.yellow,
        splashColor: Colors.yellow,
        icon: const Icon(
          Icons.star_border_outlined,
          color: Colors.black,
          size: 20,
        ),
        onPressed: () {setState((){ favouriteFiles.add(name);});},
      );
    }
  }


  //this function scan the directory to make a list of the txt files
  updateFiles() async {
    List<String> names = List.filled(0, "", growable: true);
    List<FileSystemEntity> list;
    Directory dir = await getApplicationDocumentsDirectory();
    list = dir.listSync();
    for(FileSystemEntity file in list){
      //FileStat f = file.path;
      if(file.path.endsWith("txt")) {
        String string = file.path.split("/").last;
        int start = 0;
        int end = string.lastIndexOf(".");
        string = string.substring(start, end);
        names.add(string);
      }
    }

    setState((){
      files = names;
      directory = dir;
    });
  }

  String getText(String name){
    String path = directory.path;
    File file = File("$path/$name.txt");
    String content = file.readAsStringSync();
    return content;
  }
}


