import 'dart:io';

import 'package:app_cronometro/view_into_directory.dart';
import 'package:app_cronometro/view_of_create_new_directory.dart';
import 'package:app_cronometro/view_of_savelocalfile.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:app_cronometro/manage_files.dart';
import 'package:share_plus/share_plus.dart';
import 'text_editor.dart';
import 'display_text.dart';

//import 'favourites.dart';


class CreateViewFiles extends StatefulWidget {

  final String path;
  CreateViewFiles({Key? key, required this.path})
      : super(key: key);

  @override
  _View createState() => _View();
}


class _View extends State<CreateViewFiles>{

  late List<String> files;
  late List<String> dirs;
  late List <String> favouriteFiles; //this list contains the name of the user favourite files
  late int _index;
  late bool _picked;
  late Directory directory;

  @override
  void initState(){
    super.initState();
    checkDir();
    files = List.filled(0, "", growable: true);
    dirs = List.filled(0, "", growable: true);
    favouriteFiles = List.filled(0, "", growable: true);
    _picked=false;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          Scaffold(
              body:  ListView.builder(
                  itemCount: (files.length + dirs.length),
                  itemBuilder: (BuildContext context, int index) {
                    if(index < dirs.length){
                      return ListTile( //these are the directories
                        leading: Icon(Icons.account_balance_wallet),
                        title: Text(
                          dirs.elementAt(index),
                          style: const TextStyle(
                            fontSize: 20,
                            decorationThickness: 2
                          )
                        ),
                        onTap: () async => {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  ViewIntoDirectory(directory: Directory(directory.path + "/" + dirs.elementAt(index))),
                            ),
                          )
                        },
                        onLongPress: (){
                          showModalBottomSheet(
                              context: context,
                              builder: (context){
                                return SizedBox(
                                  height: 60*2,
                                  child: Column(
                                    children: <Widget>[
                                      ListTile(
                                        leading: Icon(Icons.add, color: Colors.green,),
                                        title: Text('new directory'),
                                        onTap: () async {
                                          Directory dir = Directory("${directory.path}");
                                          await Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ViewCreateDir(directory: dir),
                                            ),
                                          );
                                          updateFiles(directory);
                                          Navigator.of(context).pop();
                                        }
                                      ),
                                      ListTile(
                                          leading: Icon(Icons.delete, color: Colors.red,),
                                          title: Text('delete'),
                                        onTap: () {
                                          deleteDirectory(Directory(directory.path + "/" + dirs.elementAt(index)));
                                          updateFiles(directory);
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  )
                                );
                              }
                          );
                        },
                      );
                    }
                    else{ //these are the files
                    return ListTile(
                        leading: Icon(Icons.file_copy_outlined),
                        title: Text(
                          files.elementAt(index-dirs.length),
                          style: const TextStyle(
                            fontSize: 20,
                ),
              ),
              onTap: () => {
                          setState(() {_picked=true;}),
                _index=index-dirs.length,
              },
              onLongPress: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context){
                      return SizedBox(
                          height: 60*5,
                          child: Column(
                              children: <Widget>[
                                ListTile(
                                  leading: const Icon(Icons.add, color: Colors.green),
                                  title: const Text('new directory'),
                                  onTap: () async {
                                    Directory dir = Directory("${directory.path}");
                                    await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => ViewCreateDir(directory: dir),
                                      ),
                                    );
                                    updateFiles(directory);
                                    Navigator.of(context).pop();
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.drive_file_move_outline, color: Colors.green),
                                  title: const Text('move'),
                                  onTap: () {
                                    //qui devo far si che si possano spostare
                                    updateFiles(directory);
                                    Navigator.of(context).pop();
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.text_fields, color: Colors.green),
                                  title: const Text('rename '),
                                  onTap: () async {
                                    var result = await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => ViewSaveFile(text: getText(files.elementAt(index-dirs.length)), directory: directory,),
                                      ),
                                    );
                                    if(result==true)
                                      deleteFile(files[index-dirs.length]);
                                    updateFiles(directory);
                                    Navigator.of(context).pop();
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.delete, color: Colors.red),
                                  title: const Text('delete'),
                                  onTap: () {
                                    deleteFile(files[index-dirs.length]);
                                    updateFiles(directory);
                                    Navigator.of(context).pop();
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.share, color: Colors.blue),
                                  title: const Text('share'),
                                  onTap: () {
                                    XFile file = XFile("${directory.path}/${files[index-dirs.length]}.txt");
                                    List <XFile> dir = List.empty(growable: true);
                                    dir.add(file);
                                    Share.shareXFiles(dir);
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
                    };
        }
    ),
    ),
          if(_picked)...[  //this displays the text
            Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
                Radius.circular(15.0)
            ),
            color: Colors.black,
          ),
          height: 400,
          width: 300,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                width: 300,
                height: 10,
              ),
              Text(files.elementAt(_index), style: TextStyle(
                color: Colors.blue,
                fontSize: 25,
                fontStyle: FontStyle.italic,
                decoration: TextDecoration.underline
              ),
              ),
              SizedBox(
                height: 75,
              ),
              SizedBox(
                width: 300,
                height: 220,
                child: Row(
                  children: [
                    SizedBox(width: 30,),
                    SizedBox(
                      width: 300-30,
                    height: 220,
                    child: Text(
                      getText(files.elementAt(_index)),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                        fontSize: 20,
                          ),
                        )
                    ),
                  ],
                )
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 110,
                    height: 55,
                    child: ElevatedButton(
                        onPressed: () {
                          /*await Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => TabApp(),
                            ),
                          );*/
                          setState(() {
                            _picked=false;
                          });
                        },
                        style: const ButtonStyle(
                          // minimumSize: MaterialStateProperty.,
                        ),
                        child: const Text("back")
                    ),
                  ),
                  const SizedBox(
                    width: 60,
                  ),
                  SizedBox(
                    width: 110,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () async {
                        setFileName(files.elementAt(_index));
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DisplayText(
                                extractText: getText(files.elementAt(_index)), directory: directory,
                          ),
                          ),
                        );
                      },
                      child: const Text("modify"),
                    ),
                  ),
                ],
              ),
          ],
          ),
        ),
      ),
    ),
          ],
  ],
    );
  }


  //this function scan the directory to make a list of the txt files
  updateFiles(Directory dir) async {
    List<String> names = List.filled(0, "", growable: true);
    List<String> directories = List.filled(0, "", growable: true);
    List<FileSystemEntity> list;
    list = dir.listSync();

    for(FileSystemEntity entity in list){
      //FileStat f = file.path;
      if(entity is File){
        if(entity.path.endsWith("txt")) {
          String string = entity.path.split("/").last;
          int start = 0;
          int end = string.lastIndexOf(".");
          string = string.substring(start, end);
          names.add(string);
        }
      }
      if(entity is Directory){
        String string = entity.path.split("/").last;
        if(string!="flutter_assets" && string != "res_timestamp-1-1669713873794")
          directories.add(string);
      }
    }

    setState((){
      files = names;
      dirs = directories;
    });
  }

  //this function gets the text from a file
  String getText(String name){
    String path = directory.path;
    File file = File("$path/$name.txt");
    String content = file.readAsStringSync();
    return content;
  }

  //this functions sets the initial directory
  checkDir() async {
    if(widget.path=="") {
      Directory dir = await getApplicationDocumentsDirectory();
      setState(() {
        directory = dir;
      });
    }
    else{
      Directory dir = Directory(widget.path);
      setState(() {
        directory = dir;
      });
    }
    updateFiles(directory);
  }
}
