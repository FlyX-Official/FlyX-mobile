
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
              child: pageBody(snapshot),
            );
          }
        },
      ),
    );
  }

  Container pageBody(snapshot) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * .25,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(target: LatLng(0, 0)),
            ),
          ),
          Container(
            child: extentedPage(snapshot),
          ),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(16),
              ),
            ),
            width: 300,
            child: FlatButton(
              //padding: EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              color: Colors.lightGreenAccent,
              child: Text(
                'PURCHASE TICKET',
                textScaleFactor: 1.5,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
              ),
              onPressed: () async {
                String url = snapshot.data.data[num]['deep_link'];
                if (await canLaunch(url)) {
                  await launch(url);
                  print(url);
                } else {
                  throw 'Could not launch $url';
                }
                // _searchPageCollapseed();
                // postToGlitchServer();
                // PageItem(
                //   data: responseTicketData,
                // );
                // TicketListViewBuilder(
                //   data: responseTicketData,
                // );
                // _pageviewcontroller.animateToPage(
                //   2,
                //   duration: Duration(milliseconds: 1000),
                //   curve: Curves.easeInOutExpo.flipped,
                // );
              },
            ),
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
                            ListTile(
                              leading: Icon(FontAwesomeIcons.planeDeparture),
                              title: Text(
                                  '${DateFormat.MMMMd().add_jm().format(DateTime.fromMillisecondsSinceEpoch(snapshot.data.data[index].route[i].dTime * 1000))}' +
                                      ' ${snapshot.data.data[index].route[i].cityFrom}'),
                              // Text(
                              //     ' ${DateTime.fromMillisecondsSinceEpoch(snapshot.data.data[index].route[i].dTimeUtc * 1000, isUtc: true).hour}:${DateTime.fromMillisecondsSinceEpoch(snapshot.data.data[index].route[i].dTimeUtc * 1000, isUtc: true).minute}  ${snapshot.data.data[index].route[i].cityFrom}\n' +
                              //         ' ${DateTime.fromMillisecondsSinceEpoch(snapshot.data.data[index].route[i].aTimeUtc * 1000, isUtc: true).hour}:${DateTime.fromMillisecondsSinceEpoch(snapshot.data.data[index].route[i].aTimeUtc * 1000, isUtc: true).minute}  ${snapshot.data.data[index].route[i].cityTo}'),
                            ),
                            ListTile(
                              leading: Icon(FontAwesomeIcons.planeArrival),
                              title: Text(
                                  '${DateFormat.MMMMd().add_jm().format(DateTime.fromMillisecondsSinceEpoch(snapshot.data.data[index].route[i].aTime * 1000))}' +
                                      ' ${snapshot.data.data[index].route[i].cityTo}'),
                              // Text(
                              //     ' ${DateTime.fromMillisecondsSinceEpoch(snapshot.data.data[index].route[i].dTimeUtc * 1000, isUtc: true).hour}:${DateTime.fromMillisecondsSinceEpoch(snapshot.data.data[index].route[i].dTimeUtc * 1000, isUtc: true).minute}  ${snapshot.data.data[index].route[i].cityFrom}\n' +
                              //         ' ${DateTime.fromMillisecondsSinceEpoch(snapshot.data.data[index].route[i].aTimeUtc * 1000, isUtc: true).hour}:${DateTime.fromMillisecondsSinceEpoch(snapshot.data.data[index].route[i].aTimeUtc * 1000, isUtc: true).minute}  ${snapshot.data.data[index].route[i].cityTo}'),
                            ),
                            Container(
                              child: Text(
                                  'Aircraft Carrier ${snapshot.data.data[index].route[i].airline}'),
                            ),
                            Text("${DateTime.fromMillisecondsSinceEpoch(snapshot.data.data[index].dTimeUtc * 1000, isUtc: true).day.toString()}" +
                                "-${DateTime.fromMillisecondsSinceEpoch(snapshot.data.data[index].dTimeUtc * 1000, isUtc: true).month.toString()}" +
                                "-${DateTime.fromMillisecondsSinceEpoch(snapshot.data.data[index].dTimeUtc * 1000, isUtc: true).year.toString()}"),
                            // Text('From lat --> ${snapshot.data.data[index].route[i].latFrom}' +
                            //     ' || From lng --> ${snapshot.data.data[index].route[i].lngFrom}\n' +
                            //     'To lat --> ${snapshot.data.data[index].route[i].latTo}' +
                            //     ' || To lng --> ${snapshot.data.data[index].route[i].lngTo}\n'),
                            Text(
                                'Flight Number ${snapshot.data.data[index].route[i].flightNo}\n'),
                            Text(
                                'Return: ${snapshot.data.data[index].route[i].routeReturn}')
                            // Chip(
                            //   label: Text(
                            //       '${DateTime.fromMillisecondsSinceEpoch(snapshot.data.data[index].route[i + 1].dTimeUtc * 1000, isUtc: true).difference(DateTime.fromMillisecondsSinceEpoch(snapshot.data.data[index].route[i].aTimeUtc * 1000, isUtc: true)).inHours}H'),
                            // )
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

