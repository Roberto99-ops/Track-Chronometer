import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

class CreateViewTemps extends StatelessWidget {


  const CreateViewTemps({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Container(
      //child: Center(
       //child: //qui ci va il tempo,
      //),
    );
  }
}


  //this function refactors the text
  String stringRefactor(String string) {
    int start = string.indexOf("{")+24;
    int end = string.lastIndexOf("b")-4;
    return string.substring(start, end);
  }



