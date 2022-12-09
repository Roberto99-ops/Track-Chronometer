import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'create_view_files.dart';
import 'create_view_temps.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TabApp());

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
          body: TabBarView(
              children: <Widget>[
            CreateViewTemps(),
            CreateViewFiles(path: ""),
          ],),
        ),
      ),
    );
  }
}