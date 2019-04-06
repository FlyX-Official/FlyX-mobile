//import 'package:flyx/FloatingActionButton/fab_with_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flyx/LoginPage/login_page.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() {
  SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  GoogleSignInAccount _currentUser;
  final routes = <String, WidgetBuilder>{
  };
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'OpenSans'),
      home: LoginPage(),
      routes: routes,

    );
  }
}
