import 'dart:io';
import 'package:app_cronometro/view_move_file.dart';
import 'package:flutter/material.dart';
import 'manage_files.dart';

///this class creates the view (a material app) that will allow
///me to move a file, it will call the ViewMoveFile class.

class CreateViewMoveFile extends StatefulWidget{

  final String file; //name of the file that I have to move
  final Directory oldDirectory; //directory where the file is
  final Directory newDirectory; //directory where I am
  CreateViewMoveFile({Key? key, required this.file, required this.oldDirectory, required this.newDirectory}) : super(key: key);

  @override
  _View createState() => _View();

}

class _View extends State<CreateViewMoveFile>{

  late String dirName=""; //name of the directory where I am
  late String backDir; //previous directory wrt where I am
  late int end;
  @override
  void initState(){
    super.initState();
    dirName = widget.newDirectory.path.split("/").last; //if dirName==app_flutter -> dirName=Home
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
                          if(widget.newDirectory.path.split("/").last!="app_flutter") //if I am in the ApplicationDir I souldn't go back to previous directories
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

