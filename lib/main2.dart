import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_icons/font_awesome.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        //
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black,
      body: Center(
        child: Container(
          height: 115,
          color: Colors.white,
          child: FlutterSlider(
            step: 5,            
            visibleTouchArea: false,
            axis: Axis.vertical,
            rtl: true,
            min: 1,
            max: 100,
            values: [1],
            handler: FlutterSliderHandler(
              child: Icon(
                FontAwesomeIcons.arrowCircleUp,
                color: Colors.orangeAccent
              ),
            ),
          ),
        ),
      ),
    );
  }
}
