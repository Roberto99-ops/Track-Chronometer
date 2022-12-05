import 'dart:io';

import 'package:flutter/material.dart';
import 'package:app_cronometro/manage_files.dart';

import 'main.dart';

///this class creates the view that allow me to save a file.
class ViewSaveFile extends StatefulWidget{
  final String text; //text to be saved
  final Directory directory; //where to be saved
  const ViewSaveFile({Key? key, required this.text, required this.directory}) : super(key: key);


  @override
  _ViewSaveFile createState() => _ViewSaveFile();
}

class _ViewSaveFile extends State<ViewSaveFile>{
  bool isReadOnly = true; //this is set true and then false if I click on the
  //input, so I haven't the keyboard istantly
  bool wrongname = false; //flag that allows me to know if the directory already exists
  final titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
                Radius.circular(15.0)
            ),
            color: Colors.black,
          ),
          height: 200,
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
              if (wrongname==false)...[
              const Text("Insert the name of the file"),
              ]else...[
              Text("File name already existing or empty"),
            ],
              SizedBox(
                width: 280,
                child: TextField(
                  controller: titleController,
                  enableSuggestions: false,
                  autocorrect: false,
                  readOnly: isReadOnly,
                  onTap: (){setState(() {isReadOnly=false;});},
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(
                width: 300,
                height: 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 110,
                    height: 55,
                    child: ElevatedButton(
                        onPressed: () async {
                          setState(() {isReadOnly=true;});
                          Navigator.pop(context, false);
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
                        bool c = await checkFiles(titleController.text,widget.directory); //variabile di comodo
                          if(c==false){
                            setState(() {wrongname=true;});
                          }
                          else {
                            setState(() {wrongname=false;});
                            saveFile(titleController.text, widget.text);
                            await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => TabApp(), //qui mi sa che è sbagliato nel senso che penso di dover fare la "back"
                                )
                            );
                          }
                      },
                      child: const Text("save"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}