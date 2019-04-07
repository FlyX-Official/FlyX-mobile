import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flyx/style/theme.dart' as Theme;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geohash/geohash.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:groovin_widgets/groovin_widgets.dart';
import 'package:http/http.dart' as http;
import 'package:rounded_modal/rounded_modal.dart';
import 'package:rubber/rubber.dart';
import 'package:transparent_image/transparent_image.dart';

//import '../TicketDisplayer/ticketCard.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

class HomePage extends StatefulWidget {
  static String tag = 'Home-page';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  _HomePageState() {
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
          _onTap = _onTapTextLength == _searchFromField.length;
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
          _onTap = _onTapTextLength == _searchToField.length;
        });
      }
    });
  }

  var center;
  LatLng decodedGeoHash;
  List<String> destData;
  IconData fabIcon = Icons.search;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Map<MarkerId, Marker> markers1 = <MarkerId, Marker>{};
  List<String> originData;
  List responseTicketData;
  MarkerId selectedMarker;
  var ticketresponses;

  GoogleSignInAccount _currentUser;
  Completer<GoogleMapController> _customGoogleMapController = Completer();
  List<DateTime> _destinationDate;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _from = TextEditingController();
  var _fromSlider = 1;
  PageController _inputPage;
  bool _isFromOpen;
  bool _isSearching = true;
  bool _isToOpen;
  int _markerIdCounter = 1;
  bool _onTap = false;
  int _onTapTextLength = 0;
  List<DateTime> _originDate;
  final _pageviewcontroller = PageController();
  //AnimationController _controller;

  RubberAnimationController _rubberController;

  ScrollController _scrollController = ScrollController();
  String _searchFromField = "";
  List<String> _searchFromList = List();
  String _searchToField = "";
  List<String> _searchToList = List();
  List<String> _tmpList = List();
  //TextEditingController _from = TextEditingController();
  TextEditingController _to = TextEditingController();

  var _toSlider = 1;

  @override
  void dispose() {
    super.dispose();
    _rubberController.removeStatusListener(_statusListener);
    _rubberController.dispose();
    // _controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    _isSearching = false;
    _isFromOpen = false;
    _isToOpen = false;

    _rubberController = RubberAnimationController(
        vsync: this,
        dismissable: false,
        upperBoundValue: AnimationControllerValue(percentage: .9),
        halfBoundValue: AnimationControllerValue(pixel: 500),
        lowerBoundValue: AnimationControllerValue(pixel: 94),
        duration: Duration(milliseconds: 500));
    _rubberController.addStatusListener(_statusListener);

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
        PageItem(
          data: responseTicketData,
        );
      });
    });
    _googleSignIn.signInSilently();
    TicketListViewBuilder(
      data: responseTicketData,
    );
    PageItem(
      data: responseTicketData,
    );
    //_controller = AnimationController(vsync: this);
  }

  void _statusListener(AnimationStatus status) {
    print("changed State ${_rubberController.animationState}");
  }

  void _halfExpand() {
    _rubberController.halfExpand();
  }

  void _searchPageCollapseed() {
    _rubberController.lowerBound;
  }

  void _collapse() {
    _rubberController.collapse();
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

  Widget _getUpperLayer() {
    return Container(
      width: MediaQuery.of(context).size.width * .95,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 247, 247, 247),
      ),
      //color: Colors.black54,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Form(
          autovalidate: false,
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    FlatButton(
                      child: Text('ONE WAY'),
                      color: Colors.white,
                      onPressed: () {},
                    ),
                    FlatButton(
                      child: Text(''),
                      color: Colors.transparent,
                      onPressed: null,
                      disabledColor: Colors.transparent,
                    ),
                    FlatButton(
                      child: Text('ROUND TRIP'),
                      color: Colors.white,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
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
                        elevation: 8,
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
                                _onTap = true;
                              });
                            },

                            decoration: InputDecoration(
                              border: InputBorder.none,
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
                                  onChanged: (double Value) {
                                    _addOriginAirportMarkers();
                                    setState(
                                      () {
                                        _isFromOpen = false;
                                        _fromSlider = Value.floor();
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
                        elevation: 8,
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
                                _onTap = true;
                              });
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
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
                          padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
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
                          elevation: 8,
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
                                  onChanged: (double Value) {
                                    _addDestinationAirportMarkers();
                                    setState(() {
                                      _isToOpen = false;
                                      _toSlider = Value.round();
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
                        elevation: 8,
                        color: Color.fromARGB(255, 255, 255, 255),
                        child: FlatButton(
                          color: Colors.white,
                          onPressed: () async {
                            final List<DateTime> originPicked =
                                await DateRangePicker.showDatePicker(
                                    context: context,
                                    initialFirstDate: DateTime.now(),
                                    initialLastDate:
                                        (DateTime.now()).add(Duration(days: 7)),
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
                        elevation: 8,
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
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                        elevation: 8,
                        child: FlatButton(
                          color: Colors.white,
                          child: Text('Find Tickets'),
                          onPressed: () {
                            postToGlitchServer();
                            PageItem(
                              data: responseTicketData,
                            );
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
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _getLowerLayer(BuildContext context) {
    return Container(
      child: PageView(
        onPageChanged: (i) {
          if (i == 0) {
            setState(() {
              fabIcon = Icons.search;
            });
          } else if (i == 1) {
            // _rubberController
            //     .setVisibility(!_rubberController.visibility.value);
            //_searchPageCollapseed();
            setState(() {
              fabIcon = Icons.payment;
            });
          }
        },
        controller: _pageviewcontroller,
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          //Container(child: Center(child: Text('Empty Page')),),
          Container(
            height: MediaQuery.of(context).size.height,
            //margin: EdgeInsets.all(8),
            //color: Color(0xc25737373),
            child: GoogleMap(
              mapType: MapType.normal,
              //myLocationEnabled: true,
              //compassEnabled: true,
              onMapCreated: _onMapCreated,
              zoomGesturesEnabled: true,
              markers: Set<Marker>.of(markers.values),
              initialCameraPosition: CameraPosition(
                target: LatLng(40.5436, -101.9734347),
                zoom: 1.0,
                tilt: 45,
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
      PageItem(
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

//end autocomplete
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 247, 247, 247),
        body: Stack(
          children: <Widget>[
            Container(
              child: RubberBottomSheet(
                header: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(16),
                          topLeft: Radius.circular(16)),
                      color: Colors.white,
                    ),
                    width: MediaQuery.of(context).size.width * .95,
                    padding: EdgeInsets.all(8),
                    child: ModalDrawerHandle(),
                  ),
                ),
                lowerLayer: _getLowerLayer(context),
                animationController: _rubberController,
                scrollController: _scrollController,
                upperLayer: _getUpperLayer(),
              ),
            ),
            Container(
              child: Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Color.fromARGB(0, 247, 247, 247),
                  elevation: 0,
                  actions: <Widget>[
                    IconButton(
                      onPressed: () => showModalMenu(),

                      icon: Icon(
                        Icons.account_box,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ), //_getLowerLayer(context),
        resizeToAvoidBottomInset: false,

        /*bottomNavigationBar: BottomAppBar(
          notchMargin: 8,
          elevation: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                child: IconButton(
                  icon: Icon(Icons.explore),
                  color: Colors.black,
                  highlightColor: Colors.redAccent,
                  onPressed: () {
                    _rubberController
                        .setVisibility(!_rubberController.visibility.value);
                  }, //() async => await _buildShowRoundedModalBottomSheet(context), //showMenu,
                ),
              ),
              Container(
                child: IconButton(
                  icon: Icon(Icons.edit_location),
                  color: Colors.black,
                  highlightColor: Colors.redAccent,
                  onPressed: _halfExpand, //showMenu,
                ),
              ),
              Container(
                //color: Colors.lightGreenAccent,

                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(width: 2, color: Colors.black),
                  ),
                  color: Colors.lightGreenAccent,
                  child: IconButton(
                    icon: Icon(Icons.search),
                    color: Colors.black,
                    highlightColor: Colors.redAccent,
                    onPressed: () {
                      postToGlitchServer();
                      PageItem(
                        data: responseTicketData,
                      );
                      TicketListViewBuilder(
                        data: responseTicketData,
                      );
                      _pageviewcontroller.animateToPage(
                        2,
                        duration: Duration(milliseconds: 1000),
                        curve: Curves.easeInOutExpo.flipped,
                      );
                    }, //showMenu,
                  ),
                ),
              ),
              Container(
                child: IconButton(
                  icon: Icon(Icons.notifications),
                  color: Colors.black,
                  highlightColor: Colors.blue,
                  onPressed: _collapse, //showMenu,
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
      */
      ),
    );
  }

//Ticket Card

}

class TicketListViewBuilder extends StatefulWidget {
  const TicketListViewBuilder({
    Key key,
    @required this.data,
  }) : super(key: key);

  final List data;

  @override
  _TicketListViewBuilder createState() => _TicketListViewBuilder();
}

class _TicketListViewBuilder extends State<TicketListViewBuilder> {
  int _currentIndexCounter;
  bool _isOpen = false;
  double _thisItem = 0.0;

  // Widget added(BuildContext contex) {
  //   if (_isOpen) {
  //     _isOpen = false;
  //     return AnimatedContainer(
  //       duration: const Duration(milliseconds: 120),
  //       child: Container(
  //         child: Text("data"),
  //         height: 200.0,
  //         color: Colors.red,
  //       ),
  //       height: _thisItem,
  //     );
  //   }
  //   _isOpen = true;
  //   return AnimatedContainer(
  //     duration: const Duration(milliseconds: 120),
  //     child: Container(
  //       child: Text("data"),
  //       height: 0.0,
  //     ),
  //     height: _thisItem,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    //return await buildSafeArea();
    dynamic responsePageItemTicketData = widget.data;
    return SafeArea(
      child: Container(
        child: ListView.builder(
          itemCount: widget.data == null ? 0 : widget.data.length,
          itemBuilder: (context, i) {
            return Hero(
              tag: "card$i",
              child: Container(
                padding: EdgeInsets.only(left: 8, top: 8, bottom: 8, right: 8),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Stack(
                    children: <Widget>[
                      buildTicketCardContainer(i, context),
                      Positioned(
                        left: 0.0,
                        top: 0.0,
                        bottom: 0.0,
                        right: 0.0,
                        child: Material(
                          type: MaterialType.transparency,
                          child: InkWell(
                            splashColor: Colors.amber,
                            onTap: () async {
                              await Future.delayed(Duration(milliseconds: 500));
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return PageItem(
                                        num: i,
                                        data: responsePageItemTicketData);
                                  },
                                  fullscreenDialog: true,
                                  maintainState: true,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Container buildTicketCardContainer(int i, BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            color: Color.fromARGB(255, 100, 135, 165),
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        child: Text(
                          "${widget.data[i]['flyFrom'].toString()}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.w700,
                          ),
                        ), //${widget.data[i]['dTimeUTC'].toString()} UTC"),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 8, right: 8),
                        child: Icon(
                          FontAwesomeIcons.exchangeAlt,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        child: Text(
                          "${widget.data[i]['flyTo'].toString()}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.w700,
                          ),
                        ), //${widget.data[i]['dTimeUTC'].toString()} UTC"),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Text(
                    "\$${widget.data[i]['price'].toString()}.00",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,

                      fontWeight: FontWeight.bold,
                      //fontWeight: FontWeight.w700,
                    ),
                  ), // ${widget.data[i]['aTimeUTC'].toString()} UTC"),
                ),
              ],
            ),
          ),
          //BlueBar
          Container(
            child: Column(
              children: <Widget>[
                //Divider(color: Colors.transparent,),
                Container(
                  margin: EdgeInsets.only(top: 16),
                  color: Colors.white,
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                        child: Column(
                          children: <Widget>[
                            // Container(
                            //   width: MediaQuery.of(context)
                            //           .size
                            //           .width *
                            //       .15,
                            //   child: Center(
                            //     child: Text(
                            //       "${widget.data[i]['cityFrom'].toString()}",
                            //       style: TextStyle(
                            //           //fontFamily: "OpenSans",
                            //           //fontSize: 14,
                            //           color: Colors
                            //               .lightBlueAccent),
                            //     ),
                            //   ),
                            // ),

                            Container(
                              width: MediaQuery.of(context).size.width * .15,
                              child: Center(
                                child: Text(
                                  "${widget.data[i]['flyFrom'].toString()}",
                                  style: TextStyle(
                                    fontSize: 28,
                                    color: Color(0XFF4a4a4a),
                                    fontWeight: FontWeight.w600,
                                    //fontFamily: "OpenSans",
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              child: Text('4/23'),
                            ),
                          ],
                        ),
                      ), // Origin Data
                      Container(
                        margin: EdgeInsets.only(bottom: 24),
                        width: MediaQuery.of(context).size.width * .12,
                        child: Center(
                          child: Icon(
                            FontAwesomeIcons.arrowCircleRight,
                            color: Color.fromARGB(255, 34, 180, 222),
                          ),
                        ),
                        padding: EdgeInsets.only(left: 8, right: 8),
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            child: Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Color(0XFFE4E4E4),
                                ),
                                width: MediaQuery.of(context).size.width * .30,
                                //color: Color(0XFFE4E4E4),
                                padding: EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: Center(
                                  child: Text(
                                    '7 Stops',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * .30,
                            //padding: EdgeInsets.only(bottom: 8),
                            child: Center(
                              child: Text(
                                "${widget.data[i]['fly_duration'].toString()}",
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          )
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 24),
                        width: MediaQuery.of(context).size.width * .12,
                        child: Center(
                          child: Icon(
                            FontAwesomeIcons.arrowCircleRight,
                            color: Color.fromARGB(255, 34, 180, 222),
                          ),
                        ),
                        padding: EdgeInsets.only(left: 8, right: 8),
                      ),
                      Container(
                        child: Column(
                          children: <Widget>[
                            // Container(
                            //   width: MediaQuery.of(context)
                            //           .size
                            //           .width *
                            //       .15,
                            //   child: Center(
                            //     child: Text(
                            //       "${widget.data[i]['cityTo'].toString()}",
                            //       style: TextStyle(
                            //           color: Colors
                            //               .lightBlueAccent),
                            //     ),
                            //   ),
                            // ),
                            Container(
                              width: MediaQuery.of(context).size.width * .15,
                              child: Center(
                                child: Text(
                                  "${widget.data[i]['flyTo'].toString()}",
                                  style: TextStyle(
                                    fontSize: 28,
                                    color: Color(0XFF4a4a4a),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              child: Text('4/23'),
                            ),
                          ],
                        ),
                      ), // Destination Data
                    ],
                  ),
                ),
                // if Roundtip
                Container(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: Divider(
                    height: 25,
                    color: Colors.black,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    bottom: 16,
                  ),
                  color: Colors.white,
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                        child: Column(
                          children: <Widget>[
                            // Container(
                            //   width: MediaQuery.of(context)
                            //           .size
                            //           .width *
                            //       .15,
                            //   child: Center(
                            //     child: Text(
                            //       "${widget.data[i]['cityFrom'].toString()}",
                            //       style: TextStyle(
                            //           //fontFamily: "OpenSans",
                            //           //fontSize: 14,
                            //           color: Colors
                            //               .lightBlueAccent),
                            //     ),
                            //   ),
                            // ),

                            Container(
                              width: MediaQuery.of(context).size.width * .15,
                              child: Center(
                                child: Text(
                                  "${widget.data[i]['flyTo'].toString()}",
                                  style: TextStyle(
                                    fontSize: 28,
                                    color: Color(0XFF4a4a4a),
                                    fontWeight: FontWeight.w600,
                                    //fontFamily: "OpenSans",
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              child: Text('4/23'),
                            ),
                          ],
                        ),
                      ), // Origin Data
                      Container(
                        margin: EdgeInsets.only(bottom: 24),
                        width: MediaQuery.of(context).size.width * .12,
                        child: Center(
                          child: Icon(
                            FontAwesomeIcons.arrowCircleRight,
                            color: Color.fromARGB(255, 34, 180, 222),
                          ),
                        ),
                        padding: EdgeInsets.only(left: 8, right: 8),
                      ),
                      Column(
                        children: <Widget>[
                          Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Color(0XFFE4E4E4),
                              ),
                              width: MediaQuery.of(context).size.width * .30,
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Center(
                                child: Text(
                                  '3 Stops',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * .30,
                            //padding: EdgeInsets.only(bottom: 8),
                            child: Center(
                              child: Text(
                                "${widget.data[i]['return_duration'].toString()}",
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          )
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 24),
                        width: MediaQuery.of(context).size.width * .12,
                        child: Center(
                          child: Icon(
                            FontAwesomeIcons.arrowCircleRight,
                            color: Color.fromARGB(255, 34, 180, 222),
                          ),
                        ),
                        padding: EdgeInsets.only(left: 8, right: 8),
                      ),
                      Container(
                        child: Column(
                          children: <Widget>[
                            // Container(
                            //   width: MediaQuery.of(context)
                            //           .size
                            //           .width *
                            //       .15,
                            //   child: Center(
                            //     child: Text(
                            //       "${widget.data[i]['cityTo'].toString()}",
                            //       style: TextStyle(
                            //           color: Colors
                            //               .lightBlueAccent),
                            //     ),
                            //   ),
                            // ),
                            Container(
                              width: MediaQuery.of(context).size.width * .15,
                              child: Center(
                                child: Text(
                                  "${widget.data[i]['flyFrom'].toString()}",
                                  style: TextStyle(
                                    fontSize: 28,
                                    color: Color(0XFF4a4a4a),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              child: Text('4/23'),
                            ),
                          ],
                        ),
                      ), // Destination Data
                    ],
                  ),
                ),
              ],
            ),
          ),
          //Everything under
        ],
      ),
    );
  }
}

class PageItem extends StatelessWidget {
  const PageItem({Key key, this.num, this.data}) : super(key: key);

  final int num;
  final List data;
  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    return Stack(children: <Widget>[
      Material(
        child: Column(
          children: <Widget>[
            Material(
              child: Container(
                height: MediaQuery.of(context).size.height * .33,
                //margin: EdgeInsets.all(8),
                //color: Color(0xc25737373),
                child: GoogleMap(
                  mapType: MapType.normal,
                  //myLocationEnabled: true,
                  //compassEnabled: true,
                  //onMapCreated: _onMapCreated,
                  zoomGesturesEnabled: true,
                  //markers: Set<Marker>.of(markers.values),
                  initialCameraPosition: CameraPosition(
                    target: LatLng(40.5436, -101.9734347),
                    zoom: 1.0,
                    tilt: 45,
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              //margin: EdgeInsets.symmetric(horizontal: 8),
              //height: mediaQuery.size.height * .33,
              child: Hero(
                tag: "card$num",
                child: Material(
                  type: MaterialType.card,
                  elevation: 0,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    //color: Colors.red,
                    //child:Text("Card $num pressed\n${data[num]['flyFrom']}"),
                    elevation: 8,
                    child: Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            color: Color.fromARGB(255, 100, 135, 165),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        "${data[num]['flyFrom'].toString()}",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 36,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ), //${data[num]['dTimeUTC'].toString()} UTC"),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.only(left: 8, right: 8),
                                      child: Icon(
                                        FontAwesomeIcons.exchangeAlt,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        "${data[num]['flyTo'].toString()}",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 36,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ), //${data[num]['dTimeUTC'].toString()} UTC"),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Text(
                                  "\$${data[num]['price'].toString()}.00",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,

                                    fontWeight: FontWeight.bold,
                                    //fontWeight: FontWeight.w700,
                                  ),
                                ), // ${data[num]['aTimeUTC'].toString()} UTC"),
                              ),
                            ],
                          ),
                        ),
                        //BlueBar
                        Container(
                          child: Column(
                            children: <Widget>[
                              //Divider(color: Colors.transparent,),
                              Container(
                                margin: EdgeInsets.only(top: 16),
                                color: Colors.white,
                                padding: EdgeInsets.only(left: 8, right: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Container(
                                      child: Column(
                                        children: <Widget>[
                                          // Container(
                                          //   width: MediaQuery.of(context)
                                          //           .size
                                          //           .width *
                                          //       .15,
                                          //   child: Center(
                                          //     child: Text(
                                          //       "${data[num]['cityFrom'].toString()}",
                                          //       style: TextStyle(
                                          //           //fontFamily: "OpenSans",
                                          //           //fontSize: 14,
                                          //           color: Colors
                                          //               .lightBlueAccent),
                                          //     ),
                                          //   ),
                                          // ),

                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .15,
                                            child: Center(
                                              child: Text(
                                                "${data[num]['flyFrom'].toString()}",
                                                style: TextStyle(
                                                  fontSize: 28,
                                                  color: Color(0XFF4a4a4a),
                                                  fontWeight: FontWeight.w600,
                                                  //fontFamily: "OpenSans",
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: Text('4/23'),
                                          ),
                                        ],
                                      ),
                                    ), // Origin Data
                                    Container(
                                      margin: EdgeInsets.only(bottom: 24),
                                      width: MediaQuery.of(context).size.width *
                                          .12,
                                      child: Center(
                                        child: Icon(
                                          FontAwesomeIcons.arrowCircleRight,
                                          color:
                                              Color.fromARGB(255, 34, 180, 222),
                                        ),
                                      ),
                                      padding:
                                          EdgeInsets.only(left: 8, right: 8),
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Container(
                                          child: Card(
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: Color(0XFFE4E4E4),
                                              ),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .30,
                                              //color: Color(0XFFE4E4E4),
                                              padding: EdgeInsets.symmetric(
                                                vertical: 8,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '7 Stops',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .30,
                                          //padding: EdgeInsets.only(bottom: 8),
                                          child: Center(
                                            child: Text(
                                              "${data[num]['fly_duration'].toString()}",
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(bottom: 24),
                                      width: MediaQuery.of(context).size.width *
                                          .12,
                                      child: Center(
                                        child: Icon(
                                          FontAwesomeIcons.arrowCircleRight,
                                          color:
                                              Color.fromARGB(255, 34, 180, 222),
                                        ),
                                      ),
                                      padding:
                                          EdgeInsets.only(left: 8, right: 8),
                                    ),
                                    Container(
                                      child: Column(
                                        children: <Widget>[
                                          // Container(
                                          //   width: MediaQuery.of(context)
                                          //           .size
                                          //           .width *
                                          //       .15,
                                          //   child: Center(
                                          //     child: Text(
                                          //       "${data[num]['cityTo'].toString()}",
                                          //       style: TextStyle(
                                          //           color: Colors
                                          //               .lightBlueAccent),
                                          //     ),
                                          //   ),
                                          // ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .15,
                                            child: Center(
                                              child: Text(
                                                "${data[num]['flyTo'].toString()}",
                                                style: TextStyle(
                                                  fontSize: 28,
                                                  color: Color(0XFF4a4a4a),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: Text('4/23'),
                                          ),
                                        ],
                                      ),
                                    ), // Destination Data
                                  ],
                                ),
                              ),
                              // if Roundtip
                              Container(
                                padding: EdgeInsets.only(left: 8, right: 8),
                                child: Divider(
                                  height: 25,
                                  color: Colors.black,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  bottom: 16,
                                ),
                                color: Colors.white,
                                padding: EdgeInsets.only(left: 8, right: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Container(
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .15,
                                            child: Center(
                                              child: Text(
                                                "${data[num]['flyTo'].toString()}",
                                                style: TextStyle(
                                                  fontSize: 28,
                                                  color: Color(0XFF4a4a4a),
                                                  fontWeight: FontWeight.w600,
                                                  //fontFamily: "OpenSans",
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: Text('4/23'),
                                          ),
                                        ],
                                      ),
                                    ), // Origin Data
                                    Container(
                                      margin: EdgeInsets.only(bottom: 24),
                                      width: MediaQuery.of(context).size.width *
                                          .12,
                                      child: Center(
                                        child: Icon(
                                          FontAwesomeIcons.arrowCircleRight,
                                          color:
                                              Color.fromARGB(255, 34, 180, 222),
                                        ),
                                      ),
                                      padding:
                                          EdgeInsets.only(left: 8, right: 8),
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Card(
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: Color(0XFFE4E4E4),
                                            ),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .30,
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8),
                                            child: Center(
                                              child: Text(
                                                '3 Stops',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .30,
                                          //padding: EdgeInsets.only(bottom: 8),
                                          child: Center(
                                            child: Text(
                                              "${data[num]['return_duration'].toString()}",
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(bottom: 24),
                                      width: MediaQuery.of(context).size.width *
                                          .12,
                                      child: Center(
                                        child: Icon(
                                          FontAwesomeIcons.arrowCircleRight,
                                          color:
                                              Color.fromARGB(255, 34, 180, 222),
                                        ),
                                      ),
                                      padding:
                                          EdgeInsets.only(left: 8, right: 8),
                                    ),
                                    Container(
                                      child: Column(
                                        children: <Widget>[
                                          // Container(
                                          //   width: MediaQuery.of(context)
                                          //           .size
                                          //           .width *
                                          //       .15,
                                          //   child: Center(
                                          //     child: Text(
                                          //       "${data[num]['cityTo'].toString()}",
                                          //       style: TextStyle(
                                          //           color: Colors
                                          //               .lightBlueAccent),
                                          //     ),
                                          //   ),
                                          // ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .15,
                                            child: Center(
                                              child: Text(
                                                "${data[num]['flyFrom'].toString()}",
                                                style: TextStyle(
                                                  fontSize: 28,
                                                  color: Color(0XFF4a4a4a),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: Text('4/23'),
                                          ),
                                        ],
                                      ),
                                    ), // Destination Data
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        //Everything under
                      ],
                    ),
                  ),
                  // child: ListTile(
                  //   title: Text("Item $num"),
                  //   subtitle: Text("This is item #$num"),
                  // ),
                  // itemCount: data.length,//data == null ? 0 : data.length,
                  //     itemBuilder: (context, num) {
                  //     return Card(
                  //       child:
                  //           Text("Card $num pressed\n${data[num]['flyFrom']}"),
                  //     );
                  //     },
                ),
              ),
            ),
            Expanded(
              child: Center(child: Text("Some more content goes here!")),
            )
          ],
        ),
      ),
    ]);
  }
}

// Login Page Code
class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  final Widget child;

  LoginPage({Key key, this.child}) : super(key: key);

  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _pageController = PageController();
  final _loginPageController = PageController();
  final _signUpPageController = PageController();
  //SignIn Controllers
  final TextEditingController _signInEmailController = TextEditingController();
  final TextEditingController _signInPasswordController =
      TextEditingController();

  final TextEditingController _signUpNameController = TextEditingController();
  final TextEditingController _signUpEmailController = TextEditingController();
  final TextEditingController _signUpPasswordController =
      TextEditingController();
  final TextEditingController _signUpPasswordConfirmController =
      TextEditingController();

  final GlobalKey<FormState> _signInFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _signupFormKey = GlobalKey<FormState>();

  String userEmailStore = "";
  bool _successSignUp;
  bool _successLogin;
  String _userEmail = "";
  String _errorMessage = "";
  GoogleSignInAccount _currentUser;
  bool _success;
  String _userID;
  String _uName;
  String _uEmail;
  bool _uVerfied;
  String _uPhoto;
  Type _uRunTimeType;
  String _uPhone;

  @override
  void initState() {
    super.initState();

    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
        if (_googleSignIn.isSignedIn == true) {
          Navigator.of(context).pushNamed(HomePage.tag);
        }
      });
    });
    _googleSignIn.signInSilently();
  }

  Widget build(BuildContext context) {
    dynamic _height = MediaQuery.of(context).size.height;
    dynamic _width = MediaQuery.of(context).size.width;
    dynamic _fourFifthsWidth = _width * .85;

    return Scaffold(
      body: Center(
        child: Container(
          color: Color.fromARGB(255, 247, 247, 247),
          child: PageView(
            physics: BouncingScrollPhysics(),
            controller: _pageController,
            scrollDirection: Axis.vertical,
            children: <Widget>[
              Container(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      child: buildSignIn(_height, _width, _fourFifthsWidth)),
                  Container(
                    child: FlatButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Need an Account?'),
                          Text(
                            ' Sign up',
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        _pageController.animateToPage(
                          1,
                          curve: Curves.easeInOutExpo,
                          duration: Duration(milliseconds: 1000),
                        );
                      },
                    ),
                  ),
                ],
              )),
              Center(
                  child: Container(
                      child: buildSignUp(_height, _width, _fourFifthsWidth))),
            ],
          ),
        ),
      ),
    );
  }

//Login Code Begin
  SingleChildScrollView buildSignIn(_height, _width, _fourFifthsWidth) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      controller: _loginPageController,
      child: Form(
        key: _signInFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              height: _height * .3,
              width: _width,
              //color: Color.fromARGB(0, 73, 144, 226),//Colors.white,
              child: FadeInImage.memoryNetwork(
                image:
                    'https://avatars0.githubusercontent.com/u/43255530?s=200&v=4',
                //height: _height * .33,
                fadeOutDuration: const Duration(milliseconds: 500),
                placeholder: kTransparentImage,
                // filterQuality: FilterQuality.high,
              ),
            ),
            //Logo PlaceHolder
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: _fourFifthsWidth,
                  child: signInEmail("Email", Icons.mail_outline),
                ),
                Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  overflow: Overflow.visible,
                  children: <Widget>[
                    Container(
                      width: _fourFifthsWidth,
                      child: signInPassword("Password", Icons.lock_outline),
                      margin: EdgeInsets.only(bottom: 25),
                    ),
                    Container(
                      //rmargin: EdgeInsets.only(top:125),
                      child: buildLoginCard(),
                    ),
                  ],
                ),
                Container(
                  child:
                      buildThirdPartySignIn(), //google,facebook,twitter signin buttons
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container signInEmail(String text, dynamic fieldIcon) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 8,
        child: Padding(
          padding: EdgeInsets.all(25.0),
          child: TextFormField(
            autofocus: false,
            //focusNode: myFocusNodeEmailLogin,
            controller: _signInEmailController,
            textInputAction: TextInputAction.newline,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
                fontFamily: "Nunito", fontSize: 16.0, color: Colors.black),
            decoration: InputDecoration(
              border: InputBorder.none,
              icon: Icon(
                fieldIcon,
                color: Colors.redAccent,
                size: 22.0,
              ),
              hintText: text,
              hintStyle: TextStyle(fontFamily: "Nunito", fontSize: 17.0),
            ),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
            },
          ),
        ),
      ),
    );
  }

  Container signInPassword(String text, dynamic fieldIcon) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 8,
        child: Padding(
          padding: EdgeInsets.all(25.0),
          child: TextFormField(
            autofocus: false,
            obscureText: true,
            //focusNode: myFocusNodeEmailLogin,
            controller: _signInPasswordController,
            textInputAction: TextInputAction.newline,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
                fontFamily: "Nunito", fontSize: 16.0, color: Colors.black),
            decoration: InputDecoration(
              border: InputBorder.none,
              icon: Icon(
                fieldIcon,
                color: Colors.redAccent,
                size: 22.0,
              ),
              hintText: text,
              hintStyle: TextStyle(fontFamily: "Nunito", fontSize: 17.0),
            ),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
            },
          ),
        ),
      ),
    );
  }

  Card buildLoginCard() {
    return Card(
      elevation: 8,
      color: Colors.lightGreenAccent,
      child: FlatButton.icon(
        highlightColor: Colors.transparent,
        splashColor: Theme.Colors.loginGradientEnd,
        color: Colors.lightGreenAccent,
        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
        icon: Icon(Icons.security),
        label: Text(
          "Sign In",
          style: TextStyle(
            color: Colors.black,
            fontSize: 22.0,
            fontFamily: "Nunito",
          ),
        ),
        onPressed: _emailPasswordSignIn,
      ),
    );
  }

  Padding buildSeparator() {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: new LinearGradient(
                  colors: [
                    Colors.white10,
                    Colors.white,
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 1.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
            width: MediaQuery.of(context).size.width * .33,
            height: 1.0,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: new LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.white10,
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 1.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
            width: MediaQuery.of(context).size.width * .33,
            height: 1.0,
          ),
        ],
      ),
    );
  }

  Future<void> _emailPasswordSignIn() async {
    final formState = _signInFormKey.currentState;
    bool alertError = false;
    if (_signInFormKey.currentState.validate()) {
      formState.save();
      try {
        FirebaseUser userLoginEmailPassword;
        userLoginEmailPassword = await _auth.signInWithEmailAndPassword(
          email: _signInEmailController.text,
          password: _signInPasswordController.text,
        );
        print("UserName: ${userLoginEmailPassword.displayName}");
        userEmailStore = userLoginEmailPassword.displayName;
        Navigator.of(context).pushNamed(HomePage.tag);
      } catch (e) {
        print(e.message);
        alertError = true;
      }
    }
    if (alertError == true) {
      return AlertDialog(
        title: Text('Error loggin in'),
        content: Text('Re-enter ID/Passowrd'),
      );
    }
  }

  ButtonBar buildThirdPartySignIn() {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton.icon(
          color: Colors.white,
          icon: Icon(FontAwesomeIcons.google),
          label: Text("Google"),
          onPressed: () async {
            _signIn();
          },
        ),
        RaisedButton.icon(
          color: Colors.white,
          icon: Icon(FontAwesomeIcons.mailchimp),
          label: Text("Guest Login"),
          onPressed: () {
            //_signInAnonymously();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
        /*RaisedButton.icon(
          color: Colors.white,
          icon: Icon(FontAwesomeIcons.acquisitionsIncorporated),
          label: Text("Anonymous Login"),
          onPressed: () {
            _signInAnonymously();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),*/
      ],
    );
  }

  void _signInAnonymously() async {
    final FirebaseUser user = await _auth.signInAnonymously();
    assert(user != null);
    assert(user.isAnonymous);
    assert(!user.isEmailVerified);
    assert(await user.getIdToken() != null);
    if (Platform.isIOS) {
      // Anonymous auth doesn't show up as a provider on iOS
      assert(user.providerData.isEmpty);
    } else if (Platform.isAndroid) {
      // Anonymous auth does show up as a provider on Android
      assert(user.providerData.length == 1);
      assert(user.providerData[0].providerId == 'firebase');
      assert(user.providerData[0].uid != null);
      assert(user.providerData[0].displayName == null);
      assert(user.providerData[0].photoUrl == null);
      assert(user.providerData[0].email == null);
    }

    final FirebaseUser fireCurrentUser = await _auth.currentUser();
    assert(user.uid == fireCurrentUser.uid);
    setState(() {
      if (user != null) {
        _success = true;
        _userID = user.uid;
      } else {
        _success = false;
      }
    });
  }

  Future<void> _signIn() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final FirebaseUser user = await _auth.signInWithCredential(credential);
      print("signed in " + user.displayName);
    } catch (error) {
      print(error);
    }
  }
//Login Code End

//SignUp Code Begin

  SingleChildScrollView buildSignUp(_height, _width, _fourFifthsWidth) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      controller: _signUpPageController,
      //height: _height * .5,
      //color: Color.fromARGB(0, 73, 144, 226), //Colors.white,
      child: Form(
        key: _signupFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          //mainAxisSize: MainAxisSize.min,
          /* alignment: AlignmentDirectional.center,
          overflow: Overflow.clip,
          fit: StackFit.loose,*/
          children: <Widget>[
            /*Container(
              height: _height * .33,
              width: _width,
              color: Color.fromARGB(255, 73, 144, 226),//Colors.black,
              child: Image.network(
                  'https://avatars0.githubusercontent.com/u/43255530?s=200&v=4'),
            ),*/
            //Logo PlaceHolder
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              //mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  child: _showErrorMessage(),
                ),
                Container(
                  width: _fourFifthsWidth,
                  child: signUpName("Name", Icons.mail_outline),
                ),
                Container(
                  width: _fourFifthsWidth,
                  child: signUpEmail("Email", Icons.mail_outline),
                ),
                Container(
                  width: _fourFifthsWidth,
                  child: signUpPassword("Password", Icons.lock_outline),
                ),
                Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  overflow: Overflow.visible,
                  children: <Widget>[
                    Container(
                      width: _fourFifthsWidth,
                      margin: EdgeInsets.only(bottom: 25),
                      child: signUpPasswordConfirmation(
                          "Confirmation", Icons.lock_outline),
                    ),
                    Container(
                      child: buildSignUpCard(),
                    ),
                  ],
                ),
                Container(
                  child: buildSeparator(),
                ),
                Container(
                  child:
                      buildThirdPartySignIn(), //google,facebook,twitter signin buttons
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Card buildSignUpCard() {
    return Card(
      elevation: 8,
      color: Colors.lightGreenAccent,
      child: FlatButton.icon(
        color: Colors.lightGreenAccent,
        highlightColor: Colors.transparent,
        splashColor: Theme.Colors.loginGradientEnd,
        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
        icon: Icon(Icons.security),
        label: Text(
          "SIGN UP",
          style: TextStyle(
            color: Colors.black,
            fontSize: 25.0,
            fontFamily: "Nunito",
          ),
        ),
        onPressed: () async {
          if (_signupFormKey.currentState.validate()) {
            _register();
            //_authenticate;
          }
          Navigator.of(context).pushNamed(HomePage.tag);
        },
        /*() {
                     //Navigator.of(context).pushNamed(FloatActBttn.tag);
                      Navigator.of(context).pushNamed(InputForm.tag);
                    }*/
      ),
    );
  }

  void _register() async {
    final FirebaseUser user = await _auth.createUserWithEmailAndPassword(
      email: _signUpEmailController.text,
      password: _signUpPasswordController.text,
    );

    if (user != null) {
      //Navigator.of(context).pushNamed(InputForm.tag);
      setState(() {
        _successSignUp = true;
        _userEmail = user.email;
      });
    } else {
      _successSignUp = false;
    }
  }

  Widget _showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Container signUpName(String text, dynamic fieldIcon) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 8,
        child: Padding(
          padding: EdgeInsets.all(25.0),
          child: TextFormField(
            autofocus: false,
            //focusNode: myFocusNodeEmailLogin,
            controller: _signUpNameController,
            textInputAction: TextInputAction.newline,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
                fontFamily: "Nunito", fontSize: 16.0, color: Colors.black),
            decoration: InputDecoration(
              border: InputBorder.none,
              icon: Icon(
                fieldIcon,
                color: Colors.redAccent,
                size: 22.0,
              ),
              hintText: text,
              hintStyle: TextStyle(fontFamily: "Nunito", fontSize: 17.0),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Name cannot be Empty';
              }
            },
          ),
        ),
      ),
    );
  }

  Container signUpEmail(String text, dynamic fieldIcon) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 8,
        child: Padding(
          padding: EdgeInsets.all(25.0),
          child: TextFormField(
            autofocus: false,
            //focusNode: myFocusNodeEmailLogin,
            controller: _signUpEmailController,
            textInputAction: TextInputAction.newline,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
                fontFamily: "Nunito", fontSize: 16.0, color: Colors.black),
            decoration: InputDecoration(
              border: InputBorder.none,
              icon: Icon(
                fieldIcon,
                color: Colors.redAccent,
                size: 22.0,
              ),
              hintText: text,
              hintStyle: TextStyle(fontFamily: "Nunito", fontSize: 17.0),
            ),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Email field cannot be empty';
              }
            },
          ),
        ),
      ),
    );
  }

  Container signUpPassword(String text, dynamic fieldIcon) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 8,
        child: Padding(
          padding: EdgeInsets.all(25.0),
          child: TextFormField(
            autofocus: false,
            obscureText: true,
            //focusNode: myFocusNodeEmailLogin,
            controller: _signUpPasswordController,
            textInputAction: TextInputAction.newline,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
                fontFamily: "Nunito", fontSize: 16.0, color: Colors.black),
            decoration: InputDecoration(
              border: InputBorder.none,
              icon: Icon(
                fieldIcon,
                color: Colors.redAccent,
                size: 22.0,
              ),
              hintText: text,
              hintStyle: TextStyle(fontFamily: "Nunito", fontSize: 17.0),
            ),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Password Field cannot be empty';
              }
            },
          ),
        ),
      ),
    );
  }

  Container signUpPasswordConfirmation(String text, dynamic fieldIcon) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 8,
        child: Padding(
          padding: EdgeInsets.all(25.0),
          child: TextFormField(
            autofocus: false,
            obscureText: true,
            //focusNode: myFocusNodeEmailLogin,
            controller: _signUpPasswordConfirmController,
            textInputAction: TextInputAction.newline,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
                fontFamily: "Nunito", fontSize: 16.0, color: Colors.black),
            decoration: InputDecoration(
              border: InputBorder.none,
              icon: Icon(
                fieldIcon,
                color: Colors.redAccent,
                size: 22.0,
              ),
              hintText: text,
              hintStyle: TextStyle(fontFamily: "Nunito", fontSize: 17.0),
            ),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Confirmation Field cannot be empty.';
              }
            },
          ),
        ),
      ),
    );
  }
//SignUp Code End
}
