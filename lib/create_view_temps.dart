import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

class CreateViewTemps extends StatefulWidget {

  const CreateViewTemps({Key? key}) : super(key: key);

  @override
  _View createState() => _View();
}

  class _View extends State<CreateViewTemps>{
  late bool ready; //used to start/stop the measure
  late bool save; //used to display the button to save the just taken measures

  @override
  void initState(){
    super.initState();
    ready=true;
    save=false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          //qui ci va uil tempo
          height: MediaQuery.of(context).size.height-250,
        ),
      if (ready==true)...[
        if(save==false)...[
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
            onPressed: () { setState(() {save=false;}); },
            icon: const Icon(
                Icons.save,
                color: Colors.blueAccent,
            ),
            iconSize: 50,
            //alignment: Alignment.bottomRight,
          ),
          ],
        )
    ]
    ]else...[
        ElevatedButton(
          onPressed: () {
            //qui facciamo partire il tutto
            setState(() { ready=true; save=true;});
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
    );
  }



  //this function refactors the text
  String stringRefactor(String string) {
    int start = string.indexOf("{")+24;
    int end = string.lastIndexOf("b")-4;
    return string.substring(start, end);
  }

}



