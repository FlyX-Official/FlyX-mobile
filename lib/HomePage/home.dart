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

LatLng decodedOriginGeoHash, decodedDestinationGeoHash;
String _searchFromField = "", _searchToField = "",_oneWayDateRange, _returnDateRange;
List responseTicketData;
List<String> _searchFromList = List(),
    _searchToList = List(),
    originData,
    destData;
     List<DateTime> _originDate, _destinationDate;

// String _searchFromField = "", _searchToField = "";
// List<String> _searchFromList = List(), _searchToList = List();
// List<String> originData;
// List<String> destData;
// LatLng decodedOriginGeoHash,
//     decodedDestinationGeoHash;

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
  double _profileButtonHeight = 4;

  final _lowerLayerPageViewController = PageController();
  final _searchPageController = PageController();

  final dynamic _backGroundColor = Color.fromARGB(255, 247, 247, 247);
  var _upperLayerColor2 = Color.fromARGB(75, 46, 209, 153);
  var _color2 = Color.fromARGB(255, 100, 135, 165);

  GoogleMapController mapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};

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
      backgroundColor: _color2,
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
                  height: 140,
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
                              margin: EdgeInsets.symmetric(vertical: 8),
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
                                    Divider(),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: 100,
                              width: 1.0,
                              color: Colors.redAccent,
                              margin: EdgeInsets.symmetric(horizontal: 4),
                            ),
                            Container(
                              width: _mediaQuery.size.width * .4,
                              margin: EdgeInsets.symmetric(vertical: 8),
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
                                    Divider(),
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
                                  final List<DateTime> originPicked = await DateRangePicker.showDatePicker(
                                    context: context,
                                    initialFirstDate: DateTime.now(),
                                    initialLastDate: DateTime.now().add(Duration(days: 7),),
                                    firstDate: DateTime(2019),
                                    lastDate: DateTime(2020),
                                  );
                                  if(originPicked != null && originPicked.length == 2){
                                    print(originPicked);
                                    _originDate = originPicked.toList();
                                  }
                                  setState(() {
                                   _oneWayDateRange =  '${_originDate.first.day.toString()} / ${_originDate.first.month.toString()}' +
                                            ' -' + '\n${_originDate.last.day.toString()} / ${_originDate.last.month.toString()}';
                                  });
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
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
                                        (_oneWayDateRange != null)?_oneWayDateRange:'DD/MM - DD/MM',
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
                                  
                                  final List<DateTime> returnDatePicked = await DateRangePicker.showDatePicker(
                                    context: context,
                                    initialFirstDate: DateTime.now(),
                                    initialLastDate: DateTime.now().add(Duration(days: 14),),
                                    firstDate: DateTime(2019),
                                    lastDate: DateTime(2020),
                                  );
                                  if(returnDatePicked != null && returnDatePicked.length == 2){
                                    print(returnDatePicked);
                                    _destinationDate = returnDatePicked.toList();
                                  }
                                  setState(() {
                                   _returnDateRange =  '${_destinationDate.first.day.toString()} / ${_destinationDate.first.month.toString()}' +
                                                  ' -'+'\n${_destinationDate.last.day.toString()} / ${_destinationDate.last.month.toString()}';
                                  });
                                
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
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
                                        (_returnDateRange != null)?_returnDateRange:'DD/MM - DD/MM',
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
            // radiusFrom: _fromSlider,
            // radiusTo: _toSlider,
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
