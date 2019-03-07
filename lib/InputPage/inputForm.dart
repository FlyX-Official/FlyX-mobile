import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flyx/InputPage/gMap.dart';
import 'package:flyx/BottomAppBar/bottom_app_bar.dart';
import 'package:flyx/FloatingActionButton/floating_action_button_homepage.dart'; //tmp only

import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;

class InputForm extends StatefulWidget {
  static String tag = 'Input-Page';

  final Widget child;

  InputForm({Key key, this.child}) : super(key: key);

  _InputFormState createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  var _fromSlider = 1;
  var _toSlider = 1; // Initial Slider Value
  PageController _pageController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    dynamic _height = MediaQuery.of(context).size.height;
    dynamic _width = MediaQuery.of(context).size.width;
    dynamic _fourFifths = _width * .8;

    return Scaffold(
      backgroundColor: Colors.blueAccent,
      bottomNavigationBar: _buildBottomAppBar(),
      floatingActionButton: _buildFab(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: _buildSafeArea(context),
    );
  }

  SafeArea _buildSafeArea(BuildContext context) {
    return SafeArea(
      
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        controller: _pageController,
        
        child: Container(
          color: Colors.blue,
          child: Column(
            //controller: _pageController,
            //scrollDirection: Axis.vertical,

            ///mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  //alignment: Alignment.bottomCenter,
                  //overflow: Overflow.visible,
                  children: <Widget>[
                    Container(
                      child: CustomGoogleMap(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          //height: _fourFifths,
                          child: originLocation(
                              "From", FontAwesomeIcons.planeDeparture),
                        ),
                        Container(
                          //height: _fourFifths,
                          child: originLocation(
                              "To", FontAwesomeIcons.planeArrival),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          child: buildFromSlider(),
                        ),
                        Container(
                          child: buildToSlider(),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          child: new Cal(),
                        ),
                        Container(
                          child: new Cal(),
                        ),
                      ],
                    ),
                    /*Container(
                      child: buildMaterialButton(context),
                    ),*/
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildFromSlider() {
    return Container(
      width: MediaQuery.of(context).size.width * .5,
      child: Card(
        elevation: 8,
        child: Padding(
          padding: EdgeInsets.all(25),
          child: Column(
            children: <Widget>[
              Text("Origin Airport Radius"),
              Container(
                width: MediaQuery.of(context).size.width * .5,
                child: Slider(
                  value: _fromSlider.toDouble(),
                  min: 1.0,
                  max: 50.0,
                  divisions: 10,
                  label: '$_fromSlider', //var _toSlider = 1;,
                  onChanged: (double newValue) {
                    setState(() {
                      _fromSlider = newValue.round();
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildToSlider() {
    return Container(
      width: MediaQuery.of(context).size.width * .5,
      child: Card(
        elevation: 8,
        child: Padding(
          padding: EdgeInsets.all(25),
          child: Column(
            children: <Widget>[
              Text("Destination Airport Radius"),
              Container(
                child: Slider(
                  value: _toSlider.toDouble(),
                  min: 1.0,
                  max: 50.0,
                  divisions: 10,
                  label: '$_toSlider', //var _toSlider = 1;,
                  onChanged: (double newValue) {
                    setState(() {
                      _toSlider = newValue.round();
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildMaterialButton(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .5,
      height: MediaQuery.of(context).size.height * .075,
      padding: EdgeInsets.all(5),
      child: RaisedButton(
          highlightColor: Colors.transparent,
          color: Colors.greenAccent,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          child: Text("Search",
              style: TextStyle(
                color: Colors.white,
                fontSize: 25.0,
                fontFamily: "Nunito",
              )),
          onPressed: () {
            //Navigator.of(context).pushNamed(FloatActBttn.tag);
            Navigator.of(context).pushNamed(BttmAppBar.tag);
          }),
    );
  }

  Container originLocation(String text, dynamic fieldIcon) {
    return Container(
      width: MediaQuery.of(context).size.width * .5,
      height: MediaQuery.of(context).size.height * .1,
      child: Card(
        elevation: 8,
        child: Padding(
          padding: EdgeInsets.all(25.0),
          child: TextFormField(
            autofocus: false,
            //focusNode: myFocusNodeEmailLogin,
            //controller: loginEmailController,
            keyboardType: TextInputType.text,
            style: TextStyle(
                fontFamily: "Nunito", fontSize: 16.0, color: Colors.black),
            decoration: InputDecoration(
              border: InputBorder.none,
              icon: Icon(
                fieldIcon,
                color: Colors.black,
                size: 22.0,
              ),
              hintText: text,
              hintStyle: TextStyle(fontFamily: "Nunito", fontSize: 17.0),
            ),
          ),
        ),
      ),
    );
  }

  BottomAppBar _buildBottomAppBar() {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.menu),
            color: Colors.black,
            highlightColor: Colors.redAccent,
            onPressed: () {
              _scaffoldKey.currentState.openDrawer();
            },
          ),
          IconButton(
            icon: Icon(Icons.edit_location),
            color: Colors.black,
            highlightColor: Colors.redAccent,
            onPressed: () {
              Navigator.of(context).pushNamed(InputForm.tag);
            },
          ),
          SizedBox(
            height: 60,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ),
          IconButton(
            icon: Icon(Icons.notifications),
            color: Colors.black,
            highlightColor: Colors.redAccent,
            onPressed: () {
              // _scaffoldKey.currentState.openDrawer();
            },
          ),
          IconButton(
            icon: Icon(Icons.account_box),
            color: Colors.black,
            highlightColor: Colors.redAccent,
            onPressed: () {
              Navigator.of(context).pushNamed(FloatActBttn.tag);
            },
          )
        ],
      ),
    );
  }
}

class Cal extends StatelessWidget {
  const Cal({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .5,
      height: MediaQuery.of(context).size.height * .1,
      child: Card(
        elevation: 8,
        child: FlatButton(
            color: Colors.white,
            onPressed: () async {
              final List<DateTime> picked = await DateRagePicker.showDatePicker(
                  context: context,
                  initialFirstDate: new DateTime.now(),
                  initialLastDate:
                      (new DateTime.now()).add(new Duration(days: 7)),
                  firstDate: new DateTime(2015),
                  lastDate: new DateTime(2020));
              if (picked != null && picked.length == 2) {
                print(picked);
              }
            },
            child: new Text("Pick date range")),
      ),
    );
  }
}
Widget _buildFab(BuildContext context) {
  return FloatingActionButton(
    onPressed: () {
      Navigator.of(context).pushNamed(BttmAppBar.tag);
    },
    tooltip: 'fab',
    elevation: 4.0,
    highlightElevation: 12,
    //shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(8)),
    child: Icon(Icons.search),
    backgroundColor: Colors.white,
    foregroundColor: Colors.lightGreen,
  );
}