import 'dart:async';
import 'dart:io';
import 'package:app_cronometro/create_view_files.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'display_text.dart';
import 'main.dart';
import 'manage_files.dart';
import 'view_of_savelocalfile.dart';


class ViewIntoDirectory extends StatefulWidget{
  final Directory directory;
  ViewIntoDirectory({Key? key, required this.directory}) : super(key: key);

  @override
  _View createState() => _View();

}

class _View extends State<ViewIntoDirectory>{

  late String dirName="";
  @override
  void initState(){
    super.initState();
    dirName = widget.directory.path.split("/").last;
    print(widget.directory.path + dirName);
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
              Tab(child: Text(dirName)),
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
