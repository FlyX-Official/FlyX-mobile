//import 'package:wefly/FloatingActionButton/fab_with_icons.dart';
import 'package:wefly/FloatingActionButton/floating_action_button_homepage.dart';
import 'package:wefly/BottomAppBar/bottom_app_bar.dart';
import 'package:wefly/LoginPage/login_page.dart';
import 'package:wefly/SideBar/AppDrawer.dart';
import 'package:wefly/TicketDisplayer/ticketViewer.dart';
// End of Local files
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

void main() {
  SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    FloatActBttn.tag: (context) => FloatActBttn(),
    LoginPage.tag: (context) => LoginPage(),
    AppDrawer.tag: (context) => AppDrawer(),
    BttmAppBar.tag: (context) => BttmAppBar(),
    TicketView.tag: (context) => TicketView(),
  };
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BttmAppBar(),
      routes: routes,
    );
  }
}
