import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

class CreateViewTemps extends StatefulWidget {

  const CreateViewTemps({Key? key}) : super(key: key);

  @override
  _View createState() => _View();
}

  class _View extends State<CreateViewTemps>{
  late bool ready;

  @override
  void initState(){
    super.initState();
    ready=true;
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
        ElevatedButton(
          onPressed: () {
            //qui facciamo partire il tutto
            setState(() { ready=true;});
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



