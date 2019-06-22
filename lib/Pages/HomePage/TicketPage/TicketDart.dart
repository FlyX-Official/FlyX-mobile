import 'package:flutter/material.dart';
import 'package:flyx/Pages/Logic/NetworkCalls.dart';
import 'package:flyx/Pages/Schema/TwoWaySchema.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'TicketExtended.dart';

class TicketPage extends StatefulWidget {
  TicketPage({Key key}) : super(key: key);

  _TicketPageState createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: FutureBuilder<RoundTrip>(
          future: twoWay(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                padding: EdgeInsets.only(top: 16, bottom: 80),
                itemCount: snapshot.data.data.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.only(bottom: 16),
                    child: ticketCard(context, snapshot, index),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            // By default, show a loading spinner.
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

Container ticketCard(
    BuildContext context, AsyncSnapshot<RoundTrip> snapshot, int index) {
  return Container(
    child: InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            maintainState: false,
            builder: (context) {
              return TicketDetailPage(
                data: snapshot.data.data,
                route: snapshot.data.data[index].route,
                ticketNumber: index,
              );
            },
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          color: Colors.white,
        ),
        child: Card(
          //color: Colors.limeAccent,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  color: Color.fromARGB(255, 100, 135, 165),
                ),
                // color: Colors.lightBlueAccent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    // Container(
                    //   child: Text(
                    //     '${snapshot.data.data[index].airlines}',
                    //     textScaleFactor: 2,
                    //     style: TextStyle(color: Colors.white),
                    //   ),
                    // ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(16),
                        ),
                      ),
                      margin: EdgeInsets.only(left: 4.0),
                      height: 40,
                      width: MediaQuery.of(context).size.width * .66,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.data[index].airlines.length,
                        itemBuilder: (context, i) {
                          return Container(
                            padding: EdgeInsets.only(right: 2),
                            child: Image.network(
                              'https://images.kiwi.com/airlines/64/${snapshot.data.data[index].airlines[i]}.png',
                            ),
                          );
                        },
                      ),
                    ), // For AirlineLogos

                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(16),
                            bottomLeft: Radius.circular(16)),
                      ),
                      color: Colors.lightGreenAccent,
                      elevation: 2,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        width: MediaQuery.of(context).size.width * .25,
                        child: Center(
                          child: Text(
                            '\$${snapshot.data.data[index].price}',
                            textScaleFactor: 2.25,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              //Divider(color: Colors.black,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          '${snapshot.data.data[index].cityFrom}',
                          textScaleFactor: 1,
                        ),
                      ),
                      Container(
                        child: Text('${snapshot.data.data[index].routes[0][0]}',
                            style: TextStyle(fontSize: 34)),
                      ),
                      // Container(
                      //   child: Text(
                      //       '${DateFormat.MMMMd().add_jm().format(DateTime.fromMillisecondsSinceEpoch(snapshot.data.data[index].dTime * 1000))}'),
                      // ),
                    ],
                  ),
                  Container(
                    child: Icon(FontAwesomeIcons.arrowAltCircleRight),
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        child: Chip(
                          label: Text(
                              '${snapshot.data.data[index].route.length / 2} Stop'),
                        ),
                      ),
                      Container(
                        child: Text('${snapshot.data.data[index].flyDuration}'),
                      )
                    ],
                  ),
                  Container(
                    child: Icon(FontAwesomeIcons.arrowAltCircleRight),
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          '${snapshot.data.data[index].cityTo}',
                          textScaleFactor: 1,
                        ),
                      ),
                      Container(
                        child: Text('${snapshot.data.data[index].routes[0][1]}',
                            style: TextStyle(fontSize: 34)),
                      ),
                      // Container(
                      //   child: Text(
                      //       '${DateFormat.MMMMd().add_jm().format(DateTime.fromMillisecondsSinceEpoch(snapshot.data.data[index].aTime * 1000))}'),
                      // ),
                    ],
                  ),
                ],
              ),
              Divider(
                color: Colors.black,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    child: Text('${snapshot.data.data[index].routes[1][0]}',
                        style: TextStyle(fontSize: 34)),
                  ),
                  Container(
                    child: Icon(FontAwesomeIcons.arrowAltCircleRight),
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        child: Chip(
                          label: Text(
                              '${snapshot.data.data[index].route.length / 2} Stop'),
                        ),
                      ),
                      Container(
                        child:
                            Text('${snapshot.data.data[index].returnDuration}'),
                      ),
                    ],
                  ),
                  Container(
                    child: Icon(FontAwesomeIcons.arrowAltCircleRight),
                  ),
                  Container(
                    child: Text('${snapshot.data.data[index].routes[1][1]}',
                        style: TextStyle(fontSize: 34)),
                  ),
                ],
              ),
              Divider(
                indent: 5,
                endIndent: 5,
              ),

              // Text(
              //     'One-Way ${snapshot.data.data[index].routes[0]} Return Trip${snapshot.data.data[index].routes[1]}'),
              // Text(
              //     'Fly_Duration: ${snapshot.data.data[index].flyDuration} Return_Duration: ${snapshot.data.data[index].returnDuration}'),
              // Text('Price: ${snapshot.data.data[index].price}'),
              // Text("${DateTime.fromMillisecondsSinceEpoch(snapshot.data.data[index].dTimeUtc * 1000, isUtc: true).day.toString()}" +
              //     "-${DateTime.fromMillisecondsSinceEpoch(snapshot.data.data[index].dTimeUtc * 1000, isUtc: true).month.toString()}" +
              //     "-${DateTime.fromMillisecondsSinceEpoch(snapshot.data.data[index].dTimeUtc * 1000, isUtc: true).year.toString()}"),
              // Container(
              //     color: Colors.lightGreenAccent,
              //     child: Text(
              //         'Number of Legs ${snapshot.data.data[index].route.length}')),
              //   Container(
              //     height: 300,
              //     width: 450,
              //     padding: EdgeInsets.all(8),
              //     child: Card(
              //       color: Colors.lightGreenAccent,
              //       child: ListView.builder(
              //         physics: ClampingScrollPhysics(),
              //         itemCount: snapshot.data.data[index].route.length,
              //         itemBuilder: (context, i) {
              //           return Column(
              //             children: <Widget>[
              //               Text(' ${DateTime.fromMillisecondsSinceEpoch(snapshot.data.data[index].route[i].dTimeUtc * 1000, isUtc: true).hour}:${DateTime.fromMillisecondsSinceEpoch(snapshot.data.data[index].route[i].dTimeUtc * 1000, isUtc: true).minute}  ${snapshot.data.data[index].route[i].cityFrom}\n' +
              //                   ' ${DateTime.fromMillisecondsSinceEpoch(snapshot.data.data[index].route[i].aTimeUtc * 1000, isUtc: true).hour}:${DateTime.fromMillisecondsSinceEpoch(snapshot.data.data[index].route[i].aTimeUtc * 1000, isUtc: true).minute}  ${snapshot.data.data[index].route[i].cityTo}'),
              //               Text(
              //                   'Aircraft Carrier ${snapshot.data.data[index].route[i].airline}'),
              //               Text("${DateTime.fromMillisecondsSinceEpoch(snapshot.data.data[index].dTimeUtc * 1000, isUtc: true).day.toString()}" +
              //                   "-${DateTime.fromMillisecondsSinceEpoch(snapshot.data.data[index].dTimeUtc * 1000, isUtc: true).month.toString()}" +
              //                   "-${DateTime.fromMillisecondsSinceEpoch(snapshot.data.data[index].dTimeUtc * 1000, isUtc: true).year.toString()}"),
              //               // Text('From lat --> ${snapshot.data.data[index].route[i].latFrom}' +
              //               //     ' || From lng --> ${snapshot.data.data[index].route[i].lngFrom}\n' +
              //               //     'To lat --> ${snapshot.data.data[index].route[i].latTo}' +
              //               //     ' || To lng --> ${snapshot.data.data[index].route[i].lngTo}\n'),
              //               Text(
              //                   'Flight Number ${snapshot.data.data[index].route[i].flightNo}\n'),
              //               Chip(
              //                 label: Text(
              //                     '${DateTime.fromMillisecondsSinceEpoch(snapshot.data.data[index].route[i + 1].dTimeUtc * 1000, isUtc: true).difference(DateTime.fromMillisecondsSinceEpoch(snapshot.data.data[index].route[i].aTimeUtc * 1000, isUtc: true)).inHours}H'),
              //               )
              //             ],
              //           );
              //         },
              //       ),
              //     ),
              //   ),
            ],
          ),
        ),
      ),
    ),
  );
}
