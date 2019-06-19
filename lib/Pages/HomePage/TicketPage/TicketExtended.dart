import 'package:flutter/material.dart';
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
    dynamic route1 = widget.data[index].route[i].aTimeUtc * 1000;
    dynamic route2 = widget.data[index2].route[i2].dTimeUtc * 1000;
    String days, hours, minutes;
    String layoverInfo;

    Text format() {
      layoverInfo = DateTime.fromMillisecondsSinceEpoch(route1, isUtc: true)
          .difference(DateTime.fromMillisecondsSinceEpoch(route2, isUtc: true))
          .abs()
          .toString();

      List<String> layoverTime = layoverInfo.split(':').toList();
      //  return Text('${layoverInfo.split(':').toList().toString()}D ');
      return Text('${layoverTime[0]}h ${layoverTime[1]}m');
    }

    if (DateTime.fromMillisecondsSinceEpoch(
                widget.data[index].route[i].aTimeUtc * 1000,
                isUtc: true)
            .difference(DateTime.fromMillisecondsSinceEpoch(
                widget.data[index].route[i].dTimeUtc * 1000,
                isUtc: true))
            .inMinutes >=
        60) {
      return format();
      // return Text(
      //   '${DateTime.fromMillisecondsSinceEpoch(route1, isUtc: true).difference(DateTime.fromMillisecondsSinceEpoch(route2, isUtc: true)).inHours.abs().toString()} Hr',
      // );
    } else {
      return Text(
        '${DateTime.fromMillisecondsSinceEpoch(route1, isUtc: true).difference(DateTime.fromMillisecondsSinceEpoch(route2, isUtc: true)).inMinutes.toString()} Min',
      );
    }
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
                  initialCameraPosition: CameraPosition(target: LatLng(0, 0)),
                ),
              ),
              Expanded(child: ticketInfo()),
            ],
          ),
        ),
      ),
    );
  }

  Container ticketInfo() {
    return Container(
      child: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          return Container(
            //padding: EdgeInsets.all(8),
            child: Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * .66,
                  width: 450,
                  //padding: EdgeInsets.all(8),
                  child: ListView.builder(
                    physics: ClampingScrollPhysics(),
                    itemCount: widget.data[index].route.length,
                    itemBuilder: (context, i) {
                      return Card(
                        child: Column(
                          children: <Widget>[
                            widget.data[index].route[i].routeReturn == 0
                                ? Column(
                                    children: <Widget>[
                                      Card(
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              '${DateFormat.MMMd().format(DateTime.fromMillisecondsSinceEpoch(widget.data[index].route[i].dTimeUtc * 1000))} - ${DateFormat.MMMd().format(DateTime.fromMillisecondsSinceEpoch(widget.data[index].route[i].aTimeUtc * 1000))}',
                                            ),
                                            ListTile(
                                              leading: Image.network(
                                                'https://images.kiwi.com/airlines/64/${widget.data[index].route[i].airline}.png',
                                              ),
                                              title: Text(
                                                '${DateFormat.Hm().format(DateTime.fromMillisecondsSinceEpoch(widget.data[index].route[i].dTimeUtc * 1000))} ${widget.data[index].route[i].cityFrom} - ${widget.data[index].route[i].flyFrom}' +
                                                    '\n${DateFormat.Hm().format(DateTime.fromMillisecondsSinceEpoch(widget.data[index].route[i].aTimeUtc * 1000))} ${widget.data[index].route[i].cityTo} - ${widget.data[index].route[i].flyTo}',
                                              ),
                                              subtitle: SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                physics:
                                                    BouncingScrollPhysics(),
                                                child: Row(
                                                  children: <Widget>[
                                                    RawChip(
                                                      label: Row(
                                                        children: <Widget>[
                                                          Icon(Icons
                                                              .access_time),
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
                                                            : null)
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      (widget.data[index].route[i].flyTo ==
                                              widget.data[index].routes[0][1])
                                          ? ListTile(
                                              leading: Icon(Icons.access_time),
                                              title: Text(
                                                ' ${DateTime.fromMillisecondsSinceEpoch(widget.data[index].route[i + 1].aTimeUtc * 1000, isUtc: true).difference(DateTime.fromMillisecondsSinceEpoch(widget.data[index].route[i].dTimeUtc * 1000, isUtc: true)).inDays.toString()} Days in Destination',
                                              ),
                                            )
                                          : ListTile(
                                              title: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(Icons.access_time),
                                                  timings(
                                                    index,
                                                    i,
                                                    index + 1,
                                                    i + 1,
                                                  ),
                                                  Text(' Layover')
                                                ],
                                              ),
                                            ),
                                      // : ListTile(
                                      //     leading: Icon(Icons.access_time),
                                      //     title: Text(
                                      //       "${DateTime.fromMillisecondsSinceEpoch(widget.data[index + 1].route[i + 1].aTimeUtc * 1000, isUtc: true).difference(DateTime.fromMillisecondsSinceEpoch(widget.data[index].route[i].dTimeUtc * 1000, isUtc: true)).inHours} Hr Layover",
                                      //     ),
                                      //   ),
                                    ],
                                  )
                                : Column(
                                    children: <Widget>[
                                      Card(
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              '${DateFormat.MMMd().format(DateTime.fromMillisecondsSinceEpoch(widget.data[index].route[i].dTimeUtc * 1000))} - ${DateFormat.MMMd().format(DateTime.fromMillisecondsSinceEpoch(widget.data[index].route[i].aTimeUtc * 1000))}',
                                            ),
                                            ListTile(
                                              leading: Image.network(
                                                'https://images.kiwi.com/airlines/64/${widget.data[index].route[i].airline}.png',
                                              ),
                                              title: Text(
                                                '${DateFormat.Hm().format(DateTime.fromMillisecondsSinceEpoch(widget.data[index].route[i].dTimeUtc * 1000))} ${widget.data[index].route[i].cityFrom} - ${widget.data[index].route[i].flyFrom}' +
                                                    '\n${DateFormat.Hm().format(DateTime.fromMillisecondsSinceEpoch(widget.data[index].route[i].aTimeUtc * 1000))} ${widget.data[index].route[i].cityTo} - ${widget.data[index].route[i].flyTo}',
                                              ),
                                              subtitle: SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                physics:
                                                    BouncingScrollPhysics(),
                                                child: Row(
                                                  children: <Widget>[
                                                    RawChip(
                                                      label: Row(
                                                        children: <Widget>[
                                                          Icon(Icons
                                                              .access_time),
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
                                                            : null)
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      (widget.data[index].route[i].flyTo ==
                                              widget.data[index].routes[1][1])
                                          ? Container(
                                              child: Container(
                                                padding: EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
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
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(16),
                                                    ),
                                                  ),
                                                  color:
                                                      Colors.lightGreenAccent,
                                                  child: Text(
                                                    '\$${widget.data[index].price} Purchase Ticket',
                                                    textScaleFactor: 1.5,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  onPressed: () async {
                                                    String url = widget
                                                        .data[index].deepLink;
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
                                          : ListTile(
                                              title: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(Icons.access_time),
                                                  timings(index, i, index + 1,
                                                      i + 1),
                                                  Text(' Layover')
                                                ],
                                              ),
                                            ),
                                    ],
                                  ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
