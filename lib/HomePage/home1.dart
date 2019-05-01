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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geohash/geohash.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:groovin_widgets/groovin_widgets.dart';
import 'package:http/http.dart' as http;
import 'package:rounded_modal/rounded_modal.dart';
import 'package:rubber/rubber.dart';
import 'package:url_launcher/url_launcher.dart';

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

  GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
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

  int _markerIdCounter = 1;

  double _lowerValue = 1, _upperValue = 100;

  double _fromSlider = 1, _toSlider = 1;

  bool _isFromOpen, _isToOpen;

  PageController _searchPageController =
      PageController(keepPage: true, initialPage: 0);

  int radioValue = 0, _currentPage;
  bool _isOneWay;

  GoogleSignInAccount _currentUser;

  TextEditingController _from = TextEditingController();
  TextEditingController _to = TextEditingController();

  List<String> _searchFromList = List(), _searchToList = List();

  var center;
  // LatLng decodedOriginGeoHash;
  // LatLng decodedDestinationGeoHash;
//  List<String> destData, originData;
  IconData fabIcon = Icons.search;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  //  markers1 = <MarkerId, Marker>{};

  //dynamic combinedMarkersSet = {...markers, ...markers1};

  List responseTicketData;
  MarkerId selectedMarker;
  var ticketresponses;

  //PolyLine
  Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};
  int _polylineIdCounter = 1;
  PolylineId selectedPolyline;
  //end PolyLine

  List<DateTime> _originDate, _destinationDate;
  String _oneWayDateRange, _returnDateRange;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData _mediaQuery = MediaQuery.of(context);
    final dynamic _upperLayerWidth = _mediaQuery.size.width * .95;
    final dynamic _backGroundColor = Color.fromARGB(255, 247, 247, 247);
    var _color2 = Color.fromARGB(255, 100, 135, 165);
    double _profileButtonHeight = 4;

    return SafeArea(
      child: Scaffold(
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
                        lowerLayerPageViewController.previousPage(
                          curve: Curves.easeInOutExpo.flipped,
                          duration: Duration(seconds: 1),
                        );
                      },
                      tooltip: 'Map Page',
                    )
                  : IconButton(
                      icon: const Icon(FontAwesomeIcons.ticketAlt),
                      onPressed: () {
                        lowerLayerPageViewController.nextPage(
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
                                        alignment:
                                            AlignmentDirectional.bottomEnd,
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
              ListTile(
                leading: Icon(Icons.notification_important),
                title: Text('Saved Tickets'),
              ),
              Expanded(
                child: Align(
                  alignment: FractionalOffset.center,
                  child: RaisedButton.icon(
                    icon: Icon(FontAwesomeIcons.signOutAlt),
                    label: Text('Sign out'),
                    onPressed: () {
                      authService.signOut();
                    },
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomLeft,
                  child: FlatButton.icon(
                    icon: Icon(Icons.settings),
                    label: Text('Settings'),
                    onPressed: () {},
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
        upperLayer: _upperLayer(_mediaQuery, _upperLayerWidth,
            _color2), //Container(height:200,child: SearchCard()),
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

  void _getCameraIdle() {
    mapController.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(
            (decodedOriginGeoHash.latitude > decodedDestinationGeoHash.latitude)
                ? decodedDestinationGeoHash.latitude
                : decodedOriginGeoHash.latitude,
            (decodedOriginGeoHash.longitude >
                    decodedDestinationGeoHash.longitude)
                ? decodedDestinationGeoHash.longitude
                : decodedOriginGeoHash.longitude,
          ),
          northeast: LatLng(
            (decodedOriginGeoHash.latitude < decodedDestinationGeoHash.latitude)
                ? decodedDestinationGeoHash.latitude
                : decodedOriginGeoHash.latitude,
            (decodedOriginGeoHash.longitude <
                    decodedDestinationGeoHash.longitude)
                ? decodedDestinationGeoHash.longitude
                : decodedOriginGeoHash.longitude,
          ),
        ),
        16.0,
      ),
    );
  }

  void _calculateCenter(center) {
// where	φ is latitude, λ is longitude, R is earth’s radius (mean radius = 6,371km);
// note that angles need to be in radians to pass to trig functions!

// var R = 6371e3; // metres
// var φ1 = lat1.toRadians();
// var φ2 = lat2.toRadians();
// var Δφ = (lat2-lat1).toRadians();
// var Δλ = (lon2-lon1).toRadians();

// var a = Math.sin(Δφ/2) * Math.sin(Δφ/2) +
//         Math.cos(φ1) * Math.cos(φ2) *
//         Math.sin(Δλ/2) * Math.sin(Δλ/2);
// var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));

// var d = R * c;

// This is the half-way point along a great circle path between the two points.1

// Formula:	Bx = cos φ2 ⋅ cos Δλ
// By = cos φ2 ⋅ sin Δλ
// φm = atan2( sin φ1 + sin φ2, √(cos φ1 + Bx)² + By² )
// λm = λ1 + atan2(By, cos(φ1)+Bx)

// (all angles
// in radians)
// var Bx = Math.cos(φ2) * Math.cos(λ2-λ1);
// var By = Math.cos(φ2) * Math.sin(λ2-λ1);
// var φ3 = Math.atan2(Math.sin(φ1) + Math.sin(φ2),
//                     Math.sqrt( (Math.cos(φ1)+Bx)*(Math.cos(φ1)+Bx) + By*By ) );
// var λ3 = λ1 + Math.atan2(By, Math.cos(φ1) + Bx);
// The longitude can be normalised to −180…+180 using (lon+540)%360-180
// Just as the initial bearing may vary from the final bearing, the midpoint may not be located half-way between latitudes/longitudes; the midpoint between 35°N,45°E and 35°N,135°E is around 45°N,90°E.

// Intermediate point
// An intermediate point at any fraction along the great circle path between two points can also be calculated.1

// Formula:	a = sin((1−f)⋅δ) / sin δ
// b = sin(f⋅δ) / sin δ
// x = a ⋅ cos φ1 ⋅ cos λ1 + b ⋅ cos φ2 ⋅ cos λ2
// y = a ⋅ cos φ1 ⋅ sin λ1 + b ⋅ cos φ2 ⋅ sin λ2
// z = a ⋅ sin φ1 + b ⋅ sin φ2
// φi = atan2(z, √x² + y²)
// λi = atan2(y, x)
// where	f is fraction along great circle route (f=0 is point 1, f=1 is point 2), δ is the angular distance d/R between the two points.
    //TODO custom mid point

    var lat1 = decodedOriginGeoHash.latitude * (math.pi / 180);
    var lat2 = decodedDestinationGeoHash.latitude * (math.pi / 180);
    var lng1 = decodedOriginGeoHash.longitude * (math.pi / 180);
    var lng2 = decodedDestinationGeoHash.longitude * (math.pi / 180);
  }

  // void _getCameraIdle() {
  //   mapController.animateCamera(
  //     CameraUpdate.newCameraPosition(
  //       CameraPosition(
  //         target: LatLng(
  //           (decodedOriginGeoHash.latitude > decodedDestinationGeoHash.latitude)
  //               ? (decodedDestinationGeoHash.latitude +
  //                       decodedOriginGeoHash.latitude) /
  //                   2
  //               : (decodedOriginGeoHash.latitude +
  //                       decodedDestinationGeoHash.latitude) /
  //                   2,
  //           (decodedOriginGeoHash.longitude >
  //                   decodedDestinationGeoHash.longitude)
  //               ? (decodedDestinationGeoHash.longitude -
  //                       decodedOriginGeoHash.longitude) /
  //                   2
  //               : (decodedOriginGeoHash.longitude +
  //                       decodedDestinationGeoHash.longitude) /
  //                   2,
  //         ),
  //         zoom: 0,
  //       ),
  //     ),
  //   );
  // } // TODO: needs a lot of tweaking, goes nuts if the travelling over the  Internation Date Line

  void _onCamerIdle() {
    Timer(Duration(seconds: 2), _getCameraIdle);
  }

  Scaffold _lowerLayer(_backGroundColor) {
    return Scaffold(
      backgroundColor: _backGroundColor,
      body: Container(
        child: PageView(
          controller: lowerLayerPageViewController,
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
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
            Container(
              child: Container(
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
//   dynamic _getFromData() async {
//     while (_searchFromField.isNotEmpty) {
//       _searchFromList = await _getFromSuggestions(_searchFromField) ?? null;

//       return _searchFromList;
//     }
//   }

//   dynamic _getToData() async {
//     while (_searchToField.isNotEmpty) {
//       _searchToList = await _getToSuggestions(_searchToField) ?? null;

//       return _searchToList;
//     }
//   }

//   dynamic getFromWidget() {
//     //_buildSearchList();
//     _getFromData();
//     //_getToData();

//     return Container(
//       color: Colors.white,
//       height: 60,
//       child: ListView.builder(
//         reverse: true,
//         itemCount: originData == null ? 0 : originData.length,
//         itemBuilder: (context, i) {
//           final fromItem = originData[i];
//           return ListTile(
//             enabled: true,
//             selected: true,
//             title: Text('$fromItem'),
//             onTap: () {
//               print('$fromItem selected');

//               _from.text = fromItem;
//               _searchFromField = fromItem;

//               print(_searchFromField);
//               if (_searchFromField.isEmpty) {
//                 _isFromOpen = false;
//                 setState(() {
//                   _from.text = fromItem;
//                   _searchFromField = fromItem;
//                   _isFromOpen = false;
//                   _isToOpen = false;
//                 });
//               }
//               _isFromOpen = false;
//             },
//           );
//         },
//       ),
//     );
//   }

//   dynamic getToWidget() {
//     //_buildSearchList();
//     //_getFromData();
//     _getToData();

//     return Container(
//       color: Colors.white,
//       height: 60,
//       child: ListView.builder(
//         reverse: true,
//         itemCount: destData == null ? 0 : destData.length,
//         itemBuilder: (context, i) {
//           final toItem = destData[i];
//           return ListTile(
//             title: Text('$toItem '),
//             onTap: () {
//               print('$toItem  selected');
//               setState(() {
//                 _to.text = toItem;
//                 //_onTap = true;
//                 //_isSearching = false;
//                 _isFromOpen = false;
//                 _isToOpen = false;
//               });
//               /*if (form == 'to') {
//                 setState(() {
//                 form.text = toItem ;
//                 _onTap = true;
//                 _isSearching = false;
//                 _isToOpen = true;
//               });
//               }*/
//             },
//           );
//         },
//       ),
//     );
//   }

//   dynamic _getFromSuggestions(String hintText) async {
//     String url =
//         "https://flyx-web-hosted.herokuapp.com/autocomplete?q=$hintText";

//     var response =
//         await http.get(Uri.parse(url), headers: {"Accept": "application/json"});

//     List decode = json.decode(response.body);
//     dynamic sugg = decode[0]['Combined'];
//     center = Geohash.decode(decode[0]['location']);
//     var latitude = center.x;
//     var longitude = center.y;
//     decodedOriginGeoHash = LatLng(latitude, longitude);
//     print(decodedOriginGeoHash);
//     print("Top Suggestion ===> $sugg");
//     if (response.statusCode != HttpStatus.ok || decode.length == 0) {
//       return null;
//     }
//     List<String> suggestedWords = List();

//     if (decode.length == 0) return null;

//     decode.forEach((f) => suggestedWords.add(f["Combined"]));
// //    String data = decode[0]["word"];
//     print("Suggestion List: ==> $suggestedWords");
//     originData = suggestedWords;
//     return suggestedWords;
//   }

//   dynamic _getToSuggestions(String hintText) async {
//     String url =
//         "https://flyx-web-hosted.herokuapp.com/autocomplete?q=$hintText";

//     var response =
//         await http.get(Uri.parse(url), headers: {"Accept": "application/json"});

//     List decode = json.decode(response.body);
//     dynamic sugg = decode[0]['Combined'];
//     center = Geohash.decode(decode[0]['location']);
//     var latitude = center.x;
//     var longitude = center.y;
//     decodedDestinationGeoHash = LatLng(latitude, longitude);
//     print(decodedDestinationGeoHash);
//     print("Top Suggestion ===> $sugg");
//     if (response.statusCode != HttpStatus.ok || decode.length == 0) {
//       return null;
//     }
//     List<String> suggestedWords = List();

//     if (decode.length == 0) return null;

//     decode.forEach((f) => suggestedWords.add(f["Combined"]));

//     print("Suggestion List: ==> $suggestedWords");
//     destData = suggestedWords;
//     return suggestedWords;
//   }

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
        decodedOriginGeoHash.latitude,
        decodedOriginGeoHash.longitude,
      ),
      infoWindow: InfoWindow(title: markerIdVal, snippet: 'Travelling From'),
      onTap: () {
        _onMarkerTapped(markerId);
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
    final int markerCount1 = markers.length;

    if (markerCount1 == 12) {
      return;
    }

    final String markerIdVal1 = '${_to.text}';
    _markerIdCounter++;
    final MarkerId markerId1 = MarkerId(markerIdVal1);

    final Marker marker1 = Marker(
      markerId: markerId1,
      position: LatLng(
        decodedDestinationGeoHash.latitude,
        decodedDestinationGeoHash.longitude,
      ),
      infoWindow: InfoWindow(title: markerIdVal1, snippet: 'Travelling To'),
      onTap: () {
        _onMarkerTapped(markerId1);
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
      markers[markerId1] = marker1;
    });
  }

  //polyLine
  dynamic _createPoints() {
    final List<LatLng> points = <LatLng>[];
    //final double offset = _polylineIdCounter.ceilToDouble();
    points.add(decodedOriginGeoHash);
    points.add(decodedDestinationGeoHash);
    return points;
  }

  LatLng _createLatLng(double lat, double lng) {
    return LatLng(lat, lng);
  }

  void _onPolylineTapped(PolylineId polylineId) {
    setState(() {
      selectedPolyline = polylineId;
    });
  }

  void _addOriginDestinatinPolyLine() {
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
      color: Colors.red,
      width: 20,
      geodesic: true,
      visible: true,
      patterns: <PatternItem>[
        // patterns only works on Android as of April 19
        PatternItem.dash(40.0),
        PatternItem.gap(20.0),
        PatternItem.dot,
        PatternItem.gap(20.0)
      ],
      points: <LatLng>[decodedOriginGeoHash,decodedDestinationGeoHash], //_createPoints(),
      onTap: () {
        _onPolylineTapped(polylineId);
      },
    );

    setState(() {
      polylines[polylineId] = polyline;
    });
  }
//end polyLine
  // Map<String, Object> postToHerokuServerData() {
  //   return {
  //     'oneWay': false,
  //     'from': "${_from.text}",
  //     'to': '${_to.text}',
  //     'radiusFrom': _fromSlider,
  //     'radiusTo': _toSlider,
  //     "departureWindow": {
  //       'start': _originDate[0].toString(),
  //       'end': _originDate[1].toString(),
  //     }, //_originDate.toList(),
  //     "returnDepartureWindow": {
  //       'start': _destinationDate[0].toString(),
  //       'end': _destinationDate[1].toString(),
  //     }, // _destinationDate.toList(),
  //     //"TimeStamp": DateTime.now(),
  //   };
  // }

  postToHerokuServer() {
    String url =
        "https://flyx-web-hosted.herokuapp.com/search"; //https://olivine-pamphlet.glitch.me/testpost";
    http.post(
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
      height: 250,
      width: _upperLayerWidth,
      color: _upperLayerColor2,
      child: SingleChildScrollView(
        child: Form(
          key: _tickerSearchFormKey,
          child: Container(
            height: 130,
            color: _upperLayerColor2,
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
                //_pageZero(_mediaQuery),
                // _CardWidget(
                //   key: UniqueKey(),
                //   mediaQuery: _mediaQuery,
                //   labelOne: "FROM",
                //   labelTwo: "TO",
                //   isOneWay: true,
                //   colors: Colors.black,
                // ),
                Card(
                  elevation: 2,
                  margin: EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                        width: _mediaQuery.size.width * .40,
                        margin: EdgeInsets.symmetric(
                          vertical: 8,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                showSearch(
                                  context: context,
                                  delegate: CustomFromSearch(),
                                );
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        (_searchFromField.isNotEmpty
                                            ? _searchFromField
                                            : "FLY FROM"),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          _addOriginAirportMarkers();
                                        },
                                        child: Icon(
                                          FontAwesomeIcons.mapMarkerAlt,
                                          size: 24,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(color: Colors.black),
                                ],
                              ),
                            ),
                            Container(
                              child: Slider(
                                value: _fromSlider.toDouble(),
                                label: '$_fromSlider',
                                min: 1,
                                max: 100,
                                divisions: 5,
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
                      Container(
                        height: 100,
                        width: 1.0,
                        color: Colors.red,
                        margin: EdgeInsets.symmetric(horizontal: 8),
                      ),
                      Container(
                        width: _mediaQuery.size.width * .40,
                        margin: EdgeInsets.symmetric(
                          vertical: 8,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                showSearch(
                                  context: context,
                                  delegate: CustomToSearch(),
                                );
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        (_searchToField.isNotEmpty
                                            ? _searchToField
                                            : "FLY To"),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          _addOriginAirportMarkers();
                                          _addDestinationAirportMarkers();
                                          //_addOriginDestinatinPolyLine();
                                        },
                                        child: Icon(
                                          FontAwesomeIcons.mapMarkerAlt,
                                          size: 24,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(color: Colors.black),
                                ],
                              ),
                            ),
                            Container(
                              child: Slider(
                                value: _toSlider.toDouble(),
                                label: '$_toSlider',
                                min: 1,
                                max: 100,
                                divisions: 5,
                                onChanged: (double value) {
                                  _addOriginAirportMarkers();
                                  _addDestinationAirportMarkers();
                                  
                                  //_getCameraIdle();

                                  _searchPageController.nextPage(
                                    curve: Curves.easeInOutExpo.flipped,
                                    duration: Duration(seconds: 1),
                                  );

                                  setState(() {
                                    _toSlider = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  elevation: 2,
                  margin: EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                        width: _mediaQuery.size.width * .40,
                        margin: EdgeInsets.symmetric(
                          vertical: 8,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            InkWell(
                              onTap: () async {
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

                                  setState(() {
                                    _oneWayDateRange =
                                        '${_originDate.first.day.toString()} / ${_originDate.first.month.toString()}' +
                                            ' - ${_originDate.last.day.toString()} / ${_originDate.last.month.toString()}';
                                  });
                                }
                                _addOriginDestinatinPolyLine();
                                _getCameraIdle();
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Text('DEPARTURE DATE'),
                                  Icon(FontAwesomeIcons.calendarWeek),
                                ],
                              ),
                            ),
                            Text((_oneWayDateRange == null)
                                ? 'dd/mm - dd/mm'
                                : _oneWayDateRange), //'$_oneWayDateRange'),
                            Divider(
                              color: Colors.black,
                              height: 1,
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 100,
                        width: 1.0,
                        color: Colors.red,
                        margin: EdgeInsets.symmetric(horizontal: 8),
                      ),
                      (_isOneWay)
                          ? Container(
                              width: _mediaQuery.size.width * .40,
                              margin: EdgeInsets.symmetric(
                                vertical: 8,
                              ),
                              child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _isOneWay = false;
                                      handleRadioValueChanged(1);
                                    });
                                  },
                                  child: Text('Make it a Round Trip?')),
                            )
                          : Container(
                              width: _mediaQuery.size.width * .40,
                              margin: EdgeInsets.symmetric(
                                vertical: 8,
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  InkWell(
                                    onTap: () async {
                                      final List<DateTime> returnDatePicked =
                                          await DateRangePicker.showDatePicker(
                                              context: context,
                                              initialFirstDate: DateTime.now()
                                                  .add(Duration(days: 7)),
                                              initialLastDate: (DateTime.now())
                                                  .add(Duration(days: 14)),
                                              firstDate: DateTime(2019),
                                              lastDate: DateTime(2020));
                                      if (returnDatePicked != null &&
                                          returnDatePicked.length == 2) {
                                        print(returnDatePicked);
                                        _destinationDate =
                                            returnDatePicked.toList();

                                        setState(() {
                                          _returnDateRange =
                                              '${_destinationDate.first.day.toString()} / ${_destinationDate.first.month.toString()}' +
                                                  ' - ${_destinationDate.last.day.toString()} / ${_destinationDate.last.month.toString()}';
                                        });
                                      }
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Text('RETURN DATE'),
                                        Icon(FontAwesomeIcons.calendarWeek),
                                      ],
                                    ),
                                  ),
                                  Text((_returnDateRange == null)
                                      ? 'dd/mm - dd/mm'
                                      : _returnDateRange), //'$_oneWayDateRange'),
                                  Divider(
                                    color: Colors.black,
                                    height: 1,
                                  )
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
                // _CardWidget(
                //   key: UniqueKey(),
                //   mediaQuery: _mediaQuery,
                //   labelOne: "DEPARTURE DATE",
                //   labelTwo: "RETURN DATE",
                //   iconOne: FontAwesomeIcons.calendarWeek,
                //   iconTwo: FontAwesomeIcons.calendarWeek,
                //   isOneWay: (_isOneWay) ? false : true,
                //   colors: (_isOneWay) ? Colors.black45 : Colors.black,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Card _pageZero(MediaQueryData _mediaQuery) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            height: 100,
            width: _mediaQuery.size.width * .4,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Card(
              elevation: 0,
              child: Align(
                alignment: FractionalOffset.center,
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
          ),
          Container(
            height: 75,
            width: 1.0,
            color: Colors.red,
          ),
          Container(
            height: 100,
            width: _mediaQuery.size.width * .4,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Card(
              elevation: 0,
              child: Align(
                alignment: FractionalOffset.centerLeft,
                child: RadioListTile(
                  value: 1,
                  groupValue: radioValue,
                  title: Text('ROUND TRIP'),
                  dense: true,
                  onChanged: handleRadioValueChanged,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _menuLayer(_color2) {
    final MediaQueryData _mediaQuery = MediaQuery.of(context);
    final dynamic _menuLayerWidth = _mediaQuery.size.width;
    return Container(
      height: 60,
      width: _menuLayerWidth * .95,
      decoration: BoxDecoration(
        color: _color2,
        //border: Border.all(color: Colors.black),
      ),
      margin: EdgeInsets.only(left: _menuLayerWidth * .025),
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
                  lowerLayerPageViewController.nextPage(
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

    _isOneWay = true;
    _currentPage = 0;
    authService.profile.listen((state) => setState(() => _profile = state));

    authService.loading.listen((state) => setState(() => _loading = state));

    _isFromOpen = false;
    _isToOpen = false;

    CustomFromSearch()._getFromSuggestions(' ');
    CustomToSearch()._getToSuggestions(' ');

    _controller = RubberAnimationController(
        vsync: this,
        dismissable: true,
        lowerBoundValue: AnimationControllerValue(pixel: 80),
        halfBoundValue: AnimationControllerValue(pixel: 250),
        upperBoundValue: AnimationControllerValue(percentage: 0.5),
        duration: Duration(milliseconds: 200),
        animationBehavior: AnimationBehavior.preserve);

    _controller.addStatusListener(_statusListener);
    _controller.animationState.addListener(_stateListener);
  }

  void _collapse() {
    _controller.collapse();
  }

  void _expand() {
    _controller.halfExpand();
  }

  void _stateListener() {
    print("state changed ${_controller.animationState.value}");
  }

  void _statusListener(AnimationStatus status) {
    print("changed status ${_controller.status}");
  }
}

String _searchFromField = "", _searchToField = "";
List<String> _searchFromList = List(), _searchToList = List();
List<String> originData;
List<String> destData;
LatLng decodedOriginGeoHash, decodedDestinationGeoHash, latlngOringCopy=decodedOriginGeoHash;

class CustomFromSearch extends SearchDelegate<String> {
  _getFromData() async {
    while (query.isNotEmpty) {
      _searchFromList = await _getFromSuggestions(query) ?? null;
      return _searchFromList;
    }
  }

  dynamic _getFromSuggestions(String hintText) async {

    var _client = http.Client();
    
    try{
    String url =
        "https://flyx-web-hosted.herokuapp.com/autocomplete?q=$hintText";

    var response =
        await _client.get(Uri.parse(url), headers: {"Accept": "application/json"});

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
    }finally{
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
    dynamic suggestionList = query.isEmpty ? "" : destData;
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
            onTap: () {
              query = suggestionList[index];
              _searchToField = suggestionList[index];
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
      itemCount: suggestionList == null ? 1 : suggestionList.length,
    );
  }
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
 
  @override
  Widget build(BuildContext context) {
    //return await buildSafeArea();
    dynamic responsePageItemTicketData = widget.data;
    return SafeArea(
      child: Container(
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

class _CardWidget extends StatelessWidget {
  const _CardWidget({
    Key key,
    @required MediaQueryData mediaQuery,
    String labelOne,
    String labelTwo,
    IconData iconOne,
    IconData iconTwo,
    bool isOneWay,
    Color colors,
    int currentPage,
  })  : _mediaQuery = mediaQuery,
        _labelOne = labelOne,
        _labelTwo = labelTwo,
        _iconOne = iconOne,
        _iconTwo = iconTwo,
        _isOneWay = isOneWay,
        _colors = colors,
        _currentPage = currentPage,
        super(key: key);

  final MediaQueryData _mediaQuery;
  final String _labelOne, _labelTwo;
  final IconData _iconOne, _iconTwo;
  final bool _isOneWay;
  final Color _colors;
  final int _currentPage;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      margin: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            height: 100,
            width: _mediaQuery.size.width * .4,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Card(
              elevation: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Align(
                    alignment: FractionalOffset.topCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[Text(_labelOne), Icon(_iconOne)],
                    ),
                  ),
                  Align(
                    alignment: FractionalOffset.center,
                    child: TextFormField(),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 75,
            width: 1.0,
            color: Colors.red,
          ),
          Container(
            height: 100,
            width: _mediaQuery.size.width * .4,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Card(
              elevation: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Align(
                    alignment: FractionalOffset.topCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          _labelTwo,
                          style: TextStyle(color: _colors),
                        ),
                        Icon(_iconTwo, color: _colors),
                      ],
                    ),
                  ),
                  Align(
                    alignment: FractionalOffset.topCenter,
                    child: TextFormField(
                      enabled: _isOneWay,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               mainAxisSize: MainAxisSize.max,
//               children: <Widget>[
//                 Container(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: <Widget>[
//                       Container(
//                         padding: EdgeInsets.only(
//                             left: MediaQuery.of(context).size.width * .1),
//                         child: Container(
//                             child: _isFromOpen &&
//                                     _from.text
//                                         .isNotEmpty //(_isSearching && (!_onTap))
//                                 ? getFromWidget()
//                                 : null),
//                       ),
//                       Container(
//                         margin: EdgeInsets.only(left: 8, right: 8),
//                         child: Card(
//                           elevation: 4,
//                           color: Colors.white,
//                           child: Padding(
//                             child: TextFormField(
//                               controller: _from,
//                               //focusNode: _flyingFromFocusNode,
//                               validator: (value) {
//                                 if (value.isEmpty) {
//                                   return 'Field cannot be empty';
//                                 }
//                               },

//                               onFieldSubmitted: (String value) {
//                                 print("$value submitted");

//                                 setState(() {
//                                   _from.text = value;
//                                   _isFromOpen = false;
//                                 });
//                               },

//                               decoration: InputDecoration(
//                                 //border: InputBorder.none,
//                                 icon: Icon(
//                                   FontAwesomeIcons.planeDeparture,
//                                   color: Colors.blue,
//                                   //size: 22.0,
//                                 ),
//                                 hintText: 'Flying From',
//                                 hintStyle: TextStyle(
//                                     fontFamily: "Nunito", fontSize: 17.0),
//                               ),
//                             ),
//                             padding: EdgeInsets.only(
//                               left: 16,
//                               bottom: 8,
//                               top: 8,
//                             ),
//                           ),
//                         ),
//                       ),
//                       // Container(margin: EdgeInsets.only(top: 160),color: Colors.white,child: ExpansionTile(title: Text('this'),),),
//                       InkWell(
//                         onTap: () {
//                           _addOriginAirportMarkers();
//                           _isFromOpen = false;
//                         },
//                         child: Container(
//                           width: MediaQuery.of(context).size.width * .6,
//                           child: Card(
//                             elevation: 4,
//                             color: Colors.white,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: <Widget>[
//                                 Container(
//                                   child: Slider(
//                                     value: _fromSlider.toDouble(),
//                                     min: 1.0,
//                                     max: 100.0,
//                                     divisions: 5,
//                                     label: '$_fromSlider',
//                                     onChanged: (double value) {
//                                       _addOriginAirportMarkers();

//                                       setState(
//                                         () {
//                                           _isFromOpen = false;
//                                           _fromSlider = value;
//                                         },
//                                       );
//                                     },
//                                   ),
//                                 ),
//                                 Text("$_fromSlider Mi"),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                       Container(
//                         padding: EdgeInsets.only(
//                             left: MediaQuery.of(context).size.width * .1),
//                         child: Container(
//                             child: _isToOpen //(_isSearching && (!_onTap))
//                                 ? getToWidget()
//                                 : null),
//                       ),
//                       Container(
//                         margin: EdgeInsets.only(right: 8, left: 8),
//                         child: Card(
//                           elevation: 4,
//                           child: Padding(
//                             child: TextFormField(
//                               controller: _to,
//                               validator: (value) {
//                                 if (value.isEmpty) {
//                                   return 'Field cannot be empty';
//                                 }
//                               },
//                               onFieldSubmitted: (String value) {
//                                 print("$value submitted");

//                                 setState(() {
//                                   _to.text = value;
//                                   _isToOpen = false;
//                                   //_isFromOpen = false;
//                                 });
//                               },
//                               decoration: InputDecoration(
//                                 //border: InputBorder.none,
//                                 icon: Icon(
//                                   FontAwesomeIcons.planeDeparture,
//                                   color: Colors.blue,
//                                   //size: 22.0,
//                                 ),
//                                 hintText: 'Flying To',
//                                 hintStyle: TextStyle(
//                                     fontFamily: "Nunito", fontSize: 17.0),
//                               ),
//                             ),
//                             padding:
//                                 EdgeInsets.only(left: 16, top: 8, bottom: 8),
//                           ),
//                         ),
//                       ),
//                       // Container(margin: EdgeInsets.only(top: 160),color: Colors.white,child: ExpansionTile(title: Text('this'),),),
//                       InkWell(
//                         onTap: () {
//                           _isToOpen = false;
//                           // mapController.animateCamera(
//                           //   CameraUpdate.newCameraPosition(
//                           //     CameraPosition(
//                           //       bearing: 0.0,
//                           //       target: LatLng(
//                           //           adecodedDestinationGeoHash.latitude,
//                           //           adecodedDestinationGeoHash.longitude),
//                           //       tilt: 45.0,
//                           //       zoom: 13.0,
//                           //     ),
//                           //   ),
//                           // );
//                           _addDestinationAirportMarkers();
//                         },
//                         child: Container(
//                           width: MediaQuery.of(context).size.width * .6,
//                           child: Card(
//                             elevation: 4,
//                             color: Colors.white,
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: <Widget>[
//                                 Container(
//                                   child: Slider(
//                                     value: _toSlider.ceilToDouble(),
//                                     min: 1.0,
//                                     max: 100.0,
//                                     divisions: 5,
//                                     label: '$_toSlider', //var _toSlider = 1;,
//                                     onChanged: (double value) {
//                                       _addDestinationAirportMarkers();
//                                       _addOriginDestinatinPolyLine();
//                                       setState(() {
//                                         _isToOpen = false;
//                                         _toSlider = value;
//                                       });
//                                     },
//                                   ),
//                                 ),
//                                 Text("$_toSlider Mi"),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),

//                       Container(
//                         width: MediaQuery.of(context).size.width,
//                         child: Card(
//                           margin: EdgeInsets.only(top: 8, left: 16, right: 16),
//                           elevation: 4,
//                           color: Color.fromARGB(255, 255, 255, 255),
//                           child: FlatButton(
//                             color: Colors.white,
//                             onPressed: () async {
//                               final List<DateTime> originPicked =
//                                   await DateRangePicker.showDatePicker(
//                                       context: context,
//                                       initialFirstDate: DateTime.now(),
//                                       initialLastDate: (DateTime.now())
//                                           .add(Duration(days: 7)),
//                                       firstDate: DateTime(2019),
//                                       lastDate: DateTime(2020));
//                               if (originPicked != null &&
//                                   originPicked.length == 2) {
//                                 print(originPicked);
//                                 _originDate = originPicked.toList();
//                               }
//                             },
//                             child: Icon(Icons.date_range),
//                             /*child: Text(
//                               '${DateTime.now().month}-${DateTime.now().day}-${DateTime.now().year} <-> ' +
//                                   '${DateTime.now().month}-${DateTime.now().day + 7}-${DateTime.now().year}' +
//                                   '$_originDate'
//                                   'yyyy-mm-dd <---> yyyy-mm-dd'
//                               ),*/
//                             //'Departure Date Picker'),
//                           ),
//                         ),
//                       ),

//                       Container(
//                         width: MediaQuery.of(context).size.width,
//                         child: Card(
//                           margin: EdgeInsets.only(top: 8, left: 16, right: 16),
//                           elevation: 4,
//                           color: Color.fromARGB(255, 255, 255, 255),
//                           child: FlatButton(
//                             color: Colors.white,
//                             onPressed: () async {
//                               final List<DateTime> returnDatePicked =
//                                   await DateRangePicker.showDatePicker(
//                                       context: context,
//                                       initialFirstDate:
//                                           DateTime.now().add(Duration(days: 7)),
//                                       initialLastDate: (DateTime.now())
//                                           .add(Duration(days: 14)),
//                                       firstDate: DateTime(2019),
//                                       lastDate: DateTime(2020));
//                               if (returnDatePicked != null &&
//                                   returnDatePicked.length == 2) {
//                                 print(returnDatePicked);
//                                 _destinationDate = returnDatePicked.toList();
//                               }
//                             },
//                             child: Icon(Icons.date_range),
//                             /*child: Text(
//                               '${DateTime.now().month}-${DateTime.now().day}-${DateTime.now().year} <-> ' +
//                                   '${DateTime.now().month}-${DateTime.now().day + 7}-${DateTime.now().year}' +
//                                   '$_originDate'
//                                   'yyyy-mm-dd <---> yyyy-mm-dd'
//                               ),*/
//                             //'Departure Date Picker'),
//                           ),
//                         ),
//                       ),
//                       Container(
//                         padding: EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.all(
//                             Radius.circular(16),
//                           ),
//                         ),
//                         width: 300,
//                         child: FlatButton(
//                           //padding: EdgeInsets.all(16),
//                           shape: RoundedRectangleBorder(
//                               side: BorderSide(color: Colors.black, width: 2),
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(16))),
//                           color: Colors.lightGreenAccent,
//                           child: Text(
//                             'FIND TICKETS',
//                             style: TextStyle(
//                                 color: Colors.black,
//                                 fontWeight: FontWeight.w700),
//                           ),
//                           onPressed: () {
//                             // _searchPageCollapseed();
//                             _collapse();
//                             postToHerokuServer();
//                             PageItem(
//                               data: responseTicketData,
//                             );
//                             TicketListViewBuilder(
//                               data: responseTicketData,
//                             );
//                             lowerLayerPageViewController.animateToPage(
//                               1,
//                               duration: Duration(milliseconds: 1000),
//                               curve: Curves.easeInOutExpo.flipped,
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
