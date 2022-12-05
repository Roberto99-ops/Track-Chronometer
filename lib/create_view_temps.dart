import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'display_text.dart';

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
  late Stopwatch timeWatch = Stopwatch();
  late String totalTime;
  late String firstPartial;
  late String secondPartial;
  late Timer timer;

  @override
  void initState(){
    initDir();
    super.initState();
    ready=true;
    saveButton=false;
    getTime(timeWatch);
    timer = Timer.periodic(Duration(milliseconds: 1), (timer) {
      getTime(timeWatch);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height-600,
              ),
              Container(
                //qui ci va un container col tempo che scorre con bluetooth
                height: MediaQuery.of(context).size.height-400,
                width: MediaQuery.of(context).size.width-100,
                child: Column(
                  children: [
                    Text(
                      totalTime,
                      textScaleFactor: 4,
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 20,),
                    Text(
                      firstPartial,
                      textScaleFactor: 3,
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      secondPartial,
                      textScaleFactor: 3,
                      textAlign: TextAlign.left,
                    ),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
              ),
              if (ready==true)...[
                if(saveButton==false)...[
                  Row(
                    children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width/3-40,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      //qui facciamo partire il tutto bluetooth
                      setState(() { ready=false;});
                      setState(() {timeWatch.start();});
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
                  )
                    ],
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
                          setState(() {timeWatch.start();});
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
                Row(
                  children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width/3-40,
                ),
                ElevatedButton(
                  onPressed: () {
                    //qui facciamo partire il tutto bluetooth
                    setState(() { ready=true; saveButton=true;});
                    setState(() {timeWatch.stop();});
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

  ///this function transforms a stopwatch var into min:sec.millisec
  getTime(Stopwatch watch){
    int start = 3;
    int end = 11;
    String cutTime = watch.elapsed.toString().substring(start,end);
    setState(() {totalTime=cutTime; firstPartial=cutTime; secondPartial=cutTime;});
    print(totalTime);
  }
}


String fileName = ""; //this variable is used to know if the variable is already been saved
void setFilename(String name){
  fileName = name;
}
String getFileName(){
  return fileName;
}
