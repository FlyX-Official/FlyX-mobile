
//import 'package:flyx/FloatingActionButton/fab_with_icons.dart';
import 'package:flyx/FloatingActionButton/floating_action_button_homepage.dart';
import 'package:flyx/BottomAppBar/bottom_app_bar.dart';
import 'package:flyx/LoginPage/login_page.dart';
import 'package:flyx/SideBar/AppDrawer.dart';
import 'package:flyx/TicketDisplayer/ticketViewer.dart';
import 'package:flyx/TicketDisplayer/ticketCard.dart';
import 'package:flyx/profile/profile.dart';
import 'package:flyx/InputPage/inputForm.dart';
import 'package:flyx/settings/settings.dart';
import 'package:flyx/HomePage/home.dart';
import 'package:flyx/settings/pages/Bloc.dart';
// shared preferences
import 'package:shared_preferences/shared_preferences.dart';
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
    Profile.tag: (context) => Profile(),
    InputForm.tag: (context) => InputForm(),
    //Settings.tag: (context) => Settings(snapshot.data),

  };
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.darkThemeEnabled,
      initialData: false,
      builder: (context,snapshot)=>MaterialApp(
      //title: 'Flutter Demo',
        theme: snapshot.data?ThemeData.dark():ThemeData.light(),
        home: Settings(snapshot.data),//BttmAppBar(),//InputForm(),
        routes: routes,
    ),
    );
  }
}
