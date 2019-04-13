import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flyx/Auth/auth.dart';
import 'package:flyx/HomePage/oldhome.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geohash/geohash.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:groovin_widgets/groovin_widgets.dart';
import 'package:rounded_modal/rounded_modal.dart';
import 'package:rubber/rubber.dart';
import 'package:http/http.dart' as http;
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;

final GoogleSignIn _googleSignIn = GoogleSignIn();

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  GlobalKey _rubberBotSheetKey = GlobalKey();

  final lowerLayerPageViewController = PageController();

  _HomePageState() {
    authService.profile.listen((state) => setState(() => _profile = state));

    authService.loading.listen((state) => setState(() => _loading = state));
    _from.addListener(() {
      if (_from.text.isEmpty) {
        setState(() {
          _searchFromField = "";
          _isFromOpen = false;
          _searchFromList = List();
        });
      }
      if (_from.text.length > 0) {
        setState(() {
          _isFromOpen = true;
          _searchFromField = _from.text;
          //_onTap = _onTapTextLength == _searchFromField.length;
        });
      }
    });
    _to.addListener(() {
      if (_to.text.isEmpty) {
        setState(() {
          _searchToField = "";
          _isToOpen = false;
          _searchToList = List();
        });
      }
      if (_to.text.length > 0) {
        setState(() {
          _isToOpen = true;
          _searchToField = _to.text;
          // _onTap = _onTapTextLength == _searchToField.length;
        });
      }
    });
  }

  Map<String, dynamic> _profile;
  bool _loading = false;

  RubberAnimationController _controller;
  ScrollController _scrollController = ScrollController();

  final GlobalKey<FormState> _tickerSearchFormKey = GlobalKey<FormState>();
  Completer<GoogleMapController> _customGoogleMapController = Completer();

  int _markerIdCounter = 1;

  double _lowerValue = 1, _upperValue = 100;

  double _fromSlider = 1, _toSlider = 1;

  bool _isFromOpen, _isToOpen;

  GoogleSignInAccount _currentUser;

  TextEditingController _from = TextEditingController();
  TextEditingController _to = TextEditingController();

  String _searchFromField = "", _searchToField = "";
  List<String> _searchFromList = List(), _searchToList = List();

  var center;
  LatLng decodedGeoHash;
  List<String> destData, originData;
  IconData fabIcon = Icons.search;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{},
      markers1 = <MarkerId, Marker>{};
  List responseTicketData;
  MarkerId selectedMarker;
  var ticketresponses;

  List<DateTime> _originDate, _destinationDate;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData _mediaQuery = MediaQuery.of(context);
    final dynamic _upperLayerWidth = _mediaQuery.size.width * .95;
    final dynamic _backGroundColor = Color.fromARGB(255, 247, 247, 247);
    var _color2 = Color.fromARGB(255, 100, 135, 165);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: _color2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
          actionsIconTheme: IconThemeData(color: Colors.white),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: Icon(Icons.account_box),
                onPressed: () {
                  return showRoundedModalBottomSheet(
                    autoResize: true,
                    context: context,
                    dismissOnTap: true,
                    builder: (BuildContext context) {
                      return Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              // color: Color.fromARGB(255, 46, 209, 153),
                              padding: const EdgeInsets.all(8.0),
                              child: ModalDrawerHandle(
                                handleColor: Color.fromARGB(255, 46, 209, 153),
                              ),
                            ),
                            Container(
                              height: _mediaQuery.size.height * .50,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                      height: 175,
                                      child: authService.getProfile()),
                                  Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Card(
                                          elevation: 8,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16)),
                                          child: ListTile(
                                            leading:
                                                Icon(Icons.monetization_on),
                                            title: Text("Preferred Currency"),
                                          ),
                                        ),
                                        Card(
                                          elevation: 8,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16)),
                                          child: ListTile(
                                            leading: Icon(Icons.local_airport),
                                            title: Text("Preferred Airport"),
                                          ),
                                        ),
                                        Card(
                                          color: Colors.white,
                                          child: MaterialButton(
                                            child: Text('Sign OUT'),
                                            onPressed: () async {
                                              authService.signOut();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
        backgroundColor: _color2,
        body: _buildBody(
            _mediaQuery, _backGroundColor, _upperLayerWidth, _color2),
        drawer: Drawer(
          elevation: 8,
          child: Column(
            children: <Widget>[
              Expanded(
                child: Align(
                    alignment: FractionalOffset.topCenter,
                    child: authService.buildDrawerHeader()),
              ),
              Container(
                child: RaisedButton(
                  child: Text('Sign Out'),
                  onPressed: () => authService.signOut(),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: IconButton(
                    leading: Icon(Icons.settings),
                    title: Text('Settings'),
                  ),
                ),
              ),
            ],
          ),
        ),
        resizeToAvoidBottomInset: true,
      ),
    );
  }

  Material _buildBody(
      _mediaQuery, _backGroundColor, _upperLayerWidth, _color2) {
    return Material(
      type: MaterialType.card,
      color: _color2,
      child: RubberBottomSheet(
        //scrollController: _scrollController,
        key: _rubberBotSheetKey,
        animationController: _controller,
        lowerLayer: _lowerLayer(_backGroundColor),
        upperLayer: _upperLayer(_mediaQuery, _upperLayerWidth, _color2),
        menuLayer: _menuLayer(_color2),
        header: _headerLayer(_upperLayerWidth, _color2),
      ),
    );
  }

  Center _headerLayer(_upperLayerWidth, _color2) {
    return Center(
      child: Container(
        width: _upperLayerWidth,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            color: _color2),
        padding: EdgeInsets.all(8),
        child: ModalDrawerHandle(
          handleColor: Colors.white,
          handleBorderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
      ),
    );
  }

  Scaffold _lowerLayer(_backGroundColor) {
    return Scaffold(
      backgroundColor: _backGroundColor,
      body: Container(
        child: PageView(
          controller: lowerLayerPageViewController,
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          //onPageChanged: ,
          children: <Widget>[
            Container(
              child: Container(
                height: MediaQuery.of(context).size.height,
                //margin: EdgeInsets.all(8),
                //color: Color(0xc25737373),
                child: GoogleMap(
                  mapType: MapType.normal,
                  //myLocationEnabled: true,
                  //compassEnabled: true,
                  //onMapCreated: _onMapCreated,
                  zoomGesturesEnabled: true,
                  markers: Set<Marker>.of(markers.values),
                  initialCameraPosition: CameraPosition(
                    target: LatLng(40.5436, -101.9734347),
                    zoom: 1.0,
                    tilt: 45,
                  ),
                ),
              ),
            ),
            Container(
              child: TicketListViewBuilder(
                data: responseTicketData,
              ),
            ),
          ],
        ),
      ),
    );
  }

//NEED TO BE MOVED TO OTHER FILE
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
      height: 60,
      child: ListView.builder(
        reverse: true,
        itemCount: originData == null ? 0 : originData.length,
        itemBuilder: (context, i) {
          final fromItem = originData[i];
          return ListTile(
            enabled: true,
            selected: true,
            title: Text('$fromItem'),
            onTap: () {
              print('$fromItem selected');

              _from.text = fromItem;
              _searchFromField = fromItem;

              print(_searchFromField);
              if (_searchFromField.isEmpty) {
                _isFromOpen = false;
                setState(() {
                  _from.text = fromItem;
                  _searchFromField = fromItem;
                  _isFromOpen = false;
                  _isToOpen = false;
                });
              }
              _isFromOpen = false;
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
      height: 60,
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

  void _addOriginAirportMarkers() {
    final int markerCount = markers.length;

    if (markerCount == 12) {
      return;
    }

    final String markerIdVal = '${_from.text}';
    _markerIdCounter++;
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(
        decodedGeoHash.latitude,
        decodedGeoHash.longitude,
      ),
      infoWindow: InfoWindow(title: markerIdVal, snippet: 'Travelling From'),
      onTap: () {
        _onMarkerTapped(markerId);
      },
    );

    setState(() {
      markers[markerId] = marker;
    });
  }

  void _addDestinationAirportMarkers() {
    final int markerCount1 = markers1.length;

    if (markerCount1 == 12) {
      return;
    }

    final String markerIdVal1 = '${_to.text}';
    _markerIdCounter++;
    final MarkerId markerId1 = MarkerId(markerIdVal1);

    final Marker marker1 = Marker(
      markerId: markerId1,
      position: LatLng(
        decodedGeoHash.latitude,
        decodedGeoHash.longitude,
      ),
      infoWindow: InfoWindow(title: markerIdVal1, snippet: 'Travelling To'),
      onTap: () {
        _onMarkerTapped(markerId1);
      },
    );

    setState(() {
      markers[markerId1] = marker1;
    });
  }

  Map<String, Object> postToHerokuServerData() {
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

  postToHerokuServer() {
    var testData = postToHerokuServerData();
    var testDataEnc = json.encode(testData);
    print(testDataEnc);
    var url =
        "https://flyx-web-hosted.herokuapp.com/search"; //https://olivine-pamphlet.glitch.me/testpost";
    http.post(
      url,
      body: testDataEnc,
      headers: {"Content-Type": "application/json"},
    ).then(
      (response) {
        print("Response status: ${response.statusCode}");
        print("Response body: ${response.body}");
        dynamic responseData = jsonDecode(response.body);
        responseTicketData = responseData["data"];
        TicketListViewBuilder(
          data: responseTicketData,
        );
        PageItem(
          data: responseTicketData,
        );
        setState(
          () {
            var responseData = json.decode(response.body);
            //search_par = responseData["tickets"]["search_params"];
            responseTicketData = responseData["data"];
          },
        );
      },
    );
  }

//
  Container _upperLayer(_mediaQuery, _upperLayerWidth, _color2) {
    var _upperLayerColor2 = Color.fromARGB(75, 46, 209, 153);
    return Container(
      height: 550,
      width: _upperLayerWidth,
      color: _upperLayerColor2,
      child: SingleChildScrollView(
        child: Form(
          key: _tickerSearchFormKey,
          child: Container(
            height: 1000,
            color: _upperLayerColor2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * .1),
                        child: Container(
                            child: _isFromOpen &&
                                    _from.text
                                        .isNotEmpty //(_isSearching && (!_onTap))
                                ? getFromWidget()
                                : null),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 8, right: 8),
                        child: Card(
                          elevation: 4,
                          color: Colors.white,
                          child: Padding(
                            child: TextFormField(
                              controller: _from,
                              //focusNode: _flyingFromFocusNode,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Field cannot be empty';
                                }
                              },

                              onFieldSubmitted: (String value) {
                                print("$value submitted");

                                setState(() {
                                  _from.text = value;
                                  _isFromOpen = false;
                                });
                              },

                              decoration: InputDecoration(
                                //border: InputBorder.none,
                                icon: Icon(
                                  FontAwesomeIcons.planeDeparture,
                                  color: Colors.blue,
                                  //size: 22.0,
                                ),
                                hintText: 'Flying From',
                                hintStyle: TextStyle(
                                    fontFamily: "Nunito", fontSize: 17.0),
                              ),
                            ),
                            padding: EdgeInsets.only(
                              left: 16,
                              bottom: 8,
                              top: 8,
                            ),
                          ),
                        ),
                      ),
                      // Container(margin: EdgeInsets.only(top: 160),color: Colors.white,child: ExpansionTile(title: Text('this'),),),
                      InkWell(
                        onTap: () {
                          _addOriginAirportMarkers();
                          _isFromOpen = false;
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * .6,
                          child: Card(
                            elevation: 4,
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  child: Slider(
                                    value: _fromSlider.toDouble(),
                                    min: 1.0,
                                    max: 100.0,
                                    divisions: 5,
                                    label: '$_fromSlider',
                                    onChanged: (double value) {
                                      _addOriginAirportMarkers();
                                      setState(
                                        () {
                                          _isFromOpen = false;
                                          _fromSlider = value;
                                        },
                                      );
                                    },
                                  ),
                                ),
                                Text("$_fromSlider Mi"),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * .1),
                        child: Container(
                            child: _isToOpen //(_isSearching && (!_onTap))
                                ? getToWidget()
                                : null),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 8, left: 8),
                        child: Card(
                          elevation: 4,
                          child: Padding(
                            child: TextFormField(
                              controller: _to,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Field cannot be empty';
                                }
                              },
                              onFieldSubmitted: (String value) {
                                print("$value submitted");

                                setState(() {
                                  _to.text = value;
                                  _isToOpen = false;
                                  //_isFromOpen = false;
                                });
                              },
                              decoration: InputDecoration(
                                //border: InputBorder.none,
                                icon: Icon(
                                  FontAwesomeIcons.planeDeparture,
                                  color: Colors.blue,
                                  //size: 22.0,
                                ),
                                hintText: 'Flying To',
                                hintStyle: TextStyle(
                                    fontFamily: "Nunito", fontSize: 17.0),
                              ),
                            ),
                            padding:
                                EdgeInsets.only(left: 16, top: 8, bottom: 8),
                          ),
                        ),
                      ),
                      // Container(margin: EdgeInsets.only(top: 160),color: Colors.white,child: ExpansionTile(title: Text('this'),),),
                      InkWell(
                        onTap: () {
                          _isToOpen = false;
                          _addDestinationAirportMarkers();
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * .6,
                          child: Card(
                            elevation: 4,
                            color: Colors.white,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  child: Slider(
                                    value: _toSlider.ceilToDouble(),
                                    min: 1.0,
                                    max: 100.0,
                                    divisions: 5,
                                    label: '$_toSlider', //var _toSlider = 1;,
                                    onChanged: (double value) {
                                      _addDestinationAirportMarkers();
                                      setState(() {
                                        _isToOpen = false;
                                        _toSlider = value;
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

                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          margin: EdgeInsets.only(top: 8, left: 16, right: 16),
                          elevation: 4,
                          color: Color.fromARGB(255, 255, 255, 255),
                          child: FlatButton(
                            color: Colors.white,
                            onPressed: () async {
                              final List<DateTime> originPicked =
                                  await DateRangePicker.showDatePicker(
                                      context: context,
                                      initialFirstDate: DateTime.now(),
                                      initialLastDate: (DateTime.now())
                                          .add(Duration(days: 7)),
                                      firstDate: DateTime(2019),
                                      lastDate: DateTime(2020));
                              if (originPicked != null &&
                                  originPicked.length == 2) {
                                print(originPicked);
                                _originDate = originPicked.toList();
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
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          margin: EdgeInsets.only(top: 8, left: 16, right: 16),
                          elevation: 4,
                          color: Color.fromARGB(255, 255, 255, 255),
                          child: FlatButton(
                            color: Colors.white,
                            onPressed: () async {
                              final List<DateTime> returnDatePicked =
                                  await DateRangePicker.showDatePicker(
                                      context: context,
                                      initialFirstDate:
                                          DateTime.now().add(Duration(days: 7)),
                                      initialLastDate: (DateTime.now())
                                          .add(Duration(days: 14)),
                                      firstDate: DateTime(2019),
                                      lastDate: DateTime(2020));
                              if (returnDatePicked != null &&
                                  returnDatePicked.length == 2) {
                                print(returnDatePicked);
                                _destinationDate = returnDatePicked.toList();
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
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(16),
                          ),
                        ),
                        width: 300,
                        child: FlatButton(
                          //padding: EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.black, width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16))),
                          color: Colors.lightGreenAccent,
                          child: Text(
                            'FIND TICKETS',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          ),
                          onPressed: () {
                            // _searchPageCollapseed();
                            _collapse();
                            postToHerokuServer();
                            PageItem(
                              data: responseTicketData,
                            );
                            TicketListViewBuilder(
                              data: responseTicketData,
                            );
                            lowerLayerPageViewController.animateToPage(
                              1,
                              duration: Duration(milliseconds: 1000),
                              curve: Curves.easeInOutExpo.flipped,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _menuLayer(_color2) {
    final MediaQueryData _mediaQuery = MediaQuery.of(context);
    final dynamic _menuLayerWidth = _mediaQuery.size.width;
    return Container(
      width: _menuLayerWidth * .95,
      decoration: BoxDecoration(
          color: _color2, border: Border.all(color: Colors.black)),
      margin: EdgeInsets.only(left: _menuLayerWidth * .025),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          FlatButton(
            child: Text('ONE WAY'),
            color: Colors.white,
            onPressed: null,
          ),
          FlatButton(
            child: Text(''),
            color: Colors.transparent,
            onPressed: null,
            disabledColor: Colors.transparent,
          ),
          FlatButton(
            child: Text('TWO WAY'),
            color: Colors.white,
            onPressed: () {
              _expand();
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();

    authService.profile.listen((state) => setState(() => _profile = state));

    authService.loading.listen((state) => setState(() => _loading = state));

    _isFromOpen = false;
    _isToOpen = false;

    _controller = RubberAnimationController(
        vsync: this,
        dismissable: true,
        lowerBoundValue: AnimationControllerValue(percentage: 0.1),
        halfBoundValue: AnimationControllerValue(pixel: 500),
        upperBoundValue: AnimationControllerValue(percentage: 0.975),
        duration: Duration(milliseconds: 200),
        animationBehavior: AnimationBehavior.preserve);

    _controller.addStatusListener(_statusListener);
    _controller.animationState.addListener(_stateListener);
  }

  void _collapse() {
    _controller.collapse();
  }

  void _expand() {
    _controller.expand();
  }

  void _stateListener() {
    print("state changed ${_controller.animationState.value}");
  }

  void _statusListener(AnimationStatus status) {
    print("changed status ${_controller.status}");
  }
}
