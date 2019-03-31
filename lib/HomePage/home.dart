import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:rounded_modal/rounded_modal.dart';
import 'package:geohash/geohash.dart';

import '../TicketDisplayer/ticketCard.dart';

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

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId selectedMarker;
  int _markerIdCounter = 1;

  LatLng decodedGeoHash;
  var center;

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
    center = Geohash.decode(decode[0]['location']);
    var latitude = center.x;
    var longitude = center.y;
    decodedGeoHash = LatLng(latitude, longitude);
    print(decodedGeoHash);
    print("Top Suggestion ===> $sugg");
    if (response.statusCode != HttpStatus.ok || decode.length == 0) {
      return null;
    }
    List<String> suggestedWords = List();

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
    center = Geohash.decode(decode[0]['location']);
    var latitude = center.x;
    var longitude = center.y;
    decodedGeoHash = LatLng(latitude, longitude);
    print(decodedGeoHash);
    print("Top Suggestion ===> $sugg");
    if (response.statusCode != HttpStatus.ok || decode.length == 0) {
      return null;
    }
    List<String> suggestedWords = List();

    if (decode.length == 0) return null;

    decode.forEach((f) => suggestedWords.add(f["Combined"]));

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
  void _onMarkerTapped(MarkerId markerId) {
    final Marker tappedMarker = markers[markerId];
    if (tappedMarker != null) {
      setState(() {
        if (markers.containsKey(selectedMarker)) {
          final Marker resetOld = markers[selectedMarker]
              .copyWith(iconParam: BitmapDescriptor.defaultMarker);
          markers[selectedMarker] = resetOld;
        }
        selectedMarker = markerId;
        final Marker newMarker = tappedMarker.copyWith(
          iconParam: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        );
        markers[markerId] = newMarker;
      });
    }
  }

  void _addAirportMarkers() {
    final int markerCount = markers.length;

    if (markerCount == 12) {
      return;
    }

    final String markerIdVal = 'marker_id_$_markerIdCounter';
    _markerIdCounter++;
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(
        decodedGeoHash.latitude,
        decodedGeoHash.longitude,
      ),
      infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
      onTap: () {
        _onMarkerTapped(markerId);
      },
    );

    setState(() {
      markers[markerId] = marker;
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              //Container(child: LoginPage(),),
              SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                controller: _inputPage,
                child: Container(
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height * .5,

                        //margin: EdgeInsets.all(8),
                        //color: Color(0xc25737373),
                        child: Card(
                          color: Color(0xc25737373),
                          child: Center(
                            child: Container(
                              child: GoogleMap(
                                mapType: MapType.normal,
                                myLocationEnabled: true,
                                compassEnabled: true,
                                onMapCreated: _onMapCreated,
                                zoomGesturesEnabled: true,
                                markers: Set<Marker>.of(markers.values),
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(40.5436, -101.9734347),
                                  zoom: 1.0,
                                  tilt: 45,
                                ),
                              ), //Text('Put Map here'), // CustomGoogleMap(),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * .4),
                        child: Stack(
                          alignment: AlignmentDirectional.bottomCenter,
                          children: <Widget>[
                            Container(
                              height: MediaQuery.of(context).size.height * .66,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(24),
                                  topRight: Radius.circular(24),
                                ),
                              ),
                              //color: Colors.blue,
                              child: Container(
                                margin: EdgeInsets.only(top: 24),
                                child: SingleChildScrollView(
                                  //height: MediaQuery.of(context).size.height * .6,
                                  //margin: EdgeInsets.all(8),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.only(bottom: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.max,
                                            children: <Widget>[
                                              FlatButton(
                                                child: Text('ONE WAY'),
                                                color: Colors.white70,
                                                onPressed: _addAirportMarkers,
                                              ),
                                              FlatButton(
                                                child: Text(''),
                                                color: Colors.transparent,
                                                onPressed: () {},
                                              ),
                                              FlatButton(
                                                child: Text('ROUND TRIP'),
                                                color: Colors.white70,
                                                onPressed: () {},
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
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
                                                        print(
                                                            "$value submitted");
                                                        setState(() {
                                                          _from.text = value;
                                                          _onTap = true;
                                                        });
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        icon: Icon(
                                                          FontAwesomeIcons
                                                              .planeDeparture,
                                                          color: Colors.blue,
                                                          //size: 22.0,
                                                        ),
                                                        hintText: 'Flying From',
                                                        hintStyle: TextStyle(
                                                            fontFamily:
                                                                "Nunito",
                                                            fontSize: 17.0),
                                                      ),
                                                    ),
                                                    padding: EdgeInsets.all(8),
                                                  ),
                                                ),
                                              ),
                                              // Container(margin: EdgeInsets.only(top: 160),color: Colors.white,child: ExpansionTile(title: Text('this'),),),
                                              InkWell(
                                                onTap: () {
                                                  _addAirportMarkers();
                                                },
                                                child: Container(
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
                                                              .center,
                                                      children: <Widget>[
                                                        Container(
                                                          child: Slider(
                                                            value: _fromSlider
                                                                .toDouble(),
                                                            min: 1.0,
                                                            max: 100.0,
                                                            divisions: 5,
                                                            label:
                                                                '$_fromSlider', //var _fromSlider = 1;,
                                                            onChanged:
                                                                (double Value) {
                                                              _addAirportMarkers();
                                                              setState(() {
                                                                _fromSlider =
                                                                    Value
                                                                        .floor();
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                        Text("$_fromSlider Mi"),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .025,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
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
                                                        print(
                                                            "$value submitted");
                                                        setState(() {
                                                          _to.text = value;
                                                          _onTap = true;
                                                        });
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        icon: Icon(
                                                          FontAwesomeIcons
                                                              .planeDeparture,
                                                          color: Colors.blue,
                                                          //size: 22.0,
                                                        ),
                                                        hintText: 'Flying To',
                                                        hintStyle: TextStyle(
                                                            fontFamily:
                                                                "Nunito",
                                                            fontSize: 17.0),
                                                      ),
                                                    ),
                                                    padding: EdgeInsets.all(8),
                                                  ),
                                                ),
                                              ),
                                              // Container(margin: EdgeInsets.only(top: 160),color: Colors.white,child: ExpansionTile(title: Text('this'),),),
                                              InkWell(
                                                onTap: () {
                                                  _addAirportMarkers();
                                                },
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .6,
                                                  child: Card(
                                                    elevation: 8,
                                                    color: Color.fromARGB(
                                                        255, 255, 255, 255),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Container(
                                                          child: Slider(
                                                            value: _toSlider
                                                                .ceilToDouble(),
                                                            min: 1.0,
                                                            max: 100.0,
                                                            divisions: 5,
                                                            label:
                                                                '$_toSlider', //var _toSlider = 1;,
                                                            onChanged:
                                                                (double Value) {
                                                              _addAirportMarkers();
                                                              setState(() {
                                                                _toSlider = Value
                                                                    .round();
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                        Text("$_toSlider Mi"),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .025,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: <Widget>[
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .5,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .085,
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
                                                                context:
                                                                    context,
                                                                initialFirstDate:
                                                                    DateTime
                                                                        .now(),
                                                                initialLastDate: (DateTime
                                                                        .now())
                                                                    .add(Duration(
                                                                        days:
                                                                            7)),
                                                                firstDate:
                                                                    DateTime(
                                                                        2019),
                                                                lastDate:
                                                                    DateTime(
                                                                        2020));
                                                    if (originPicked != null &&
                                                        originPicked.length ==
                                                            2) {
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
                                                  .5,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .085,
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
                                                                DateTime.now()
                                                                    .add(Duration(
                                                                        days:
                                                                            7)),
                                                            initialLastDate:
                                                                (DateTime.now())
                                                                    .add(Duration(
                                                                        days:
                                                                            14)),
                                                            firstDate:
                                                                DateTime(2019),
                                                            lastDate:
                                                                DateTime(2020));
                                                    if (returnDatePicked !=
                                                            null &&
                                                        returnDatePicked
                                                                .length ==
                                                            2) {
                                                      print(returnDatePicked);
                                                      _destinationDate =
                                                          returnDatePicked
                                                              .toList();
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
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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
      ),
    );
  }

  void showModalMenu() {
    showRoundedModalBottomSheet(
      context: context,
      radius: 16,
      color: Color.fromARGB(255, 247, 247, 247),
      builder: (BuildContext context) {
        return Container(
          //color: Colors.black54,
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                SizedBox(
                    height: MediaQuery.of(context).size.height * .50,
                    child: ListView(
                      physics: BouncingScrollPhysics(),
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
                        Container(
                          margin: EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Card(
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                                child: ListTile(
                                  leading: Icon(Icons.attach_money),
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
                              ),
                            ],
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
