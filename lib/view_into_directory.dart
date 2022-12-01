import 'dart:io';
import 'package:app_cronometro/create_view_files.dart';
import 'package:flutter/material.dart';


///this class is used to return a materialapp that allows
///me to see into a directory when I press it.
///it calls CreateViewFiles as body to view all the files and
///directory listed in this subDirectory.
class ViewIntoDirectory extends StatefulWidget{
  Directory directory; //directory into wich I want to see

  ViewIntoDirectory({Key? key, required this.directory}) : super(key: key);

  @override
  _View createState() => _View();

}

class _View extends State<ViewIntoDirectory>{

  late String dirName=""; //name of the chosen directory
  late int end;
  late String newDirName; //name of the previous directory
  @override
  void initState(){
    super.initState();
    dirName = widget.directory.path.split("/").last;
    end = widget.directory.path.length - dirName.length - 1;
    newDirName = widget.directory.path.substring(0, end);
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
                    IconButton(
                        onPressed: () async => {
                          if(newDirName.split("/").last!="app_flutter") //else navigator.pop
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  ViewIntoDirectory(directory: Directory(newDirName)),
                            ),
                          ),
                          },
                        icon: Icon(Icons.arrow_circle_left_outlined, color: Colors.blue)
                    ),
                    SizedBox(width: 80,),
                    Text(dirName, textScaleFactor: 1.5,),
                  ],
              ),
              ),
            ],),
          ),
          body: TabBarView(children: [
              CreateViewFiles(path: widget.directory.path)
          ],),
        ),
      ),
    );
  }
}

