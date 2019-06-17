import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//Pages
import 'Pages/HomePage/HomePage.dart';
import 'Pages/Login/LoginPageRoot.dart';
//End-Pages

void main() {
  SystemChrome.setEnabledSystemUIOverlays([]);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlyX',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        iconTheme: IconThemeData(
          color: Color.fromARGB(255, 10, 203, 171), //Custom Green Color
        ),
        fontFamily: 'GoogleSans',
        buttonColor: Color.fromARGB(255, 10, 203, 171), //Custom Green Color
        primaryColorDark: Color.fromARGB(255, 34, 31, 37),
        primaryColorLight:
            Color.fromARGB(255, 205, 205, 205), //Custom White Color
      ),
      home: HomePage(),
     //home:Loginpage(),
    );
  }
}
