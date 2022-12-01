import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'display_text.dart';
import 'main.dart';
import 'manage_files.dart';
import 'view_of_savelocalfile.dart';

///this class creates the intial view where we can see the registered
///time result and then save it.
///this class is a big is-else, if I haven't started yet the time
///measure I don't have to display the save button, in the
///other case I have to do it; also if I start the measure I have to display
///a STOP button...

class CreateViewTemps extends StatefulWidget{
  CreateViewTemps({Key? key}) : super(key: key);

  @override
  _View createState() => _View();

}

class _View extends State<CreateViewTemps>{

  late bool ready; //used to start/stop the measure
  late bool saveButton=false; //used to display the button to save the just taken measures
  late String doc = "ciaociao"; //da cancellare
  late Directory directory; //directory where I have to save the file (application directory)

  @override
  void initState(){
    initDir();
    super.initState();
    ready=true;
    saveButton=false;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: Column(
            children: [
              Container(
                //qui ci va un container col tempo che scorre
                height: MediaQuery.of(context).size.height-250,
              ),
              if (ready==true)...[
                if(saveButton==false)...[
                  ElevatedButton(
                    onPressed: () {
                      //qui facciamo partire il tutto bluetooth
                      setState(() { ready=false;});
                    },
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.green),
                      fixedSize: MaterialStatePropertyAll(Size.fromWidth(200)),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.play_arrow, color: Colors.white, size: 60,),
                        SizedBox(
                          width: 5,
                          height: 80,
                        ),
                        Text("Start", style: TextStyle(color: Colors.white),
                          textScaleFactor: 2.5,)
                      ],
                    ),
                  ),
                ]else...[
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width/3-40,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          //qui facciamo partire il tutto bluetooth
                          setState(() { ready=false;});
                        },
                        style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(Colors.green),
                          fixedSize: MaterialStatePropertyAll(Size.fromWidth(200)),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.play_arrow, color: Colors.white, size: 60,),
                            SizedBox(
                              width: 5,
                              height: 80,
                            ),
                            Text("Start", style: TextStyle(color: Colors.white),
                              textScaleFactor: 2.5,)
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 14,
                      ),
                      IconButton(
                        onPressed: () async {
                          var result = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => DisplayText(extractText: doc, directory: directory,),
                            ),
                          );
                          if(result==true)
                            setState(() {saveButton=false;});
                        },
                        icon: const Icon(
                          Icons.archive_sharp,
                          color: Colors.blueAccent,
                        ),
                        iconSize: 50,
                        //alignment: Alignment.bottomRight,
                      ),
                    ],
                  ),
                ]
              ]else...[
                ElevatedButton(
                  onPressed: () {
                    //qui facciamo partire il tutto bluetooth
                    setState(() { ready=true; saveButton=true;});
                  },
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.red),
                    fixedSize: MaterialStatePropertyAll(Size.fromWidth(200)),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.play_arrow, color: Colors.white, size: 60,),
                      SizedBox(
                        width: 5,
                        height: 80,
                      ),
                      Text("Stop", style: TextStyle(color: Colors.white),
                        textScaleFactor: 2.5,)
                    ],
                  ),
                ),
              ],
            ],
    ),
    ),
      ],
    );
  }

  ///this function initiate the directory
  initDir() async {
    Directory dir = await getApplicationDocumentsDirectory();
    setState(() {
      directory=dir;
    });
  }
}


String fileName = ""; //this variable is used to know if the variable is already been saved
void setFilename(String name){
  fileName = name;
}
String getFileName(){
  return fileName;
}