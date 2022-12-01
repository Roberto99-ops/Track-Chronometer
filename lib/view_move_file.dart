import 'dart:io';

import 'package:app_cronometro/view_of_create_new_directory.dart';
import 'package:flutter/material.dart';
import 'package:app_cronometro/manage_files.dart';
import 'create_view_move_file.dart';

///this class generates the view seen when moving a file.
class ViewMoveFile extends StatefulWidget {

  final String file; //file to be moved
  final String oldDirectory; //directory from where I have to move the file
  final String newDirectory; //newDirectory is this directory
  ViewMoveFile({Key? key, required this.file, required this.oldDirectory, required this.newDirectory})
      : super(key: key);

  @override
  _View createState() => _View();
}


class _View extends State<ViewMoveFile>{

  late List<String> dirs; //directory located in the current directory

  @override
  void initState(){
    super.initState();
    dirs = List.filled(0, "", growable: true);
    updateFiles(Directory(widget.newDirectory));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body:  ListView.builder(
              itemCount: dirs.length,
              itemBuilder: (BuildContext context, int index) {
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
                          CreateViewMoveFile(file: widget.file, oldDirectory: Directory(widget.oldDirectory), newDirectory: Directory(widget.newDirectory + "/" + dirs.elementAt(index)))
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
                                          Directory dir = Directory("${widget.newDirectory}");
                                          await Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ViewCreateDir(directory: dir),
                                            ),
                                          );
                                          updateFiles(Directory(widget.newDirectory));
                                          Navigator.of(context).pop();
                                        }
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.delete, color: Colors.red,),
                                      title: Text('delete'),
                                      onTap: () {
                                        deleteDirectory(Directory(widget.newDirectory + "/" + dirs.elementAt(index)));
                                        updateFiles(Directory(widget.newDirectory));
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
          ),
        ),
      ],
    );
  }


  ///this function scan the directory to make a list of the directories
  updateFiles(Directory dir) async {
    List<String> directories = List.filled(0, "", growable: true);
    List<FileSystemEntity> list;
    list = dir.listSync();

    for(FileSystemEntity entity in list){
      if(entity is Directory){
        String string = entity.path.split("/").last;
        if(string!="flutter_assets" && string != "res_timestamp-1-1669713873794")
          directories.add(string);
      }
    }
    setState((){
      dirs = directories;
    });
  }
}
