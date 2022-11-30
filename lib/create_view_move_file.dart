import 'dart:async';
import 'dart:io';
import 'package:app_cronometro/create_view_files.dart';
import 'package:app_cronometro/view_move_file.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'display_text.dart';
import 'main.dart';
import 'manage_files.dart';
import 'view_of_savelocalfile.dart';


class CreateViewMoveFile extends StatefulWidget{

  final String file;
  final Directory oldDirectory;
  final Directory newDirectory;
  CreateViewMoveFile({Key? key, required this.file, required this.oldDirectory, required this.newDirectory}) : super(key: key);

  @override
  _View createState() => _View();

}

class _View extends State<CreateViewMoveFile>{

  late String dirName="";
  late String backDir;
  late int end;
  @override
  void initState(){
    super.initState();
    dirName = widget.newDirectory.path.split("/").last;
    end = widget.newDirectory.path.length - dirName.length - 1;
    backDir = widget.newDirectory.path.substring(0, end);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: DefaultTabController(
        length: 1,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(tabs: [
                Tab(child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width/10,
                    child: IconButton(
                        onPressed: () async => {
                          if(widget.newDirectory.path.split("/").last!="app_flutter")
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CreateViewMoveFile(file: widget.file, oldDirectory: widget.oldDirectory, newDirectory: Directory(backDir),)
                              ),
                            ),
                        },
                        icon: Icon(Icons.arrow_circle_left_outlined, color: Colors.blue)
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width/10*2),
                  SizedBox(
                    width: MediaQuery.of(context).size.width/10*3,
                    child: Text(dirName, textScaleFactor: 1.5, textAlign: TextAlign.center,),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width/10*2),
                  SizedBox(
                    width: MediaQuery.of(context).size.width/10,
                    child: IconButton(
                        onPressed: () => {
                          moveFile(widget.file, widget.oldDirectory, widget.newDirectory),
                          Navigator.popUntil(context, ModalRoute.withName("/_CreateViewFiles"))
                        },
                        icon: Icon(Icons.save_alt, color: Colors.blue,)
                    )
                  )

                ],
              ),
              ),
            ],),
          ),
          body: TabBarView(children: [
            ViewMoveFile(file: widget.file, oldDirectory: widget.oldDirectory.path, newDirectory: widget.newDirectory.path)
          ],),
        ),
      ),
    );
  }
}

