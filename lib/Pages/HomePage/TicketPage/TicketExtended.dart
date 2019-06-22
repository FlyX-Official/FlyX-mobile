import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flyx/Pages/Schema/TwoWaySchema.dart';
import 'package:flyx/Pages/Schema/TwoWaySchema.dart' as prefix0;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class TicketDetailPage extends StatefulWidget {
  final List<prefix0.Route> route;
  final List<Datum> data;
  final int ticketNumber;
  const TicketDetailPage({Key key, this.data, this.route, this.ticketNumber})
      : super(key: key);

  @override
  _TicketDetailPageState createState() => _TicketDetailPageState();
}

class _TicketDetailPageState extends State<TicketDetailPage> {
  Text timings(int index, int i, int index2, int i2) {
    dynamic route1 = widget.route[i].aTimeUtc * 1000;
    dynamic route2 = widget.data[index2].route[i2].dTimeUtc * 1000;
    Text hr() {
      String _layoverInfo = DateTime.fromMillisecondsSinceEpoch(route1,
              isUtc: true)
          .difference(DateTime.fromMillisecondsSinceEpoch(route2, isUtc: true))
          .abs()
          .toString();

      List<String> _layoverTime = _layoverInfo.split(':').toList();
      //  return Text('${layoverInfo.split(':').toList().toString()}D ');
      print('${_layoverTime[0]}h ${_layoverTime[1]}m');
      return Text('${_layoverTime[0]}h ${_layoverTime[1]}m');
    }

    return hr();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * .33,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      widget.route[0].latFrom,
                      widget.route[0].lngFrom,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ticketInfo(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container ticketInfo() {
    int length = widget.route.length;
    int index = widget.ticketNumber;
    return Container(
      child: ListView.builder(
        itemCount: length,
        itemBuilder: (context, i) {
          return Card(
            child: Column(
              children: <Widget>[
                widget.route[i].routeReturn == 0
                    ? Column(
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              // Text(
                              //   '${DateFormat.MMMd().format(DateTime.fromMillisecondsSinceEpoch(widget.route[i].dTimeUtc * 1000))} - ${DateFormat.MMMd().format(DateTime.fromMillisecondsSinceEpoch(widget.route[i].aTimeUtc * 1000))}',
                              // ),
                              ExpansionTile(
                                initiallyExpanded: (widget.route[i].flyTo ==
                                        widget.data[index].routes[0][1])
                                    ? true
                                    : false,
                                leading: Image.network(
                                  'https://images.kiwi.com/airlines/64/${widget.route[i].airline}.png',
                                ),
                                title: Text(
                                  '${DateFormat.Hm().format(DateTime.fromMillisecondsSinceEpoch(widget.route[i].dTimeUtc * 1000))} ${widget.route[i].cityFrom} - ${widget.route[i].flyFrom}' +
                                      '\n${DateFormat.Hm().format(DateTime.fromMillisecondsSinceEpoch(widget.route[i].aTimeUtc * 1000))} ${widget.route[i].cityTo} - ${widget.route[i].flyTo}',
                                ),
                                children: <Widget>[
                                  Container(
                                    child: (widget.route[i].flyTo ==
                                            widget.data[index].routes[0][1])
                                        ? ListTile(
                                            leading: Icon(Icons.access_time),
                                            title: Text(
                                              ' ${DateTime.fromMillisecondsSinceEpoch(widget.route[i + 1].aTimeUtc * 1000, isUtc: true).difference(DateTime.fromMillisecondsSinceEpoch(widget.route[i].dTimeUtc * 1000, isUtc: true)).inDays.toString()} Days in Destination',
                                            ),
                                          )
                                        : Card(
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              physics: BouncingScrollPhysics(),
                                              child: Column(
                                                children: <Widget>[
                                                  RawChip(
                                                    label: Row(
                                                      children: <Widget>[
                                                        Icon(Icons.access_time),
                                                        timings(
                                                          index,
                                                          i,
                                                          index,
                                                          i,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  RawChip(
                                                    label: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Icon(Icons.access_time),
                                                        timings(
                                                          index,
                                                          i,
                                                          index,
                                                          i + 1,
                                                        ),
                                                        Text(' Layover')
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                      child: widget
                                                                  .data[index]
                                                                  .route[i]
                                                                  .bagsRecheckRequired ==
                                                              true
                                                          ? RawChip(
                                                              backgroundColor:
                                                                  Colors.red,
                                                              label: Text(
                                                                  'Must Recheck Bags'),
                                                            )
                                                          : null),
                                                ],
                                              ),
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // : ListTile(
                          //     leading: Icon(Icons.access_time),
                          //     title: Text(
                          //       "${DateTime.fromMillisecondsSinceEpoch(widget.data[index + 1].route[i + 1].aTimeUtc * 1000, isUtc: true).difference(DateTime.fromMillisecondsSinceEpoch(widget.route[i].dTimeUtc * 1000, isUtc: true)).inHours} Hr Layover",
                          //     ),
                          //   ),
                        ],
                      )
                    : Column(
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              // Text(
                              //   '${DateFormat.MMMd().format(DateTime.fromMillisecondsSinceEpoch(widget.route[i].dTimeUtc * 1000))} - ${DateFormat.MMMd().format(DateTime.fromMillisecondsSinceEpoch(widget.route[i].aTimeUtc * 1000))}',
                              // ),
                              ExpansionTile(
                                initiallyExpanded: (widget.route[i].flyTo ==
                                        widget.data[index].routes[1][1])
                                    ? true
                                    : false,
                                leading: Image.network(
                                  'https://images.kiwi.com/airlines/64/${widget.route[i].airline}.png',
                                ),
                                title: Text(
                                  '${DateFormat.Hm().format(DateTime.fromMillisecondsSinceEpoch(widget.route[i].dTimeUtc * 1000))} ${widget.route[i].cityFrom} - ${widget.route[i].flyFrom}' +
                                      '\n${DateFormat.Hm().format(DateTime.fromMillisecondsSinceEpoch(widget.route[i].aTimeUtc * 1000))} ${widget.route[i].cityTo} - ${widget.route[i].flyTo}',
                                ),
                                children: <Widget>[
                                  (widget.route[i].flyTo ==
                                          widget.data[index].routes[1][1])
                                      ? Container(
                                          color: Colors.white10,
                                          child: Container(
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(16),
                                              ),
                                            ),
                                            width: double.infinity,
                                            child: FlatButton(
                                              //padding: EdgeInsets.all(16),
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color: Colors.black,
                                                    width: 2),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(16),
                                                ),
                                              ),
                                              color: Colors.lightGreenAccent,
                                              child: Text(
                                                '\$${widget.data[index].price} Purchase Ticket',
                                                textScaleFactor: 1.5,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                              onPressed: () async {
                                                String url =
                                                    widget.data[index].deepLink;
                                                if (await canLaunch(url)) {
                                                  await launch(url);
                                                  print(url);
                                                } else {
                                                  throw 'Could not launch $url';
                                                }
                                              },
                                            ),
                                          ),
                                        )
                                      : Card(
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            physics: BouncingScrollPhysics(),
                                            child: Column(
                                              children: <Widget>[
                                                RawChip(
                                                  label: Row(
                                                    children: <Widget>[
                                                      Icon(Icons.access_time),
                                                      timings(
                                                        index,
                                                        i,
                                                        index,
                                                        i,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                    child: widget
                                                                .data[index]
                                                                .route[i]
                                                                .bagsRecheckRequired ==
                                                            true
                                                        ? RawChip(
                                                            backgroundColor:
                                                                Colors.red,
                                                            label: Text(
                                                                'Must Recheck Bags'),
                                                          )
                                                        : null),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Icon(Icons.access_time),
                                                    timings(
                                                      index,
                                                      i,
                                                      index,
                                                      i + 1,
                                                    ),
                                                    Text(' Layover')
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ],
                          ),

                          // : ListTile(
                          //     leading: Icon(Icons.access_time),
                          //     title: Text(
                          //       "${DateTime.fromMillisecondsSinceEpoch(widget.data[index + 1].route[i + 1].aTimeUtc * 1000, isUtc: true).difference(DateTime.fromMillisecondsSinceEpoch(widget.route[i].dTimeUtc * 1000, isUtc: true)).inHours} Hr Layover",
                          //     ),
                          //   ),
                        ],
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
