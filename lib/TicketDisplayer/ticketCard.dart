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
    return Container(
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
                              padding: EdgeInsets.all(8),
                              alignment: Alignment.center,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    //padding: EdgeInsets.all(8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Container(
                                          child: Text(
                                              "DepTime : "), //${widget.data[i]['dTimeUTC'].toString()} UTC"),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(8),
                                          child: Text(
                                            "PRICE ${widget.data[i]['price'].toString()}\$",
                                            style: TextStyle(
                                                color: Colors.blueAccent),
                                          ), // ${widget.data[i]['aTimeUTC'].toString()} UTC"),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                      padding:
                                          EdgeInsets.only(left: 8, right: 8),
                                      child: Divider()),
                                  Container(
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
                                                  "${widget.data[i]['flyFrom'].toString()}",
                                                  style: TextStyle(
                                                      fontSize: 36,
                                                      color: Colors.blueAccent),
                                                ),
                                              ),
                                              Container(
                                                child: Text(
                                                  "${widget.data[i]['cityFrom'].toString()}",
                                                  style: TextStyle(
                                                      fontFamily: "NUNITO",
                                                      color: Colors
                                                          .lightBlueAccent),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ), // Origin Data
                                        Container(
                                          padding: EdgeInsets.all(8),
                                          child: Icon(
                                            FontAwesomeIcons.plane,
                                            color: Colors.blueGrey,
                                          ),
                                        ),
                                        Container(
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                child: Text(
                                                  "${widget.data[i]['flyTo'].toString()}",
                                                  style: TextStyle(
                                                      fontSize: 36,
                                                      color: Colors.blueAccent),
                                                ),
                                              ),
                                              Container(
                                                child: Text(
                                                  "${widget.data[i]['cityTo'].toString()}",
                                                  style: TextStyle(
                                                      color: Colors
                                                          .lightBlueAccent),
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
          }),
    );
  }
}
