import 'package:flutter/material.dart';
import 'package:flyx/Pages/Logic/NetworkCalls.dart';
import 'package:flyx/Pages/Schema/TwoWaySchema.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

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
    return Container(
      child: FutureBuilder<RoundTrip>(
        future: twoWay(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              //child: pageBody(snapshot),
              child: tripInfo(snapshot),
            );
          }
        },
      ),
    );
  }

  Scaffold tripInfo(snapshot) {
    return Scaffold(
      extendBody: false,
      body: Container(
        child: Center(
          child: Container(
            child: pageBody(snapshot),
          ),
        ),
      ),
      // bottomNavigationBar: Container(
      //   child: Container(
      //     padding: EdgeInsets.all(8),
      //     decoration: BoxDecoration(
      //       borderRadius: BorderRadius.all(
      //         Radius.circular(16),
      //       ),
      //     ),
      //     width: double.infinity,
      //     child: FlatButton(
      //       //padding: EdgeInsets.all(16),
      //       shape: RoundedRectangleBorder(
      //           side: BorderSide(color: Colors.black, width: 2),
      //           borderRadius: BorderRadius.all(Radius.circular(16))),
      //       color: Colors.lightGreenAccent,
      //       child: Text(
      //         'Purchase Ticket',
      //         textScaleFactor: 1.5,
      //         style:
      //             TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
      //       ),
      //       onPressed: () async {
      //         String url = snapshot.data.data[num]['deep_link'];
      //         if (await canLaunch(url)) {
      //           await launch(url);
      //           print(url);
      //         } else {
      //           throw 'Could not launch $url';
      //         }
      //       },
      //     ),
      //   ),
      // ),
    );
  }

  Container pageBody(snapshot) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * .33,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(target: LatLng(0, 0)),
            ),
          ),
          Container(
            child: extentedPage(snapshot),
          ),

          // Container(
          //   child: RaisedButton(
          //       onPressed: () async {}, child: Text('Purchase Ticket')),
          // ),
        ],
      ),
    );
  }

  Expanded extentedPage(snapshot) {
    Text timings(int index, int i, int index2, int i2) {
      if (DateTime.fromMillisecondsSinceEpoch(
                  snapshot.data.data[index].route[i].aTimeUtc * 1000,
                  isUtc: true)
              .difference(DateTime.fromMillisecondsSinceEpoch(
                  snapshot.data.data[index].route[i].dTimeUtc * 1000,
                  isUtc: true))
              .inMinutes >=
          60) {
        return Text(
          '${DateTime.fromMillisecondsSinceEpoch(snapshot.data.data[index].route[i].aTimeUtc * 1000, isUtc: true).difference(DateTime.fromMillisecondsSinceEpoch(snapshot.data.data[index2].route[i2].dTimeUtc * 1000, isUtc: true)).inHours.toString()} Hr',
        );
      } else {
        return Text(
          '${DateTime.fromMillisecondsSinceEpoch(snapshot.data.data[index].route[i].aTimeUtc * 1000, isUtc: true).difference(DateTime.fromMillisecondsSinceEpoch(snapshot.data.data[index2].route[i2].dTimeUtc * 1000, isUtc: true)).inMinutes.toString()} Min',
        );
      }
    }

    return Expanded(
      //height: MediaQuery.of(context).size.height*.70,
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
                    itemCount: snapshot.data.data[index].route.length,
                    itemBuilder: (context, i) {
                      return Card(
                        child: Column(
                          children: <Widget>[
                            snapshot.data.data[index].route[i].routeReturn == 0
                                ? Column(
                                    children: <Widget>[
                                      Card(
                                        child: Column(
                                          children: <Widget>[
                                            // Text('Return Trip'),
                                            ListTile(
                                                leading: Image.network(
                                                  'https://images.kiwi.com/airlines/64/${snapshot.data.data[index].route[i].airline}.png',
                                                ),
                                                title: Text(
                                                  '${snapshot.data.data[index].route[i].cityFrom} - ${snapshot.data.data[index].route[i].flyFrom}' +
                                                      '\n${snapshot.data.data[index].route[i].cityTo} - ${snapshot.data.data[index].route[i].flyTo}',
                                                ),
                                                subtitle: Row(
                                                  children: <Widget>[
                                                    Icon(Icons.access_time),
                                                    timings(index,i,index,i,),
                                                    // Text(
                                                    //   '${DateTime.fromMillisecondsSinceEpoch(snapshot.data.data[index].route[i].aTimeUtc * 1000, isUtc: true).difference(DateTime.fromMillisecondsSinceEpoch(snapshot.data.data[index].route[i].dTimeUtc * 1000, isUtc: true)).inMinutes.toString()} minutes',
                                                    // ),
                                                  ],
                                                )),
                                          ],
                                        ),
                                      ),
                                      (snapshot.data.data[index].route[i]
                                                  .flyTo ==
                                              snapshot.data.data[index]
                                                  .routes[0][1])
                                          ? Text(
                                              ' ${DateTime.fromMillisecondsSinceEpoch(snapshot.data.data[index].route[i + 1].aTimeUtc * 1000, isUtc: true).difference(DateTime.fromMillisecondsSinceEpoch(snapshot.data.data[index].route[i].dTimeUtc * 1000, isUtc: true)).inDays.toString()} Days in Destination',
                                            )
                                          : ListTile(
                                              leading: Icon(Icons.access_time),
                                              title: Text(
                                                "${DateTime.fromMillisecondsSinceEpoch(snapshot.data.data[index + 1].route[i + 1].aTimeUtc * 1000, isUtc: true).difference(DateTime.fromMillisecondsSinceEpoch(snapshot.data.data[index].route[i].dTimeUtc * 1000, isUtc: true)).inHours} Hr Layover",
                                              ),
                                            ),
                                    ],
                                  )
                                : Column(
                                    children: <Widget>[
                                      Card(
                                        child: Column(
                                          children: <Widget>[
                                            // Text('Return Trip'),
                                            ListTile(
                                              leading: Image.network(
                                                'https://images.kiwi.com/airlines/64/${snapshot.data.data[index].route[i].airline}.png',
                                              ),
                                              title: Text(
                                                '${snapshot.data.data[index].route[i].cityFrom} - ${snapshot.data.data[index].route[i].flyFrom}' +
                                                    '\n${snapshot.data.data[index].route[i].cityTo} - ${snapshot.data.data[index].route[i].flyTo}',
                                              ),
                                              subtitle: Row(
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
                                          ],
                                        ),
                                      ),
                                      (snapshot.data.data[index].route[i]
                                                  .flyTo ==
                                              snapshot.data.data[index]
                                                  .routes[1][1])
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
                                                              Radius.circular(
                                                                  16))),
                                                  color:
                                                      Colors.lightGreenAccent,
                                                  child: Text(
                                                    '\$${snapshot.data.data[index].price} Purchase Ticket',
                                                    textScaleFactor: 1.5,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  onPressed: () async {
                                                    String url = snapshot.data
                                                        .data[num]['deep_link'];
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
                                                  timings(index + 1, i + 1,
                                                      index, i),
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

//DateFormat.yMMMMEEEEd().format(DateTime.fromMillisecondsSinceEpoch(snapshot.data.data[index].dTimeUtc * 1000, isUtc: true))
// Column(
//                                     children: <Widget>[
//                                       ListTile(
//                                         leading: Image.network(
//                                           'https://images.kiwi.com/airlines/64/${snapshot.data.data[index].route[i].airline}.png',
//                                         ),
//                                         title: Text(
//                                             '${DateFormat.MMMMd().add_jm().format(DateTime.fromMillisecondsSinceEpoch(snapshot.data.data[index].route[i].dTime * 1000))}' +
//                                                 ' ${snapshot.data.data[index].route[i].cityFrom}'),
//                                         // Text(
//                                         //     ' ${DateTime.fromMillisecondsSinceEpoch(snapshot.data.data[index].route[i].dTimeUtc * 1000, isUtc: true).hour}:${DateTime.fromMillisecondsSinceEpoch(snapshot.data.data[index].route[i].dTimeUtc * 1000, isUtc: true).minute}  ${snapshot.data.data[index].route[i].cityFrom}\n' +
//                                         //         ' ${DateTime.fromMillisecondsSinceEpoch(snapshot.data.data[index].route[i].aTimeUtc * 1000, isUtc: true).hour}:${DateTime.fromMillisecondsSinceEpoch(snapshot.data.data[index].route[i].aTimeUtc * 1000, isUtc: true).minute}  ${snapshot.data.data[index].route[i].cityTo}'),
//                                       ),
//                                       ListTile(
//                                         leading:
//                                             Icon(FontAwesomeIcons.planeArrival),
//                                         title: Text(
//                                             '${DateFormat.MMMMd().add_jm().format(DateTime.fromMillisecondsSinceEpoch(snapshot.data.data[index].route[i].aTime * 1000))}' +
//                                                 ' ${snapshot.data.data[index].route[i].cityTo}'),
//                                         // Text(
//                                         //     ' ${DateTime.fromMillisecondsSinceEpoch(snapshot.data.data[index].route[i].dTimeUtc * 1000, isUtc: true).hour}:${DateTime.fromMillisecondsSinceEpoch(snapshot.data.data[index].route[i].dTimeUtc * 1000, isUtc: true).minute}  ${snapshot.data.data[index].route[i].cityFrom}\n' +
//                                         //         ' ${DateTime.fromMillisecondsSinceEpoch(snapshot.data.data[index].route[i].aTimeUtc * 1000, isUtc: true).hour}:${DateTime.fromMillisecondsSinceEpoch(snapshot.data.data[index].route[i].aTimeUtc * 1000, isUtc: true).minute}  ${snapshot.data.data[index].route[i].cityTo}'),
//                                       ),
//                                       Container(
//                                         child: Text(
//                                             'Aircraft Carrier ${snapshot.data.data[index].route[i].airline}'),
//                                       ),
//                                       Text("${DateTime.fromMillisecondsSinceEpoch(snapshot.data.data[index].dTimeUtc * 1000, isUtc: true).day.toString()}" +
//                                           "-${DateTime.fromMillisecondsSinceEpoch(snapshot.data.data[index].dTimeUtc * 1000, isUtc: true).month.toString()}" +
//                                           "-${DateTime.fromMillisecondsSinceEpoch(snapshot.data.data[index].dTimeUtc * 1000, isUtc: true).year.toString()}"),
//                                       // Text('From lat --> ${snapshot.data.data[index].route[i].latFrom}' +
//                                       //     ' || From lng --> ${snapshot.data.data[index].route[i].lngFrom}\n' +
//                                       //     'To lat --> ${snapshot.data.data[index].route[i].latTo}' +
//                                       //     ' || To lng --> ${snapshot.data.data[index].route[i].lngTo}\n'),
//                                       Text(
//                                           'Flight Number ${snapshot.data.data[index].route[i].flightNo}\n'),
//                                       Text(
//                                           'Return: ${snapshot.data.data[index].route[i].routeReturn}')
//                                       // Chip(
//                                       //   label: Text(
//                                       //       '${DateTime.fromMillisecondsSinceEpoch(snapshot.data.data[index].route[i + 1].dTimeUtc * 1000, isUtc: true).difference(DateTime.fromMillisecondsSinceEpoch(snapshot.data.data[index].route[i].aTimeUtc * 1000, isUtc: true)).inHours}H'),
//                                       // )
//                                     ],
//                                   ),
