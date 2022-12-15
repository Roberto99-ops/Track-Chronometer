import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'display_text.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

///this class creates the intial view where we can see the registered
///time result and then save it.
///this class is a big is-else, if I haven't started yet the time
///measure I don't have to display the save button, in the
///other case I have to do it; also if I start the measure I have to display
///a STOP button...
///spacers e flexibles heavily used to adapt the layout to the screen size

class CreateViewTemps extends StatefulWidget{
  CreateViewTemps({Key? key}) : super(key: key);

  @override
  _View createState() => _View();

}

class _View extends State<CreateViewTemps>{

  late bool ready; //used to start/stop the measure
  late bool saveButton=false; //used to display the button to save the just taken measures
  late Directory directory; //directory where I have to save the file (application directory)
  late Stopwatch timeWatch = Stopwatch(); //used to count the time
  late String totalTime;
  late String firstPartial;
  late String secondPartial;
  late bool firstCheck = false; //checks if the athlete is passed through the first photocell
  late Duration firstCheckTime; //saves the time of the first partial
  late Timer timer;
  late String doc;
  late BluetoothConnection connection;
  String address = "98:DA:50:01:CE:1C";  //address of the BT module

  @override
  void initState(){
    initDir();
    super.initState();
    ready=true;
    saveButton=false;
    getTime(timeWatch);
    setState(() {secondPartial=totalTime;});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body:Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(
                flex: 3,
              ),
              Flexible(
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
                flex: 6
              ),
              if (ready==true)...[//I got the start button
                  Flexible(
                    child: Row(
                    children: [
                      Spacer(flex: 1,),
                      Flexible(child: ElevatedButton(
                        onPressed: () async {
                          timeWatch.reset(); //these 5 lines resets all the view
                          setState(() {firstCheckTime=Duration(days:0,hours:0,minutes:0,seconds:0,milliseconds:0, microseconds:0);});
                          getTime(timeWatch);
                          setState(() {firstCheck=false;});
                          getTime(timeWatch);
                          //then ti tries to connect to arduino and starts everything
                          try {
                            connection = await BluetoothConnection.toAddress(address);
                            _sendData(connection, "A"); //sends A via BT, stands for "start"
                            setState(() {ready = false;});
                            connection.input?.listen((Uint8List data) {
                              _manageBT(ascii.decode(data));
                            });
                          }catch(e){}
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
                        flex: 3,
                      ),
                      Flexible(child: Row(children:[
                      Spacer(flex: 2,),
                      Flexible(child: IconButton(
                        onPressed: () async {
                          composeDoc();
                          var result = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => DisplayText(extractText: doc, directory: directory,),
                            ),
                          );
                          if(result==true) {
                            setState(() {saveButton = false;});
                            setState(() {timeWatch.reset();});
                          }
                        },
                        icon: const Icon(
                          Icons.archive_sharp,
                          color: Colors.blueAccent,
                        ),
                        iconSize: 50,
                        //alignment: Alignment.bottomRight,
                      ),
                        flex: 5,
                      ),
                        Spacer(flex: 2),
                      ],
                      ),
                      ),
                    ],
                  ),
                    flex: 2,
                  ),
              ]else...[//I got the Stop button
                Flexible(child: Row(
                  children: [
                Spacer(flex: 1,),
                Flexible(child: ElevatedButton(
                  onPressed: () async {
                    //if the BT is connected the app sends to stop to arduino and resets everything
                    //else it connects to it and then does his stuffs
                    if(!connection.isConnected)
                    try {
                      connection = await BluetoothConnection.toAddress(address);
                    }catch(e){}
                    _sendData(connection, "B"); //sends B via BT, stands for "start"
                    setState(() {ready=true; saveButton=true;});
                    timeWatch.stop();
                    timer.cancel(); //this stops the timer
                    _manageBT("C");
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
                  flex: 3,
                ),
                    Spacer(flex: 1,)
                  ],
                ),
                  flex: 2,
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
    setState(() {totalTime=cutTime;});
    if(!firstCheck) setState(() {firstPartial=cutTime;}); //time of the first partial
    if(firstCheck){//time of the second partial
      Duration partial = watch.elapsed - firstCheckTime;
      cutTime = partial.toString().substring(start,end);
      setState(() {secondPartial=cutTime;});
    }
  }

  ///this function composes the document that we want to save
  composeDoc(){
    setState(() {
      doc = ("Tempo totale: " + totalTime + "\n\n" + "Primo parziale: " + firstPartial + "\n" + "Secondo parziale: " + secondPartial);
    });
  }

  ///this function sends data via bluetooth
  Future<void> _sendData(BluetoothConnection connection, String data) async {
    connection.output.add(Uint8List.fromList(utf8.encode(data))); // Sending data
    await connection.output.allSent;
  }

  ///this function manages bluetooth inputs
  _manageBT(String received) async {
    print(received);
    switch(received){

      case 'A': //in case it receives A it starts counting
        timeWatch.start(); //starts e reset the time
        timer =
            Timer.periodic(Duration(milliseconds: 1), (timer) {
              getTime(timeWatch);
            }); //this is a timer that runs the time
        break;

      case 'B'://in case it receives B it starts counting the second partial time
        setState(() {
          firstCheck = true;
          firstCheckTime=timeWatch.elapsed;
        });
        break;

      case 'C': //In case it receives C it closes the connection and resets everything
        timeWatch.stop();
        setState(() {ready=true; saveButton=true;});
        connection.finish(); // Closing connection
        break;
    }
  }
}


String fileName = ""; //this variable is used to know if the variable is already been saved
void setFilename(String name){
  fileName = name;
}
String getFileName(){
  return fileName;
}
