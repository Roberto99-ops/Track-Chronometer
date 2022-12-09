import 'dart:io';

import 'package:flutter/material.dart';
import 'package:app_cronometro/view_of_savelocalfile.dart';
import 'package:zefyrka/zefyrka.dart';
import 'package:quill_format/quill_format.dart';

import 'main.dart';
import 'manage_files.dart';

///this class is the text editor, uses the zefyrka editor to edit text.
///when we open a file we are in the readOnly mode, if we press the
///button we can quit that mode and modify the file. then we can save
///it calling the view_of_savelocalfile widget.
class TextEditor extends StatefulWidget{
  String doc;
  final Directory directory;
  final bool rename;
  TextEditor({Key? key, required this.doc, required this.directory, required this.rename}) : super(key: key);

  @override
  _TextEditor createState() => _TextEditor();

}

class _TextEditor extends State<TextEditor>{

  late ZefyrController _controller;
  late bool _readOnly;

  @override
  void initState(){
    super.initState();
    final document = loadDocument();
    _readOnly = true;
    _controller = ZefyrController(document);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: Column(
            children: [
              if(_readOnly)...[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          setState((){_readOnly = false;});
                        },
                        child: const Text(
                          "Press to exit the ReadOnly mode", style: TextStyle(
                          //fontSize: 10.0,
                        ),
                        ),
                      ),
                    ),
                  ],
                ),
              ]
              else...[
                ZefyrToolbar.basic(controller: _controller),
              ],
              Expanded(
                child: ZefyrEditor(
                  controller: _controller,
                  readOnly: _readOnly,  //readOnly variable
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.archive_sharp),
              onPressed: () async {
                if(getFileName()!="") {
                  saveFile(getFileName(), _controller.document.toString(), widget.directory, widget.rename);
                  setFileName("");
                  await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TabApp(), //qui mi sa che è sbagliato nel senso che penso di dover fare la "back"
                      )
                  );
                }
                else {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ViewSaveFile(text: _controller.document.toString(), directory: widget.directory, rename: false,),
                    ),
                  );
                }
              }
          ),
        ),
      ],
    );
  }

  ///this function provide a document readable from the Zefyr library
  NotusDocument loadDocument(){
    Delta delta = Delta()..insert(widget.doc);
    delta = delta.concat(Delta()..insert('\n'));  //it always has to end with a newline
    return NotusDocument.fromDelta(delta);
  }
}

String fileName = ""; //this variable is used to know if the variable is already been saved
void setFileName(String name){
  fileName = name;
}
String getFileName(){
  return fileName;
}