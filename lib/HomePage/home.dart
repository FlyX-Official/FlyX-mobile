import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;


import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flyx/Auth/auth.dart';
import 'package:flyx/Json/data.dart';
import 'package:flyx/JsonClasses/post.dart';
import 'package:flyx/SearcPage/searchPage.dart';
import 'package:flyx/ResponseData/route.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geohash/geohash.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:groovin_widgets/groovin_widgets.dart';
import 'package:http/http.dart' as http;
import 'package:rounded_modal/rounded_modal.dart';
import 'package:rubber/rubber.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:url_launcher/url_launcher.dart';

LatLng decodedOriginGeoHash, decodedDestinationGeoHash;
String _searchFromField = "",
    _searchToField = "",
    _oneWayDateRange,
    _returnDateRange;
List responseTicketData;
List<String> _searchFromList = List(),
    _searchToList = List(),
    originData,
    destData;
List<DateTime> _originDate, _destinationDate;

GoogleMapController mapController;
Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};
MarkerId selectedMarker;
int _markerIdCounter = 1, _polylineIdCounter = 1;
PolylineId selectedPolyline;

class CustomFromSearch extends SearchDelegate<String> {
  _getFromData() async {
    while (query.isNotEmpty) {
      _searchFromList = await _getFromSuggestions(query) ?? null;
      return _searchFromList;
    }
  }

  dynamic _getFromSuggestions(String hintText) async {
    var _client = http.Client();

    try {
      String url =
          "https://flyx-web-hosted.herokuapp.com/autocomplete?q=$hintText";

      var response = await _client
          .get(Uri.parse(url), headers: {"Accept": "application/json"});

      List decode = json.decode(response.body);
      dynamic sugg = await decode[0]['Combined'];
      dynamic center = Geohash.decode(decode[0]['location']);
      var _latitude = center.x;
      var _longitude = center.y;

      decodedOriginGeoHash = LatLng(_latitude, _longitude);
      print(decodedOriginGeoHash);
      print("Top Suggestion ===> $sugg");

      if (response.statusCode != HttpStatus.ok || decode.length == 0) {
        return null;
      }
      List<String> _suggestedWords = List();

      if (decode.length == 0) return null;

      decode.forEach((f) => _suggestedWords.add(f["Combined"]));
//    String data = decode[0]["word"];
      print("Suggestion List: ==> $_suggestedWords");
      originData = _suggestedWords;
      return _suggestedWords;
    } finally {
      _client.close();
    }
  }

  dynamic cities;
  // final recentCities = ['fat'];
  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    dynamic _closeSearchPage() {
      close(context, null);
    }

    // TODO: implement buildResults
    return _closeSearchPage();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    _getFromData();
    dynamic buildListView() {
      dynamic suggestionList = query.isEmpty ? "" : originData;
      return ListView.builder(
        itemCount: suggestionList == null ? 1 : suggestionList.length,
        itemBuilder: (context, index) => ListTile(
              onTap: () {
                query = suggestionList[index];
                _searchFromField = suggestionList[index];
                showResults(context);
              },
              leading: Icon(Icons.location_city),
              title: RichText(
                text: TextSpan(
                    text: suggestionList[index].substring(0, query.length),
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: suggestionList[index].substring(query.length),
                        style: TextStyle(color: Colors.grey),
                      )
                    ]),
              ),
            ),
      );
    }

    return buildListView();
  }
}

class CustomToSearch extends SearchDelegate<String> {
  _getToData() async {
    while (query.isNotEmpty) {
      _searchToList = await _getToSuggestions(query) ?? null;
      return _searchToList;
    }
  }

  dynamic _getToSuggestions(String hintText) async {
    String url =
        "https://flyx-web-hosted.herokuapp.com/autocomplete?q=$hintText";

    var response =
        await http.get(Uri.parse(url), headers: {"Accept": "application/json"});

    List decode = json.decode(response.body);
    dynamic sugg = decode[0]['Combined'];
    var center = Geohash.decode(decode[0]['location']);
    var latitude = center.x;
    var longitude = center.y;

    decodedDestinationGeoHash = LatLng(latitude, longitude);
    print(decodedDestinationGeoHash);
    print("Top Suggestion ===> $sugg");
    if (response.statusCode != HttpStatus.ok || decode.length == 0) {
      return null;
    }
    List<String> _suggestedWords = List();

    if (decode.length == 0) return null;

    decode.forEach((f) => _suggestedWords.add(f["Combined"]));
//    String data = decode[0]["word"];
    print("Suggestion List: ==> $_suggestedWords");
    destData = _suggestedWords;
    return _suggestedWords;
  }

  dynamic cities;
  // final recentCities = ['fat'];
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    dynamic _closeSearchPage() {
      close(context, null);
    }

    return _closeSearchPage();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildListView();
  }

  dynamic buildListView() {
    _getToData();
    dynamic _suggestionList = query.isEmpty ? "" : destData;
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
            onTap: () {
              query = _suggestionList[index];
              _searchToField = _suggestionList[index];
              showResults(context);
            },
            leading: Icon(Icons.location_city),
            title: RichText(
              text: TextSpan(
                  text: _suggestionList[index].substring(0, query.length),
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: _suggestionList[index].substring(query.length),
                      style: TextStyle(color: Colors.grey),
                    )
                  ]),
            ),
          ),
      itemCount: _suggestionList == null ? 1 : _suggestionList.length,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  GlobalKey _rubberBottomSheetKey = GlobalKey();
  RubberAnimationController _controller;

  int _currentPage, radioValue = 0;
  bool _isOneWay;
  double _profileButtonHeight = 4, _fromSlider = 1, _toSlider = 1;

  final _lowerLayerPageViewController = PageController();
  final _searchPageController = PageController();

  final dynamic _backGroundColor = Color.fromARGB(255, 247, 247, 247);
  var _upperLayerColor2 = Color.fromARGB(75, 46, 209, 153);
  var _color2 = Color.fromARGB(255, 100, 135, 165);

  GlobalKey<FormState> _ticketSearchFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    _controller = RubberAnimationController(
      vsync: this,
      dismissable: true,
      lowerBoundValue: AnimationControllerValue(pixel: 80),
      halfBoundValue: AnimationControllerValue(percentage: .33),
      upperBoundValue: AnimationControllerValue(percentage: 0.5),
      duration: Duration(milliseconds: 200),
      animationBehavior: AnimationBehavior.preserve,
      initialValue: .33,
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

//functions

void collapse(){
  _controller.collapse();
}
void expand(){
  _controller.expand();
}

  void handleRadioValueChanged(int value) {
    setState(() {
      radioValue = value;

      if (value == 1) {
        _isOneWay = false;
      } else {
        _isOneWay = true;
      }
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _addOriginAirportMarkers() {
    final int markerCount = markers.length;

    if (markerCount == 12) {
      return;
    }

    final String markerIdVal = '$_searchFromField';
    _markerIdCounter++;
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position:
          LatLng(decodedOriginGeoHash.latitude, decodedOriginGeoHash.longitude),
      infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
      onTap: () {
        //_onMarkerTapped(markerId);
      },
    );
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0.0,
          target: LatLng(
              decodedOriginGeoHash.latitude, decodedOriginGeoHash.longitude),
          tilt: 45.0,
          zoom: 13.0,
        ),
      ),
    );

    setState(() {
      markers[markerId] = marker;
    });
  }

  void _addDestinationAirportMarkers() {
    final int markerCount = markers.length;

    if (markerCount == 12) {
      return;
    }

    final String markerIdVal = '$_searchToField';
    _markerIdCounter++;
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(decodedDestinationGeoHash.latitude,
          decodedDestinationGeoHash.longitude),
      infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
      onTap: () {
        //_onMarkerTapped(markerId);
      },
    );
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0.0,
          target: LatLng(decodedDestinationGeoHash.latitude,
              decodedDestinationGeoHash.longitude),
          tilt: 45.0,
          zoom: 13.0,
        ),
      ),
    );

    setState(() {
      markers[markerId] = marker;
    });
  }

  void _addOriginDestinationPolyLine() {
    final int polylineCount = polylines.length;

    if (polylineCount == 12) {
      return;
    }

    final String polylineIdVal = 'polyline_id_$_polylineIdCounter';
    _polylineIdCounter++;
    final PolylineId polylineId = PolylineId(polylineIdVal);

    final Polyline polyline = Polyline(
      polylineId: polylineId,
      consumeTapEvents: true,
      geodesic: true,
      color: Colors.red,
      width: 15,
      patterns: <PatternItem>[
        PatternItem.dash(40),
        PatternItem.gap(20.0),
        PatternItem.dot,
        PatternItem.gap(20),
      ],
      points: _createPoints(),
      onTap: () {
        _onPolylineTapped(polylineId);
      },
    );

    setState(() {
      polylines[polylineId] = polyline;
    });
  }

  List<LatLng> _createPoints() {
    List<LatLng> points = <LatLng>[];
    points.add(decodedOriginGeoHash);
    points.add(decodedDestinationGeoHash);
    return points;
  }

  void _onPolylineTapped(PolylineId polylineId) {
    setState(() {
      selectedPolyline = polylineId;
    });
  }

//functions end

  @override
  Widget build(BuildContext context) {
    final MediaQueryData _mediaQuery = MediaQuery.of(context);
    final dynamic _upperLayerWidth = _mediaQuery.size.width * .95;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: _color2,
        toolbarOpacity: .66,
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.only(
        //     bottomLeft: Radius.circular(24),
        //     bottomRight: Radius.circular(24),
        //   ),
        // ),
        leading: Builder(
          builder: (BuildContext context) {
            return (_currentPage == 1)
                ? IconButton(
                    icon: const Icon(Icons.map),
                    onPressed: () {
                      _lowerLayerPageViewController.previousPage(
                        curve: Curves.easeInOutExpo.flipped,
                        duration: Duration(seconds: 1),
                      );
                    },
                    tooltip: 'Map Page',
                  )
                : IconButton(
                    icon: const Icon(FontAwesomeIcons.ticketAlt),
                    onPressed: () {
                      _lowerLayerPageViewController.nextPage(
                        curve: Curves.easeInOutExpo.flipped,
                        duration: Duration(seconds: 1),
                      );
                    },
                    tooltip: 'Tickets Page',
                  );
          },
        ),
        // leading: (_currentPage == 1)
        //     ? Icon(Icons.map)
        //     : Icon(FontAwesomeIcons.listUl),
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
                          Card(
                            // color: Color.fromARGB(255, 46, 209, 153),
                            margin: const EdgeInsets.all(8.0),
                            elevation: 0,
                            child: ModalDrawerHandle(
                              handleColor: Color.fromARGB(255, 46, 209, 153),
                            ),
                          ),
                          SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            child: Container(
                              height: _mediaQuery.size.height * .50,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    height: 160,
                                    child: Stack(
                                      alignment: AlignmentDirectional.bottomEnd,
                                      children: <Widget>[
                                        Container(
                                          child: authService
                                              .appDrawerUserAccountDrawerHeader(),
                                        ),
                                        Container(
                                          child: Card(
                                            elevation: 2,
                                            child: FlatButton.icon(
                                              icon: Icon(
                                                FontAwesomeIcons.signOutAlt,
                                                color: Colors.black,
                                              ),
                                              label: Text('Sign Out'),
                                              onPressed: () async {
                                                authService.signOut();
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    color: Colors.redAccent,
                                    width: _mediaQuery.size.width,
                                    margin: EdgeInsets.all(8),
                                    alignment: FractionalOffset.center,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Card(
                                          elevation: _profileButtonHeight,
                                          child: FlatButton.icon(
                                            icon: Icon(Icons.monetization_on),
                                            label: Text('Preferred Currency'),
                                            onPressed: () {},
                                          ),
                                        ),
                                        Card(
                                          elevation: _profileButtonHeight,
                                          child: FlatButton.icon(
                                            icon: Icon(Icons.local_airport),
                                            label: Text('Preferred Airport'),
                                            onPressed: () {},
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
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
      backgroundColor: Colors.white,
      body: Container(
        child: RubberBottomSheet(
          key: _rubberBottomSheetKey,
          animationController: _controller,
          lowerLayer: Container(
            child: PageView(
              controller: _lowerLayerPageViewController,
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              onPageChanged: (i) {
                if (i == 0) {
                  setState(() {
                    _currentPage = 0;
                  });
                } else {
                  collapse();
                  setState(() {
                    _currentPage = 1;
                  });
                }
              },
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height,
                  //margin: EdgeInsets.all(8),
                  //color: Color(0xc25737373),
                  child: GoogleMap(
                    mapType: MapType.normal,
                    //myLocationEnabled: true,
                    compassEnabled: true,
                    onMapCreated: _onMapCreated,
                    zoomGesturesEnabled: true,
                    minMaxZoomPreference: MinMaxZoomPreference(-5, 16),
                    //cameraTargetBounds: CameraTargetBounds(null),
                    //onCameraIdle: _onCamerIdle,
                    markers: Set<Marker>.of(markers.values),
                    polylines: Set<Polyline>.of(polylines.values),
                    initialCameraPosition: CameraPosition(
                      target: LatLng(0, 0),
                      zoom: 1.0,
                    ),
                    gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                      Factory<OneSequenceGestureRecognizer>(
                        () => EagerGestureRecognizer(),
                      ),
                    ].toSet(),
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
          upperLayer: Container(
            width: _upperLayerWidth,
            margin: EdgeInsets.only(left: _mediaQuery.size.width * .025),
            color: _upperLayerColor2,
            child: SingleChildScrollView(
              child: Form(
                key: _ticketSearchFormKey,
                child: Container(
                  height: 164,
                  //color: _upperLayerColor2,
                  child: PageView(
                    controller: _searchPageController,
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (i) {
                      if (i == 0) {
                        setState(() {
                          _currentPage = 0;
                        });
                      } else if (i == 1) {
                        setState(() {
                          _currentPage = 1;
                        });
                      }
                    },
                    children: <Widget>[
                      Card(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Container(
                              width: _mediaQuery.size.width * .4,
                              margin: EdgeInsets.symmetric(vertical: 4),
                              child: InkWell(
                                onTap: () {
                                  showSearch(
                                    context: context,
                                    delegate: CustomFromSearch(),
                                  );
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      height: 20,
                                      child: Text(
                                        'FROM',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        (_searchFromField.isNotEmpty)
                                            ? _searchFromField.substring(
                                                _searchFromField.length - 3)
                                            : 'SFO',
                                        style: TextStyle(
                                            fontSize: 60,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      height: 80,
                                    ),
                                    //Divider(),
                                    Container(
                                      child: Slider(
                                        value: _fromSlider,
                                        min: 1,
                                        max: 100,
                                        divisions: 5,
                                        label: '$_fromSlider Mi',
                                        onChanged: (double value) {
                                          _addOriginAirportMarkers();
                                          setState(() {
                                            _fromSlider = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: 100,
                              width: 1.0,
                              color: Colors.redAccent,
                              margin: EdgeInsets.symmetric(horizontal: 8),
                            ),
                            Container(
                              width: _mediaQuery.size.width * .4,
                              margin: EdgeInsets.symmetric(vertical: 4),
                              child: InkWell(
                                onTap: () {
                                  showSearch(
                                    context: context,
                                    delegate: CustomToSearch(),
                                  );
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      height: 20,
                                      child: Text(
                                        'TO',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        (_searchToField.isNotEmpty)
                                            ? _searchToField.substring(
                                                _searchToField.length - 3)
                                            : 'LAX',
                                        style: TextStyle(
                                            fontSize: 60,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      height: 80,
                                    ),
                                    // Divider(),
                                    Container(
                                      child: Slider(
                                        value: _toSlider,
                                        min: 1,
                                        max: 100,
                                        divisions: 5,
                                        label: '$_toSlider Mi',
                                        onChanged: (double value) {
                                          _addDestinationAirportMarkers();
                                          _addOriginDestinationPolyLine();
                                          setState(() {
                                            _toSlider = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Card(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Container(
                              width: _mediaQuery.size.width * .4,
                              margin: EdgeInsets.symmetric(vertical: 8),
                              child: InkWell(
                                onTap: () async {
                                  final List<DateTime> originPicked =
                                      await DateRangePicker.showDatePicker(
                                    context: context,
                                    initialFirstDate: DateTime.now(),
                                    initialLastDate: DateTime.now().add(
                                      Duration(days: 7),
                                    ),
                                    firstDate: DateTime(2019),
                                    lastDate: DateTime(2020),
                                  );
                                  if (originPicked != null &&
                                      originPicked.length == 2) {
                                    print(originPicked);
                                    _originDate = originPicked.toList();
                                  }
                                  setState(() {
                                    _oneWayDateRange =
                                        '${_originDate.first.day.toString()} / ${_originDate.first.month.toString()}' +
                                            ' -' +
                                            '\n${_originDate.last.day.toString()} / ${_originDate.last.month.toString()}';
                                  });
                                },
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      height: 20,
                                      child: Text(
                                        'DEPARTURE DATE',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        (_oneWayDateRange != null)
                                            ? _oneWayDateRange
                                            : 'DD/MM - DD/MM',
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      height: 80,
                                    ),
                                    Divider(),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                                height: 100,
                                width: 1.0,
                                color: Colors.redAccent,
                                margin: EdgeInsets.symmetric(horizontal: 4)),
                            Container(
                              width: _mediaQuery.size.width * .4,
                              margin: EdgeInsets.symmetric(vertical: 8),
                              child: InkWell(
                                onTap: () async {
                                  final List<DateTime> returnDatePicked =
                                      await DateRangePicker.showDatePicker(
                                    context: context,
                                    initialFirstDate: DateTime.now().add(
                                      Duration(days: 7),
                                    ),
                                    initialLastDate: DateTime.now().add(
                                      Duration(days: 14),
                                    ),
                                    firstDate: DateTime(2019),
                                    lastDate: DateTime(2020),
                                  );
                                  if (returnDatePicked != null &&
                                      returnDatePicked.length == 2) {
                                    print(returnDatePicked);
                                    _destinationDate =
                                        returnDatePicked.toList();
                                  }
                                  setState(() {
                                    _returnDateRange =
                                        '${_destinationDate.first.day.toString()} / ${_destinationDate.first.month.toString()}' +
                                            ' -' +
                                            '\n${_destinationDate.last.day.toString()} / ${_destinationDate.last.month.toString()}';
                                  });
                                },
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      height: 20,
                                      child: Text(
                                        'RETURN DATE',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        (_returnDateRange != null)
                                            ? _returnDateRange
                                            : 'DD/MM - DD/MM',
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      height: 80,
                                    ),
                                    Divider(),
                                  ],
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
            ),
          ),
          menuLayer: Container(
            height: 60,
            width: _upperLayerWidth,
            decoration: BoxDecoration(
              color: _color2,
              //border: Border.all(color: Colors.black),
            ),
            margin: EdgeInsets.only(left: _mediaQuery.size.width * .025),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  //height: 100,
                  width: _mediaQuery.size.width * .4,
                  //margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  child: Card(
                    elevation: 0,
                    child: RadioListTile(
                      value: 0,
                      groupValue: radioValue,
                      title: Text(
                        'ONE WAY',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      dense: true,
                      onChanged: handleRadioValueChanged,
                    ),
                  ),
                ),
                Container(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: FloatingActionButton(
                      onPressed: () {
                        postToHerokuServer();
                        _lowerLayerPageViewController.nextPage(
                          curve: Curves.easeInOutExpo.flipped,
                          duration: Duration(seconds: 1),
                        );
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      backgroundColor: Colors.lightGreenAccent,
                      child: Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                    )),
                Container(
                  //height: 100,
                  width: _mediaQuery.size.width * .4,
                  //margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  child: Card(
                    elevation: 0,
                    child: RadioListTile(
                      value: 1,
                      groupValue: radioValue,
                      title: Text(
                        'TWO WAY',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      dense: true,
                      onChanged: handleRadioValueChanged,
                    ),
                  ),
                ),
              ],
            ),
          ),
          header: Container(
            width: _upperLayerWidth,
            margin: EdgeInsets.only(left: _mediaQuery.size.width * .025),
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
        ),
      ),
    );
  }

  void postToHerokuServer() {
    //TODO uncomment these values
    var _client = http.Client();
    try {
      final String url = 'https://flyx-web-hosted.herokuapp.com/search';
      _client.post(
        url,
        body: postToJson(
          Post(
            oneWay: false,
            from: "$_searchFromField",
            to: '$_searchToField',
            radiusFrom: _fromSlider,
            radiusTo: _toSlider,
            departureWindow: DepartureWindow(
              start: DateTime.parse(_originDate[0].toString()),
              end: DateTime.parse(_originDate[1].toString()),
            ),
            returnDepartureWindow: ReturnDepartureWindow(
              start: DateTime.parse(_destinationDate[0].toString()),
              end: DateTime.parse(_destinationDate[1].toString()),
            ),
          ),
        ),
        headers: {"Content-Type": "application/json"},
      ).then(
        (response) {
          print("Response status: ${response.statusCode}");
          print("Response body: ${response.body}");
          dynamic responseData = jsonDecode(response.body);
          responseTicketData = responseData["data"];
          dataFromJson(response.body);
          // TicketListViewBuilder(
          //   data: responseTicketData,
          // );
          // PageItem(
          //   data: responseTicketData,
          // );
          setState(
            () {
              var responseData = json.decode(response.body);
              //search_par = responseData["tickets"]["search_params"];
              responseTicketData = responseData["data"];
            },
          );
        },
      );
    } finally {
      _client.close();
    }
  }
}

class TicketListViewBuilder extends StatefulWidget {
  final List data;
  const TicketListViewBuilder({Key key, @required this.data}) : super(key: key);
  @override
  _TicketListViewBuilderState createState() => _TicketListViewBuilderState();
}

class _TicketListViewBuilderState extends State<TicketListViewBuilder> {
  @override
  Widget build(BuildContext context) {
    dynamic responsePageItemTicketData = widget.data;
    return Container(
      padding: EdgeInsets.only(bottom: 80),
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
                              child: Text("${DateTime.fromMillisecondsSinceEpoch(widget.data[i]['dTimeUTC'] * 1000, isUtc: true).day.toString()}" +
                                  "-${DateTime.fromMillisecondsSinceEpoch(widget.data[i]['dTimeUTC'] * 1000, isUtc: true).month.toString()}" +
                                  "-${DateTime.fromMillisecondsSinceEpoch(widget.data[i]['dTimeUTC'] * 1000, isUtc: true).year.toString()}"),
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
                              child: Text("${DateTime.fromMillisecondsSinceEpoch(widget.data[i]['aTimeUTC'] * 1000, isUtc: true).day.toString()}" +
                                  "-${DateTime.fromMillisecondsSinceEpoch(widget.data[i]['aTimeUTC'] * 1000, isUtc: true).month.toString()}" +
                                  "-${DateTime.fromMillisecondsSinceEpoch(widget.data[i]['aTimeUTC'] * 1000, isUtc: true).year.toString()}"),
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
class PageItem extends StatefulWidget {
  const PageItem({Key key, this.num, this.data}) : super(key: key);

  final int num;
  final List data;
  @override
  _PageItemState createState() => _PageItemState();
}

class _PageItemState extends State<PageItem> {
  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    return Stack(children: <Widget>[
      Material(
        child: Column(
          children: <Widget>[
            Material(
              child: Container(
                height: MediaQuery.of(context).size.height * .25,
                //margin: EdgeInsets.all(8),
                //color: Color(0xc25737373),
                child: GoogleMap(
                  mapType: MapType.normal,
                  //myLocationEnabled: true,
                  //compassEnabled: true,
                  //onMapCreated: _onMapCreated,
                  //zoomGesturesEnabled: true,
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
                    //child:Text("Card $num pressed\n${widget.data[widget.num]['flyFrom']}"),
                    elevation: 8,
                    child: Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16)),
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
                                        "${widget.data[widget.num]['flyFrom'].toString()}",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 36,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ), //${widget.data[widget.num]['dTimeUTC'].toString()} UTC"),
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
                                        "${widget.data[widget.num]['flyTo'].toString()}",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 36,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ), //${widget.data[widget.num]['dTimeUTC'].toString()} UTC"),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Text(
                                  "\$${widget.data[widget.num]['price'].toString()}.00",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,

                                    fontWeight: FontWeight.bold,
                                    //fontWeight: FontWeight.w700,
                                  ),
                                ), // ${widget.data[widget.num]['aTimeUTC'].toString()} UTC"),
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
                                          //       "${widget.data[widget.num]['cityFrom'].toString()}",
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
                                                "${widget.data[widget.num]['flyFrom'].toString()}",
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
                                              "${widget.data[widget.num]['fly_duration'].toString()}",
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
                                          //       "${widget.data[widget.num]['cityTo'].toString()}",
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
                                                "${widget.data[widget.num]['flyTo'].toString()}",
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
                                                "${widget.data[widget.num]['flyTo'].toString()}",
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
                                              "${widget.data[widget.num]['return_duration'].toString()}",
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
                                          //       "${widget.data[widget.num]['cityTo'].toString()}",
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
                                                "${widget.data[widget.num]['flyFrom'].toString()}",
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
                  //           Text("Card $num pressed\n${widget.data[widget.num]['flyFrom']}"),
                  //     );
                  //     },
                ),
              ),
            ),
            Container(
              child: RaisedButton(
                color: Colors.lightGreenAccent,
                onPressed: () async {
                  String url = widget.data[widget.num]['deep_link'];
                  if (await canLaunch(url)) {
                    await launch(url);
                    print(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: Text('Purchase ticket '),
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

