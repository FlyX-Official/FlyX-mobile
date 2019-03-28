import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flyx/InputPage/gMap.dart';
import 'package:flyx/BottomAppBar/bottom_app_bar.dart';
import 'package:flyx/FloatingActionButton/floating_action_button_homepage.dart'; //tmp only
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flyx/LoginPage/login_page.dart';
import 'package:flyx/settings/settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

class InputForm extends StatefulWidget {
  static String tag = 'Input-Page';

  final Widget child;

  InputForm({Key key, this.child}) : super(key: key);

  _InputFormState createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  var _fromSlider = 1;
  var _toSlider = 1; // Initial Slider Value
  //String _from;
  //String _to;
  List<DateTime> _originDate;

  List<DateTime> _destinationDate;

  TextEditingController _from = TextEditingController();
  TextEditingController _to = TextEditingController();

  PageController _pageController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  GoogleSignInAccount _currentUser;
  @override
  bool _mode = true;
  void _onChangedMode(bool value) => setState(() => _mode = value);
  void initState() {
    super.initState();

    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
  }

  @override
  Widget build(BuildContext context) {
    dynamic _height = MediaQuery.of(context).size.height;
    dynamic _width = MediaQuery.of(context).size.width;
    dynamic _fourFifths = _width * .8;

    return Scaffold(
      //backgroundColor: Colors.blueAccent,
      //bottomNavigationBar: _buildBottomAppBar(),
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
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          color: Colors.blue,
          child: Stack(
            children: <Widget>[
              Container(
                child: CustomGoogleMap(),
              ),
              Column(
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
                        /*Container(
                          child: CustomGoogleMap(),
                        ),*/
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              //height: _fourFifths,
                              child: originLocation(
                                  "From", FontAwesomeIcons.planeDeparture),
                            ),
                            Container(
                              //height: _fourFifths,
                              child: destinationLocation(
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
                              child: Column(
                                children: <Widget>[
                                  _originCal(context),
                                  //Text(DateRangePicker),
                                ],
                              ),
                            ),
                            Container(
                              child: _destinationCal(context),
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
        color: Color.fromARGB(200, 255, 255, 255),
        elevation: 8,
        child: Padding(
          padding: EdgeInsets.all(25),
          child: Column(
            children: <Widget>[
              Text("Origin Radius"),
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
        color: Color.fromARGB(200, 255, 255, 255),
        elevation: 8,
        child: Padding(
          padding: EdgeInsets.all(25),
          child: Column(
            children: <Widget>[
              Text("Destination Radius"),
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
      width: MediaQuery.of(context).size.width * .95,
      //height: MediaQuery.of(context).size.height * .1,
      child: Card(
        color: Color.fromARGB(200, 255, 255, 255),
        elevation: 8,
        child: Padding(
          padding: EdgeInsets.all(25.0),
          child: TextFormField(
            autofocus: false,
            autocorrect: true,

            //focusNode: myFocusNodeEmailLogin,
            controller: _from,
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

  Container destinationLocation(String text, dynamic fieldIcon) {
    return Container(
      width: MediaQuery.of(context).size.width * .95,
      //height: MediaQuery.of(context).size.height * .1,
      child: Card(
        color: Color.fromARGB(200, 255, 255, 255),
        elevation: 8,
        child: Padding(
          padding: EdgeInsets.all(25.0),
          child: TextFormField(
            autofocus: false,
            autocorrect: true,

            //focusNode: myFocusNodeEmailLogin,
            controller: _to,
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

// retrun date range show roundtrip until clicked
  BottomAppBar _buildBottomAppBar() {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.menu),
            color: Colors.red,
            highlightColor: Colors.redAccent,
            onPressed: () {
              _scaffoldKey.currentState.openDrawer();
            }, //showMenu,
          ),
          IconButton(
            icon: Icon(Icons.edit_location),
            color: Colors.blue,
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
            color: Colors.green,
            highlightColor: Colors.redAccent,
            onPressed: () {
              // _scaffoldKey.currentState.openDrawer();
              Navigator.of(context).pushNamed(LoginPage.tag);
            },
          ),
          IconButton(
            icon: Icon(Icons.account_box),
            color: Colors.orange,
            highlightColor: Colors.redAccent,
            onPressed:
                () {}, /* () {
              Navigator.of(context).pushNamed(FloatActBttn.tag);
            },*/
          )
        ],
      ),
    );
  }

  showModalMenu() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Color(0xcFF737373),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: SafeArea(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                color: Colors.green,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    SizedBox(
                        height: MediaQuery.of(context).size.height * .45,
                        child: ListView(
                          physics: AlwaysScrollableScrollPhysics(),
                          children: <Widget>[
                            Card(
                              elevation: 8,
                              child: UserAccountsDrawerHeader(
                                accountName:
                                    Text("Name: ${_currentUser.displayName}"),
                                accountEmail:
                                    Text("Email: ${_currentUser.email}"),
                                currentAccountPicture:
                                    Image.network(_currentUser.photoUrl),
                              ),
                            ),
                            Card(
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              child: ListTile(
                                leading: Icon(Icons.monetization_on),
                                title: Text("Currency"),
                              ),
                            ),
                            Card(
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              child: ListTile(
                                leading: Icon(Icons.monetization_on),
                                title: Text("Preferred Airport"),
                              ),
                            )
                          ],
                        )),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  postToGlitchServer() {
    var testData = postToGlitchServerData();
    var testDataEnc = json.encode(testData);
    var url =
        "https://flyx-web-hosted.herokuapp.com/search"; //https://olivine-pamphlet.glitch.me/testpost";
    http.post(
      url,
      body: testDataEnc,
      headers: {"Content-Type": "application/json"},
    ).then((response) {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
    });

    //http.read("https://olivine-pamphlet.glitch.me/").then(print);
  }

  Map<String, Object> postToGlitchServerData() {
    return {
      /* 'Origin': "${_from.text}",
        'Destination': '${_to.text}',
        'OriginAirportRadius': _fromSlider,
        'DestinationAirportRadius': _toSlider,
        'OriginDate': _originDate.toString(),
        'DestinationDate': _destinationDate.toString(),
        'TimeStamp': DateTime.now().toString(),*/
      'oneWay': true,
      'from': "${_from.text}",
      'to': '${_to.text}',
      'radiusFrom': _fromSlider,
      'radiusTo': _toSlider,
      "departureWindow": {
        'start': _originDate[0].toString(),
        'end': _originDate[1].toString(),
      }, //_originDate.toList(),
      "roundTripDepartureWindow": {
        'start': _destinationDate[0].toString(),
        'end': _destinationDate[1].toString(),
      }, // _destinationDate.toList(),
      //"TimeStamp": DateTime.now(),
    };
  }

  Widget _buildFab(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        postToGlitchServer();
        Firestore.instance
            .collection("TicketQueries")
            .document()
            .setData(postDataToFireStore());
        //Navigator.of(context).pushNamed(BttmAppBar.tag);
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

  Map<String, dynamic> postDataToFireStore() {
    return {
      'from': "${_from.text}",
      'to': '${_to.text}',
      'radiusFrom': _fromSlider,
      'radiusTo': _toSlider,
      "departureWindow": _originDate.toList(),
      "roundTripDepartureWindow": _destinationDate.toList(),
      "TimeStamp": DateTime.now(),
    };
  }

  Widget _originCal(BuildContext context) {
    dynamic dateTimeStamp = "Pick Date range";
    return Container(
      width: MediaQuery.of(context).size.width * .5,
      height: MediaQuery.of(context).size.height * .1,
      child: Card(
        color: Color.fromARGB(200, 255, 255, 255),
        elevation: 8,
        child: FlatButton(
          color: Colors.white,
          onPressed: () async {
            final List<DateTime> originPicked =
                await DateRangePicker.showDatePicker(
                    context: context,
                    initialFirstDate: new DateTime.now(),
                    initialLastDate:
                        (new DateTime.now()).add(new Duration(days: 7)),
                    firstDate: new DateTime(2019),
                    lastDate: new DateTime(2020));
            if (originPicked != null && originPicked.length == 2) {
              print(originPicked);
              _originDate = originPicked.toList();
            }
          },
          child: Text(dateTimeStamp),
        ),
      ),
    );
  }

  Widget _destinationCal(BuildContext context) {
    dynamic dateTimeStamp = "Pick Date range";
    return Container(
      width: MediaQuery.of(context).size.width * .5,
      height: MediaQuery.of(context).size.height * .1,
      child: Card(
        color: Color.fromARGB(200, 255, 255, 255),
        elevation: 8,
        child: FlatButton(
          color: Colors.white,
          onPressed: () async {
            final List<DateTime> destinationPicked =
                await DateRangePicker.showDatePicker(
                    context: context,
                    initialFirstDate: new DateTime.now(),
                    initialLastDate:
                        (new DateTime.now()).add(new Duration(days: 7)),
                    firstDate: new DateTime(2019),
                    lastDate: new DateTime(2020));
            if (destinationPicked != null && destinationPicked.length == 2) {
              print(destinationPicked);
              _destinationDate = destinationPicked.toList();
            }
          },
          child: Text(dateTimeStamp),
        ),
      ),
    );
  }
}
