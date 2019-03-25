import 'dart:convert';
import 'dart:io';

import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:rounded_modal/rounded_modal.dart';
import '../TicketDisplayer/ticketViewer.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
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

  @override
  void initState() {
    super.initState();
    _isSearching = false;
    _isFromOpen = false;
    _isToOpen = false;
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      _currentUser = account;
      ticketresponses = TicketViewPage();

      setState(() {
        _currentUser = account;
        ticketresponses = TicketViewPage();
      });
    });
    _googleSignIn.signInSilently();
    TicketViewPage();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

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
      height: 100,
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

  /*dynamic _buildSearchList() async {
    if (_searchFromField.isEmpty) {
      _searchFromList = List();
      return List();
    } else {
      _searchFromList = await _getSuggestion(_searchFromField) ?? List();
      //..add(_searchFromField);

      List<ListTile> childItems = new List();
      for (var value in _searchFromList) {
        childItems.add(_getListTile(value));
      }
      return childItems;
    }
  }*/
/*
  ListTile _getListTile(String suggestedPhrase) {
    return new ListTile(
      dense: true,
      title: new Text(
        suggestedPhrase,
        style: Theme.of(context).textTheme.body2,
      ),
      onTap: () {
        setState(() {
          _onTap = true;
          _isSearching = false;
          _isFromOpen = true;
          _onTapTextLength = suggestedPhrase.length;
          _from.text = suggestedPhrase;
        });
        _from.selection = TextSelection.fromPosition(
            new TextPosition(offset: suggestedPhrase.length));
      },
    );
  }*/

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
          onPressed: () {
            postToGlitchServer();
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        //floatingActionButtonAnimator,
        //persistentFooterButtons,
        //drawer,
        //endDrawer,
        //bottomSheet:,
        backgroundColor: Colors.amber,
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
              Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: <Widget>[
                  //Container(child: CustomGoogleMap(),),
                  Container(
                    margin: EdgeInsets.all(8),
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
                                      left: MediaQuery.of(context).size.width *
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
                                    elevation: 0,
                                    child: Padding(
                                      child: TextFormField(
                                        controller: _from,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Field cannot be empty';
                                          }
                                        },
                                        onFieldSubmitted: (String value) {
                                          print("$value submitted");
                                          setState(() {
                                            _from.text = value;
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
                                      left: MediaQuery.of(context).size.width *
                                          .4),
                                  width: MediaQuery.of(context).size.width * .6,
                                  child: Card(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    elevation: 0,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Container(
                                          child: Slider(
                                            value: _fromSlider.toDouble(),
                                            min: 1.0,
                                            max: 50.0,
                                            divisions: 10,
                                            label:
                                                '$_fromSlider', //var _fromSlider = 1;,
                                            onChanged: (double newValue) {
                                              setState(() {
                                                _fromSlider = newValue.round();
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
                              height: MediaQuery.of(context).size.height * .025,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),
                          Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
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
                                    elevation: 0,
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
                                      left: MediaQuery.of(context).size.width *
                                          .4),
                                  width: MediaQuery.of(context).size.width * .6,
                                  child: Card(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    elevation: 0,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Container(
                                          child: Slider(
                                            value: _toSlider.toDouble(),
                                            min: 1.0,
                                            max: 50.0,
                                            divisions: 10,
                                            label:
                                                '$_toSlider', //var _toSlider = 1;,
                                            onChanged: (double newValue) {
                                              setState(() {
                                                _toSlider = newValue.round();
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

                          /*Container(
                            child: Stack(
                              alignment: Alignment.topRight,
                              overflow: Overflow.visible,
                              children: <Widget>[
                                Container(
                                  child: Card(
                                    elevation: 0,
                                    child: Padding(
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Field cannot be empty';
                                          }
                                        },
                                        onFieldSubmitted: (String value) {
                                          print("$value submitted");
                                          setState(() {
                                            _to.text = value;
                                            _onTap = true;
                                            
                                          });
                                        },
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          icon: Icon(
                                            FontAwesomeIcons.planeArrival,
                                            color: Colors.blue,
                                            //size: 22.0,
                                          ),
                                          hintText: 'Flyting To',
                                          hintStyle: TextStyle(
                                              fontFamily: "Nunito",
                                              fontSize: 17.0),
                                        ),
                                      ),
                                      padding: EdgeInsets.all(10),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 60),
                                  width: MediaQuery.of(context).size.width * .6,
                                  child: Card(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    elevation: 0,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Container(
                                          child: Slider(
                                            value: _toSlider.toDouble(),
                                            min: 1.0,
                                            max: 50.0,
                                            divisions: 10,
                                            label:
                                                '$_toSlider', //var _toSlider = 1;,
                                            onChanged: (double newValue) {
                                              setState(() {
                                                _toSlider = newValue.round();
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
                          */
                          Container(
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * .025,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width * .47,
                                height: MediaQuery.of(context).size.height * .1,
                                child: Card(
                                  color: Color.fromARGB(200, 255, 255, 255),
                                  elevation: 0,
                                  child: FlatButton(
                                    color: Colors.white,
                                    onPressed: () async {
                                      final List<DateTime> originPicked =
                                          await DateRangePicker.showDatePicker(
                                              context: context,
                                              initialFirstDate:
                                                  new DateTime.now(),
                                              initialLastDate:
                                                  (new DateTime.now()).add(
                                                      new Duration(days: 7)),
                                              firstDate: new DateTime(2019),
                                              lastDate: new DateTime(2020));
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
                                width: MediaQuery.of(context).size.width * .47,
                                height: MediaQuery.of(context).size.height * .1,
                                child: Card(
                                  color: Color.fromARGB(200, 255, 255, 255),
                                  elevation: 0,
                                  child: FlatButton(
                                    color: Colors.white,
                                    onPressed: () async {
                                      final List<DateTime> returnDatePicked =
                                          await DateRangePicker.showDatePicker(
                                              context: context,
                                              initialFirstDate:
                                                  new DateTime.now()
                                                      .add(Duration(days: 7)),
                                              initialLastDate:
                                                  (new DateTime.now()).add(
                                                      new Duration(days: 14)),
                                              firstDate: new DateTime(2019),
                                              lastDate: new DateTime(2020));
                                      if (returnDatePicked != null &&
                                          returnDatePicked.length == 2) {
                                        print(returnDatePicked);
                                        _destinationDate =
                                            returnDatePicked.toList();
                                      }
                                    },
                                    child: //Icon(Icons.date_range),
                                        Text(
                                      '${DateTime.now().month}-${DateTime.now().day + 7}-${DateTime.now().year} <-> ' +
                                          '${DateTime.now().month}-${DateTime.now().day + 14}-${DateTime.now().year}'
                                          'yyyy-mm-dd <---> yyyy-mm-dd',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * .05,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      height: MediaQuery.of(context).size.height * .85,
                      child: ticketresponses),
                ],
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
                  color: Colors.red,
                  highlightColor: Colors.redAccent,
                  onPressed: () {
                    // _scaffoldKey.currentState.openDrawer();
                  }, //showMenu,
                ),
              ),
              Container(
                child: IconButton(
                  icon: Icon(Icons.edit_location),
                  color: Colors.green,
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
                  color: Colors.blue,
                  highlightColor: Colors.blue,
                  onPressed: () {
                    // _scaffoldKey.currentState.openDrawer();
                  }, //showMenu,
                ),
              ),
              IconButton(
                icon: Icon(Icons.account_box),
                color: Colors.amberAccent,
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
    });

//http.read("https://olivine-pamphlet.glitch.me/").then(print);
  }
}

/*
class _Page {
  _Page({ widget,  widget1});
  final StatefulWidget widget;
  final StatelessWidget widget1;
}

List<_Page> _allPages = <_Page>[
  _Page(widget: LoginPage()),
  _Page(widget: InputForm()),
  _Page(widget1: TicketView()),
];

class HomePage extends StatefulWidget {
  final Widget child;

  HomePage({Key key,  child}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _pageSelected;
  TabController _controller;

  GoogleSignInAccount _currentUser;
  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: _allPages.length);
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
  }

  @override
  Widget build(BuildContext context) {
    PageController _pageController;
    return Scaffold(
      backgroundColor: Colors.blueAccent, //Color.fromARGB(255, 251, 108, 112),
      key: _scaffoldKey,
      //bottomSheet: showMenu(),
      appBar: _buildAppBar(),
      drawer: AppDrawer(),
      body: TabBarView(
          controller: _controller,
          children: _allPages.map<Widget>((_Page page) {
            return Container(
                key: ObjectKey(page.widget),
                //padding: const EdgeInsets.all(12.0),
                child: page.widget);
          }).toList()), //new _BuildBody(pageController: _pageController),
      //TicketView(),
      floatingActionButton: _buildFab(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        child: _buildBottomAppBar(),
      ),
    );
  }

  AppBar _buildAppBar() => AppBar(
        leading: Icon(
          Icons.menu,
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
      );

  BottomAppBar _buildBottomAppBar() {
    return BottomAppBar(
      //shape: CircularNotchedRectangle(),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.explore),
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
              //Navigator.of(context).pushNamed(InputForm.tag);
            },
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * .075,
            width: MediaQuery.of(context).size.width * .10,
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
            },
          ),
          IconButton(
              icon: Icon(Icons.account_box),
              color: Colors.orange,
              highlightColor: Colors.redAccent,
              onPressed: showModalMenu
              // () {
              //Navigator.of(context).pushNamed(FloatActBttn.tag);
            //},
              ),
        ],
      ),
    );
  }

  showModalMenu() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
              color: Color(0xff232f34),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                  height: 36,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .25,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.0),
                        topRight: Radius.circular(16.0),
                      ),
                      color: Color(0xff344955),
                    ),
                    child: Stack(
                      alignment: Alignment(0, 0),
                      overflow: Overflow.visible,
                      children: <Widget>[
                        Positioned(
                          top: 0,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                                border: Border.all(
                                    color: Color(0xff232f34), width: 10)),
                            child: Center(
                              child: ClipOval(
                                child: Image.network(
                                  _currentUser.photoUrl,
                                  fit: BoxFit.cover,
                                  height:
                                      MediaQuery.of(context).size.height * .075,
                                  width:
                                      MediaQuery.of(context).size.height * .075,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          child: ListView(
                            physics: AlwaysScrollableScrollPhysics(),
                            children: <Widget>[
                              ListTile(
                                title: Text(
                                  "Inbox",
                                  style: TextStyle(color: Colors.white),
                                ),
                                leading: Icon(
                                  Icons.inbox,
                                  color: Colors.white,
                                ),
                                onTap: () {},
                              ),
                              ListTile(
                                title: Text(
                                  "Starred",
                                  style: TextStyle(color: Colors.white),
                                ),
                                leading: Icon(
                                  Icons.star_border,
                                  color: Colors.white,
                                ),
                                onTap: () {},
                              ),
                              ListTile(
                                title: Text(
                                  "Sent",
                                  style: TextStyle(color: Colors.white),
                                ),
                                leading: Icon(
                                  Icons.send,
                                  color: Colors.white,
                                ),
                                onTap: () {},
                              ),
                              ListTile(
                                title: Text(
                                  "Sign Out",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onTap: () async {
                                  final FirebaseUser user =
                                      await _auth.currentUser();
                                  if (user == null) {
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                      content:
                                          const Text('No one has signed in.'),
                                    ));
                                    return;
                                  }
                                  _signOut();
                                  final String uid = user.uid;
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        uid + ' has successfully signed out.'),
                                  ));
                                },
                                leading: Icon(Icons.exit_to_app),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _signOut() async {
    await _auth.signOut();
  }
}

Widget _buildFab(BuildContext context) {
  return FloatingActionButton.extended(
    onPressed: () {
      AppDrawer();
    },
    tooltip: 'fab',
    elevation: 4.0,
    foregroundColor: Colors.white,
    backgroundColor: Colors.lightGreen,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8))),
    //icon: Icon(FontAwesomeIcons.plane),
    label: Text('SEARCH'),
  );
}

class _BuildBody extends StatelessWidget {
  const _BuildBody({
    Key key,
    @required PageController pageController,
  })  : _pageController = pageController,
        super(key: key);

  final PageController _pageController;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(225, 73, 144, 226),
      child: PageView(
        reverse: false, // if flase adds pages on the right of main page
        pageSnapping: true,
        physics: AlwaysScrollableScrollPhysics(),
        controller: _pageController,
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          //Center(
          //  child: LoginPage(),
          //),
          Center(
            child: InputForm(),
          ),
          Center(
            child: TicketView(),
          ),

          //Center(child: buildSignIn(_height, _width, _fourFifthsWidth)),
          //Center(child: buildSignUp(_height, _width, _fourFifthsWidth)),
        ],
      ),
    );
  }
}
*/
