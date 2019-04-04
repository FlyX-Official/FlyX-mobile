import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

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
  bool _isOpen = false;

  int _currentIndexCounter;

  double _thisItem = 0.0;

  Widget added(BuildContext contex) {
    if (_isOpen) {
      _isOpen = false;
      return AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        child: Container(
          child: Text("data"),
          height: 200.0,
          color: Colors.red,
        ),
        height: _thisItem,
      );
    }
    _isOpen = true;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      child: Container(
        child: Text("data"),
        height: 0.0,
      ),
      height: _thisItem,
    );
  }

  @override
  Widget build(BuildContext context) {
    //return await buildSafeArea();
    return SafeArea(
      child: ListView.builder(
        itemCount: widget.data == null ? 0 : widget.data.length,
        itemBuilder: (context, i) {
          return Hero(
            tag: "card$i",
            child: Container(
              padding: EdgeInsets.only(left: 8,top: 8,bottom: 8, right: 8),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(16.0),
                  ),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                color: Color.fromARGB(255, 100, 135, 165),
                                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
                                                fontSize: 48,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ), //${widget.data[i]['dTimeUTC'].toString()} UTC"),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: 8, right: 8),
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
                                                fontSize: 48,
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
                                          fontSize: 43,
                                          fontFamily: 'OpenSans',
                                          
                                          fontWeight: FontWeight.bold,
                                          //fontWeight: FontWeight.w700,
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
                                                  //fontFamily: "OpenSans",
                                                  color:
                                                      Colors.lightBlueAccent),
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              "${widget.data[i]['flyFrom'].toString()}",
                                              style: TextStyle(
                                                  fontSize: 36,
                                                  color: Colors.blueAccent,
                                                  //fontFamily: "OpenSans",
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ), // Origin Data
                                    Container(
                                      child: Icon(
                                        FontAwesomeIcons.arrowCircleRight,
                                        color:
                                            Color.fromARGB(255, 34, 180, 222),
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
                                                  horizontal: 16, vertical: 8),
                                              child: Text(
                                                '3 Stops',
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
                                        color:
                                            Color.fromARGB(255, 34, 180, 222),
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
                                                  color:
                                                      Colors.lightBlueAccent),
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
                                                  color:
                                                      Colors.lightBlueAccent),
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
                                        color:
                                            Color.fromARGB(255, 34, 180, 222),
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
                                                  horizontal: 16, vertical: 8),
                                              child: Text(
                                                '7 Stops',
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
                                        color:
                                            Color.fromARGB(255, 34, 180, 222),
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
                                                  color:
                                                      Colors.lightBlueAccent),
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
                        ),
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
                                  return new PageItem(num: i);
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
            ),
          );
        },
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
      leading: IconTheme(
          data: IconThemeData(color: Colors.white), child: CloseButton()),
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
                child:
                    Image.network("https://picsum.photos/485/384?image=$num"),
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
