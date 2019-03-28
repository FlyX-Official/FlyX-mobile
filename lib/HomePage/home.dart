import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flyx/LoginPage/login_page.dart';
import 'package:flyx/TicketDisplayer/ticketCard.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:rounded_modal/rounded_modal.dart';
import '../InputPage/gMap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../TicketDisplayer/ticketViewer.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

class HomePage extends StatefulWidget {
  static String tag = 'Home-page';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  Completer<GoogleMapController> _customGoogleMapController = Completer();

  final _pageviewcontroller = PageController();
  final _formKey = GlobalKey<FormState>();
  //TextEditingController _from = TextEditingController();
  TextEditingController _to = TextEditingController();
  TextEditingController _from = TextEditingController();
  bool _onTap = false;
  bool _isSearching = true;

  bool _isFromOpen;
  bool _isToOpen;

  int _onTapTextLength = 0;

  var _fromSlider = 1;
  var _toSlider = 1;
  IconData fabIcon = Icons.search;

  List responseTicketData;

  List<DateTime> _originDate;
  List<DateTime> _destinationDate;
  var ticketresponses;
  GoogleSignInAccount _currentUser;

  List<String> originData;
  List<String> destData;

  List<String> _searchFromList = List();
  List<String> _searchToList = List();

  List<String> _tmpList = List();
  String _searchFromField = "";
  String _searchToField = "";

  PageController _inputPage;

  @override
  void initState() {
    super.initState();
    _isSearching = false;
    _isFromOpen = false;
    _isToOpen = false;
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      _currentUser = account;
      ticketresponses = TicketListViewBuilder(
        data: responseTicketData,
      );

      setState(() {
        _currentUser = account;

        ticketresponses = TicketListViewBuilder(
          data: responseTicketData,
        );
      });
    });
    _googleSignIn.signInSilently();
    TicketListViewBuilder(
      data: responseTicketData,
    );
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  //GOogle map
  void _onMapCreated(GoogleMapController controller) {
    _customGoogleMapController.complete(controller);
  }
  //

//autocomplete

  dynamic _getFromData() async {
    while (_searchFromField.isNotEmpty) {
      _searchFromList = await _getFromSuggestions(_searchFromField) ?? null;

      return _searchFromList;
    }
  }

  dynamic _getToData() async {
    while (_searchToField.isNotEmpty) {
      _searchToList = await _getToSuggestions(_searchToField) ?? null;

      return _searchToList;
    }
  }

  dynamic getFromWidget() {
    //_buildSearchList();
    _getFromData();
    //_getToData();

    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height * .1,
      child: ListView.builder(
        reverse: true,
        itemCount: originData == null ? 0 : originData.length,
        itemBuilder: (context, i) {
          final fromItem = originData[i];
          return ListTile(
            title: Text('$fromItem'),
            onTap: () {
              print('$fromItem selected');
              setState(() {
                _from.text = fromItem;
                //_onTap = true;
                //_isSearching = false;
                _isFromOpen = false;
                _isToOpen = false;
              });
              /*if (form == 'to') {
                setState(() {
                form.text = item;
                _onTap = true;
                _isSearching = false;
                _isToOpen = true;
              });
              }*/
            },
          );
        },
      ),
    );
  }

  dynamic getToWidget() {
    //_buildSearchList();
    //_getFromData();
    _getToData();

    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height * .1,
      child: ListView.builder(
        reverse: true,
        itemCount: destData == null ? 0 : destData.length,
        itemBuilder: (context, i) {
          final toItem = destData[i];
          return ListTile(
            title: Text('$toItem '),
            onTap: () {
              print('$toItem  selected');
              setState(() {
                _to.text = toItem;
                //_onTap = true;
                //_isSearching = false;
                _isFromOpen = false;
                _isToOpen = false;
              });
              /*if (form == 'to') {
                setState(() {
                form.text = toItem ;
                _onTap = true;
                _isSearching = false;
                _isToOpen = true;
              });
              }*/
            },
          );
        },
      ),
    );
  }

  dynamic _getFromSuggestions(String hintText) async {
    String url =
        "https://flyx-web-hosted.herokuapp.com/autocomplete?q=$hintText";

    var response =
        await http.get(Uri.parse(url), headers: {"Accept": "application/json"});

    List decode = json.decode(response.body);
    dynamic sugg = decode[0]['Combined'];
    print("Top Suggestion ===> $sugg");
    if (response.statusCode != HttpStatus.ok || decode.length == 0) {
      return null;
    }
    List<String> suggestedWords = new List();

    if (decode.length == 0) return null;

    decode.forEach((f) => suggestedWords.add(f["Combined"]));
//    String data = decode[0]["word"];
    print("Suggestion List: ==> $suggestedWords");
    originData = suggestedWords;
    return suggestedWords;
  }

  dynamic _getToSuggestions(String hintText) async {
    String url =
        "https://flyx-web-hosted.herokuapp.com/autocomplete?q=$hintText";

    var response =
        await http.get(Uri.parse(url), headers: {"Accept": "application/json"});

    List decode = json.decode(response.body);
    dynamic sugg = decode[0]['Combined'];
    print("Top Suggestion ===> $sugg");
    if (response.statusCode != HttpStatus.ok || decode.length == 0) {
      return null;
    }
    List<String> suggestedWords = new List();

    if (decode.length == 0) return null;

    decode.forEach((f) => suggestedWords.add(f["Combined"]));
//    String data = decode[0]["word"];
    print("Suggestion List: ==> $suggestedWords");
    destData = suggestedWords;
    return suggestedWords;
  }

  _HomePageState() {
    _from.addListener(() {
      if (_from.text.isEmpty) {
        setState(() {
          _isSearching = true;
          _searchFromField = "";
          _isFromOpen = false;
          _searchFromList = List();
        });
      } else {
        setState(() {
          _isSearching = false;
          _isFromOpen = true;
          _searchFromField = _from.text;
          _onTap = _onTapTextLength == _searchFromField.length;
        });
      }
    });
    _to.addListener(() {
      if (_to.text.isEmpty) {
        setState(() {
          _isSearching = true;
          _searchToField = "";
          _isToOpen = false;
          _searchToList = List();
        });
      } else {
        setState(() {
          _isSearching = false;
          _isToOpen = true;
          _searchToField = _to.text;
          _onTap = _onTapTextLength == _searchToField.length;
        });
      }
    });
  }

//end autocomplete
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        //body:,
        floatingActionButton: FloatingActionButton(
          child: Icon(fabIcon),
          foregroundColor: Colors.black,
          backgroundColor: Colors.lightGreenAccent,
          onPressed: () {
            postToGlitchServer();
            TicketListViewBuilder(
              data: responseTicketData,
            );
            _pageviewcontroller.animateToPage(
              2,
              duration: Duration(milliseconds: 1000),
              curve: Curves.easeInOutExpo.flipped,
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        //floatingActionButtonAnimator,
        //persistentFooterButtons,
        //drawer,
        //endDrawer,
        //bottomSheet:,
        backgroundColor: Color.fromARGB(255, 247, 247, 247),
        body: SafeArea(
          child: PageView(
            onPageChanged: (i) {
              if (i == 0) {
                setState(() {
                  fabIcon = Icons.search;
                });
              } else if (i == 1) {
                setState(() {
                  fabIcon = Icons.payment;
                });
              }
            },
            controller: _pageviewcontroller,
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              //Container(child: LoginPage(),),
              SingleChildScrollView(
                controller: _inputPage,
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height * .3,
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.all(8),
                        //color: Color(0xc25737373),
                        child: Card(
                          color: Color(0xc25737373),
                          child: Center(
                            child: Container(
                              child: GoogleMap(
                                onMapCreated: _onMapCreated,
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(-33.852, 151.211),
                                  zoom: 11.0,
                                ),
                              ), //Text('Put Map here'), // CustomGoogleMap(),
                            ),
                          ),
                        ),
                      ),
                      Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.height * .6,
                            margin: EdgeInsets.all(8),
                            child: Card(
                              color: Color(0xc25737373),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Container(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .1),
                                            child: Container(
                                                child:
                                                    _isFromOpen //(_isSearching && (!_onTap))
                                                        ? getFromWidget()
                                                        : null),
                                          ),
                                          Container(
                                            //margin: EdgeInsets.only(top: 90),
                                            child: Card(
                                              elevation: 8,
                                              child: Padding(
                                                child: TextFormField(
                                                  controller: _from,
                                                  //focusNode: _flyingFromFocusNode,
                                                  validator: (value) {
                                                    if (value.isEmpty) {
                                                      return 'Field cannot be empty';
                                                    }
                                                  },
                                                  onFieldSubmitted:
                                                      (String value) {
                                                    print("$value submitted");
                                                    setState(() {
                                                      _from.text = value;
                                                      _onTap = true;
                                                    });
                                                  },
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    icon: Icon(
                                                      FontAwesomeIcons
                                                          .planeDeparture,
                                                      color: Colors.blue,
                                                      //size: 22.0,
                                                    ),
                                                    hintText: 'Flying From',
                                                    hintStyle: TextStyle(
                                                        fontFamily: "Nunito",
                                                        fontSize: 17.0),
                                                  ),
                                                ),
                                                padding: EdgeInsets.all(10),
                                              ),
                                            ),
                                          ),
                                          // Container(margin: EdgeInsets.only(top: 160),color: Colors.white,child: ExpansionTile(title: Text('this'),),),
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .4),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .6,
                                            child: Card(
                                              elevation: 8,
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: <Widget>[
                                                  Container(
                                                    child: Slider(
                                                      value: _fromSlider
                                                          .toDouble(),
                                                      min: 0.0,
                                                      max: 100.0,
                                                      divisions: 5,
                                                      label:
                                                          '$_fromSlider', //var _fromSlider = 1;,
                                                      onChanged:
                                                          (double newValue) {
                                                        setState(() {
                                                          _fromSlider =
                                                              newValue.round();
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  Text("$_fromSlider Mi"),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .025,
                                        width:
                                            MediaQuery.of(context).size.width,
                                      ),
                                    ),
                                    Container(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .1),
                                            child: Container(
                                                child:
                                                    _isToOpen //(_isSearching && (!_onTap))
                                                        ? getToWidget()
                                                        : null),
                                          ),
                                          Container(
                                            //margin: EdgeInsets.only(top: 90),
                                            child: Card(
                                              elevation: 8,
                                              child: Padding(
                                                child: TextFormField(
                                                  controller: _to,
                                                  validator: (value) {
                                                    if (value.isEmpty) {
                                                      return 'Field cannot be empty';
                                                    }
                                                  },
                                                  onFieldSubmitted:
                                                      (String value) {
                                                    print("$value submitted");
                                                    setState(() {
                                                      _to.text = value;
                                                      _onTap = true;
                                                    });
                                                  },
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    icon: Icon(
                                                      FontAwesomeIcons
                                                          .planeDeparture,
                                                      color: Colors.blue,
                                                      //size: 22.0,
                                                    ),
                                                    hintText: 'Flying To',
                                                    hintStyle: TextStyle(
                                                        fontFamily: "Nunito",
                                                        fontSize: 17.0),
                                                  ),
                                                ),
                                                padding: EdgeInsets.all(10),
                                              ),
                                            ),
                                          ),
                                          // Container(margin: EdgeInsets.only(top: 160),color: Colors.white,child: ExpansionTile(title: Text('this'),),),
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .4),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .6,
                                            child: Card(
                                              elevation: 8,
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: <Widget>[
                                                  Container(
                                                    child: Slider(
                                                      value: _toSlider
                                                          .ceilToDouble(),
                                                      min: 0.0,
                                                      max: 100.0,
                                                      divisions: 5,
                                                      label:
                                                          '$_toSlider', //var _toSlider = 1;,
                                                      onChanged:
                                                          (double newValue) {
                                                        setState(() {
                                                          _toSlider =
                                                              newValue.round();
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  Text("$_toSlider Mi"),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .025,
                                        width:
                                            MediaQuery.of(context).size.width,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .47,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .1,
                                          child: Card(
                                            elevation: 8,
                                            color: Color.fromARGB(
                                                200, 255, 255, 255),
                                            child: FlatButton(
                                              color: Colors.white,
                                              onPressed: () async {
                                                final List<DateTime>
                                                    originPicked =
                                                    await DateRangePicker
                                                        .showDatePicker(
                                                            context: context,
                                                            initialFirstDate:
                                                                new DateTime
                                                                    .now(),
                                                            initialLastDate:
                                                                (new DateTime
                                                                        .now())
                                                                    .add(new Duration(
                                                                        days:
                                                                            7)),
                                                            firstDate:
                                                                new DateTime(
                                                                    2019),
                                                            lastDate:
                                                                new DateTime(
                                                                    2020));
                                                if (originPicked != null &&
                                                    originPicked.length == 2) {
                                                  print(originPicked);
                                                  _originDate =
                                                      originPicked.toList();
                                                }
                                              },
                                              child: Icon(Icons.date_range),
                                              /*child: Text(
                                    '${DateTime.now().month}-${DateTime.now().day}-${DateTime.now().year} <-> ' +
                                        '${DateTime.now().month}-${DateTime.now().day + 7}-${DateTime.now().year}' +
                                        '$_originDate'
                                        'yyyy-mm-dd <---> yyyy-mm-dd'
                                    ),*/
                                              //'Departure Date Picker'),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .47,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .1,
                                          child: Card(
                                            elevation: 8,
                                            color: Color.fromARGB(
                                                200, 255, 255, 255),
                                            child: FlatButton(
                                              color: Colors.white,
                                              onPressed: () async {
                                                final List<DateTime>
                                                    returnDatePicked =
                                                    await DateRangePicker.showDatePicker(
                                                        context: context,
                                                        initialFirstDate:
                                                            new DateTime.now()
                                                                .add(Duration(
                                                                    days: 7)),
                                                        initialLastDate:
                                                            (new DateTime.now())
                                                                .add(new Duration(
                                                                    days: 14)),
                                                        firstDate:
                                                            new DateTime(2019),
                                                        lastDate:
                                                            new DateTime(2020));
                                                if (returnDatePicked != null &&
                                                    returnDatePicked.length ==
                                                        2) {
                                                  print(returnDatePicked);
                                                  _destinationDate =
                                                      returnDatePicked.toList();
                                                }
                                              },
                                              child: Icon(Icons.date_range),
                                              /*Text(
                                  '${DateTime.now().month}-${DateTime.now().day + 7}-${DateTime.now().year} <-> ' +
                                      '${DateTime.now().month}-${DateTime.now().day + 14}-${DateTime.now().year}'
                                      'yyyy-mm-dd <---> yyyy-mm-dd',
                                ),*/
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      //color: Colors.red,
                                      child: SizedBox(
                                        height: 20,
                                        width:
                                            MediaQuery.of(context).size.width,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                child: Container(
                  height: MediaQuery.of(context).size.height * .85,
                  child: Container(
                    child: TicketListViewBuilder(
                      data: responseTicketData,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        //resizeToAvoidBottomInset:,

        bottomNavigationBar: BottomAppBar(
          notchMargin: 8,
          elevation: 8,
          clipBehavior: Clip.antiAlias,
          shape: CircularNotchedRectangle(),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                child: IconButton(
                  icon: Icon(Icons.explore),
                  color: Colors.black,
                  highlightColor: Colors.redAccent,
                  onPressed: () {
                    // _scaffoldKey.currentState.openDrawer();
                  }, //showMenu,
                ),
              ),
              Container(
                child: IconButton(
                  icon: Icon(Icons.edit_location),
                  color: Colors.black,
                  highlightColor: Colors.redAccent,
                  onPressed: () {
                    // _scaffoldKey.currentState.openDrawer();
                  }, //showMenu,
                ),
              ),
              Container(
                child: Icon(
                  FontAwesomeIcons.envira,
                  color: Color.fromARGB(0, 0, 0, 0),
                ),
              ),
              Container(
                child: IconButton(
                  icon: Icon(Icons.notifications),
                  color: Colors.black,
                  highlightColor: Colors.blue,
                  onPressed: () {
                    // _scaffoldKey.currentState.openDrawer();
                  }, //showMenu,
                ),
              ),
              IconButton(
                icon: Icon(Icons.account_box),
                color: Colors.black,
                highlightColor: Colors.orange,
                onPressed: () => showModalMenu(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showModalMenu() {
    showRoundedModalBottomSheet(
      context: context,
      radius: 16,
      color: Colors.white,
      builder: (BuildContext context) {
        return Container(
          //color: Colors.black54,
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                SizedBox(
                    height: MediaQuery.of(context).size.height * .45,
                    child: ListView(
                      physics: NeverScrollableScrollPhysics(),
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Card(
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
        );
      },
    );
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
      'oneWay': false,
      'from': "${_from.text}",
      'to': '${_to.text}',
      'radiusFrom': _fromSlider,
      'radiusTo': _toSlider,
      "departureWindow": {
        'start': _originDate[0].toString(),
        'end': _originDate[1].toString(),
      }, //_originDate.toList(),
      "returnDepartureWindow": {
        'start': _destinationDate[0].toString(),
        'end': _destinationDate[1].toString(),
      }, // _destinationDate.toList(),
      //"TimeStamp": DateTime.now(),
    };
  }

  postToGlitchServer() {
    var testData = postToGlitchServerData();

    var testDataEnc = json.encode(testData);
    print(testDataEnc);
    var url =
        "https://flyx-web-hosted.herokuapp.com/search"; //https://olivine-pamphlet.glitch.me/testpost";
    http.post(
      url,
      body: testDataEnc,
      headers: {"Content-Type": "application/json"},
    ).then((response) {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      dynamic responseData = jsonDecode(response.body);
      responseTicketData = responseData["data"];
      TicketListViewBuilder(
        data: responseTicketData,
      );
      setState(() {
        var responseData = json.decode(response.body);
        //search_par = responseData["tickets"]["search_params"];
        responseTicketData = responseData["data"];
      });
    });

//http.read("https://olivine-pamphlet.glitch.me/").then(print);
  }
}
