import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            return TileItem(num: index);
          },
        ),
      ),
    );
  }
}

class TileItem extends StatelessWidget {
  final int num;

  const TileItem({Key key, this.num}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "card$num",
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 485.0 / 384.0,
                  child: Image.network("https://picsum.photos/485/384?image=$num"),
                ),
                Material(
                  child: ListTile(
                    title: Text("Item $num"),
                    subtitle: Text("This is item #$num"),
                  ),
                )
              ],
            ),
            Positioned(
              left: 0.0,
              top: 0.0,
              bottom: 0.0,
              right: 0.0,
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  onTap: () async {
                    await Future.delayed(Duration(milliseconds: 200));
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return new PageItem(num: num);
                        },
                        fullscreenDialog: true,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PageItem extends StatelessWidget {
  final int num;

  const PageItem({Key key, this.num}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppBar appBar = new AppBar(
      primary: false,
      leading: IconTheme(data: IconThemeData(color: Colors.white), child: CloseButton()),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.4),
              Colors.black.withOpacity(0.1),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
    );
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    return Stack(children: <Widget>[
      Hero(
        tag: "card$num",
        child: Material(
          child: Column(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 485.0 / 384.0,
                child: Image.network("https://picsum.photos/485/384?image=$num"),
              ),
              Material(
                child: ListTile(
                  title: Text("Item $num"),
                  subtitle: Text("This is item #$num"),
                ),
              ),
              Expanded(
                child: Center(child: Text("Some more content goes here!")),
              )
            ],
          ),
        ),
      ),
      Column(
        children: <Widget>[
          Container(
            height: mediaQuery.padding.top,
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: appBar.preferredSize.height),
            child: appBar,
          )
        ],
      ),
    ]);
  }
}



  Future<SafeArea> buildSafeArea() async {
    return SafeArea(
      child: Container(
        //decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: widget.data == null ? 0 : widget.data.length,
          itemBuilder: (BuildContext context, i) {
            return Container(
              child: Card(
                margin: EdgeInsets.all(8),
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                child: Container(
                  //height: MediaQuery.of(context).size.height * .35,

                  child: ExpansionPanelList(
                    expansionCallback: (int index, bool status) {
                      setState(() {
                        _currentIndexCounter =
                            _currentIndexCounter == i ? null : i;
                      });
                    },
                    children: [
                      ExpansionPanel(
                        isExpanded: _currentIndexCounter == i,
                        headerBuilder: (BuildContext context,
                                bool isExpanded) =>
                            Container(
                              //height: MediaQuery.of(context).size.height * .33,
                              //color: Colors.red,
                              //padding: EdgeInsets.all(8),
                              alignment: Alignment.center,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    color: Color.fromARGB(255, 100, 135, 165),
                                    padding: EdgeInsets.all(8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Container(
                                                child: Text(
                                                  "${widget.data[i]['flyFrom'].toString()}",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 36,
                                                  ),
                                                ), //${widget.data[i]['dTimeUTC'].toString()} UTC"),
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: 8, right: 8),
                                                child: Icon(
                                                  FontAwesomeIcons.exchangeAlt,
                                                  color:
                                                      Colors.lightGreenAccent,
                                                ),
                                              ),
                                              Container(
                                                child: Text(
                                                  "${widget.data[i]['flyTo'].toString()}",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 36,
                                                  ),
                                                ), //${widget.data[i]['dTimeUTC'].toString()} UTC"),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            "\$ ${widget.data[i]['price'].toString()}",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 36,
                                            ),
                                          ), // ${widget.data[i]['aTimeUTC'].toString()} UTC"),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Container(
                                    padding: EdgeInsets.all(8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Container(
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                child: Text(
                                                  "${widget.data[i]['cityFrom'].toString()}",
                                                  style: TextStyle(
                                                      fontFamily: "NUNITO",
                                                      color: Colors
                                                          .lightBlueAccent),
                                                ),
                                              ),
                                              Container(
                                                child: Text(
                                                  "${widget.data[i]['flyFrom'].toString()}",
                                                  style: TextStyle(
                                                      fontSize: 36,
                                                      color: Colors.blueAccent),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ), // Origin Data
                                        Container(
                                          child: Icon(
                                            FontAwesomeIcons.arrowCircleRight,
                                            color: Color.fromARGB(
                                                255, 34, 180, 222),
                                          ),
                                          padding: EdgeInsets.all(8),
                                        ),
                                        Column(
                                          children: <Widget>[
                                            Container(
                                              child: Card(
                                                elevation: 0,
                                                child: Container(
                                                  color: Colors.grey[100],
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 8),
                                                  child: Text(
                                                    'Stops',
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(top: 4),
                                              child: Text(
                                                "${widget.data[i]['fly_duration'].toString()}",
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            )
                                          ],
                                        ),
                                        Container(
                                          child: Icon(
                                            FontAwesomeIcons.arrowCircleRight,
                                            color: Color.fromARGB(
                                                255, 34, 180, 222),
                                          ),
                                          padding: EdgeInsets.all(8),
                                        ),
                                        Container(
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                child: Text(
                                                  "${widget.data[i]['cityTo'].toString()}",
                                                  style: TextStyle(
                                                      color: Colors
                                                          .lightBlueAccent),
                                                ),
                                              ),
                                              Container(
                                                child: Text(
                                                  "${widget.data[i]['flyTo'].toString()}",
                                                  style: TextStyle(
                                                      fontSize: 36,
                                                      color: Colors.blueAccent),
                                                ),
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
                                      color: Colors.black,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Container(
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                child: Text(
                                                  "${widget.data[i]['cityTo'].toString()}",
                                                  style: TextStyle(
                                                      fontFamily: "NUNITO",
                                                      color: Colors
                                                          .lightBlueAccent),
                                                ),
                                              ),
                                              Container(
                                                child: Text(
                                                  "${widget.data[i]['flyTo'].toString()}",
                                                  style: TextStyle(
                                                      fontSize: 36,
                                                      color: Colors.blueAccent),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ), // Origin Data
                                        Container(
                                          child: Icon(
                                            FontAwesomeIcons.arrowCircleRight,
                                            color: Color.fromARGB(
                                                255, 34, 180, 222),
                                          ),
                                          padding: EdgeInsets.all(8),
                                        ),
                                        Column(
                                          children: <Widget>[
                                            Container(
                                              child: Card(
                                                elevation: 0,
                                                child: Container(
                                                  color: Colors.grey[100],
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 8),
                                                  child: Text(
                                                    'Stops',
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(top: 4),
                                              child: Text(
                                                "${widget.data[i]['return_duration'].toString()}",
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            )
                                          ],
                                        ),
                                        Container(
                                          child: Icon(
                                            FontAwesomeIcons.arrowCircleRight,
                                            color: Color.fromARGB(
                                                255, 34, 180, 222),
                                          ),
                                          padding: EdgeInsets.all(8),
                                        ),
                                        Container(
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                child: Text(
                                                  "${widget.data[i]['cityFrom'].toString()}",
                                                  style: TextStyle(
                                                      color: Colors
                                                          .lightBlueAccent),
                                                ),
                                              ),
                                              Container(
                                                child: Text(
                                                  "${widget.data[i]['flyFrom'].toString()}",
                                                  style: TextStyle(
                                                      fontSize: 36,
                                                      color: Colors.blueAccent),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ), // Destination Data
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              // child: Text("From : ${widget.data[i]['flyFrom'].toString()} ( ${widget.data[i]['cityFrom'].toString()} )" +
                              //     "\nTo : ${widget.data[i]['flyTo'].toString()} ( ${widget.data[i]['cityTo'].toString()} )" +
                              //     "\nDistance : ${widget.data[i]['distance'].toString()} Miles" +
                              //     "\nDeparture Time : ${widget.data[i]['dTimeUTC'].toString()} UTC/seconds" +
                              //     "\nArrival Time : ${widget.data[i]['aTimeUTC'].toString()} UTC/seconds" +
                              //     "\nFly-Duration : ${widget.data[i]['fly_duration'].toString()}" +
                              //     "\nreturn-Duration : ${widget.data[i]['return_duration'].toString()}" +
                              //     "\nDollars : ${widget.data[i]['price'].toString()}"),
                            ),
                        body: Container(
                          color: Colors.blue,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        "Trip Distance \n${widget.data[i]['distance'].toString()} Miles",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        "Fly-Duration \n${widget.data[i]['fly_duration'].toString()}",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        "Return-Duration \n${widget.data[i]['return_duration'].toString()}",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(),
                              Container(
                                child: RaisedButton(
                                  color: Colors.lightGreenAccent,
                                  onPressed: () async {
                                    String url = widget.data[i]['deep_link'];
                                    if (await canLaunch(url)) {
                                      await launch(url);
                                      print(url);
                                    } else {
                                      throw 'Could not launch $url';
                                    }
                                  },
                                  child: Text('Buy ticket $i'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
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
