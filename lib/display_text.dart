import 'dart:io';

import 'package:app_cronometro/text_editor.dart';
import 'package:flutter/material.dart';

class DisplayText extends StatelessWidget {

  final String extractText;
  final Directory directory;
  const DisplayText({Key? key, required this.extractText, required this.directory})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(tabs: [
              Tab(child: Icon(Icons.text_fields)),
            ],),
          ),
          body: TabBarView(children: [
            TextEditor(doc: extractText, directory: directory,),
          ],),
        ),
      ),
    );
  }
}




