import 'dart:async';
import 'package:flutter/material.dart';

import 'create_view_files.dart';
import 'create_view_temps.dart';

Future<void> main() async{
  //It ensures that plugin services are initialized and fun like availableCameras() can be called
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TabApp());
  // Obtain a list of the available cameras on the device.

  // Get a specific camera from the list of available cameras (generally backCamera)
}

class TabApp extends StatelessWidget {
  const TabApp({Key? key}) : super(key: key);


  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(tabs: [
              Tab(child: Icon(Icons.access_alarm)),
              Tab(child: Icon(Icons.account_balance_wallet)),
            ],),
          ),
          body: TabBarView(children: [
            CreateViewTemps(),
            CreateViewFiles(),
          ],),
        ),
      ),
    );
  }
}

