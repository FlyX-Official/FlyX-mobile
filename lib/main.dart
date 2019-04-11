//import 'package:flyx/FloatingActionButton/fab_with_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flyx/HomePage/home.dart';


void main() {
  SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'OpenSans'),
      home: RootPage(),
    );
  }
}
