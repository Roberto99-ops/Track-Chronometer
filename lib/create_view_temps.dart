import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'main.dart';
import 'manage_files.dart';
import 'view_of_savelocalfile.dart';


class CreateViewTemps extends StatefulWidget{
  CreateViewTemps({Key? key}) : super(key: key);

  @override
  _View createState() => _View();

}

class _View extends State<CreateViewTemps>{

  late bool ready; //used to start/stop the measure
  late bool saveButton=false; //used to display the button to save the just taken measures
  late bool _save = false;
  late String doc = "ciaociao";

  @override
  void initState(){
    super.initState();
    ready=true;
    saveButton=false;
    _save=false;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: Column(
            children: [
              Container(
                //qui ci va uil tempo
                height: MediaQuery.of(context).size.height-250,
              ),
              if (ready==true)...[
                if(saveButton==false)...[
                  ElevatedButton(
                    onPressed: () {
                      //qui facciamo partire il tutto
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
                          //qui facciamo partire il tutto
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
                              builder: (context) => ViewSaveFile(text: doc),
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
                    //qui facciamo partire il tutto
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
}

void saveOff()
{

}
String fileName = ""; //this variable is used to know if the variable is already been saved
void setFileName(String name){
  fileName = name;
}
String getFileName(){
  return fileName;
}