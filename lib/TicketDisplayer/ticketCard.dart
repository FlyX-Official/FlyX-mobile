// import 'package:flutter/material.dart';
// import 'package:flyx/TicketDisplayer/ticket.dart';
// import 'package:auto_size_text/auto_size_text.dart';

// import 'package:url_launcher/url_launcher.dart';

// class TicketListViewBuilder extends StatelessWidget {
//   //final Ticket ticket;
//   const TicketListViewBuilder({
//     Key key,
//     @required this.data,
//     this.search_par,
//     this.data_airlines,
//     this.data_duration,
//     this.data_route,
//   }) : super(key: key);

//   final List data;
//   final List search_par;
//   final List data_airlines;
//   final List data_duration;
//   final List data_route;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.amber, //Color.fromARGB(255, 251, 108, 112),
//       child: OrientationBuilder(
//         builder: (context, orientation) {
//           return  ListView.builder(
//             itemCount: data == null ? 0 : data.length,
//             /*separatorBuilder: (context, i) => Divider(
//                   color: Colors.red,
//             ),*/
//             itemBuilder: (BuildContext context, i) {
//               return Container(
//                 height: orientation == Orientation.landscape
//                     ? MediaQuery.of(context).size.height
//                     : MediaQuery.of(context).size.height * .35,
//                 padding: EdgeInsets.all(8),
//                 child: Card(
//                   elevation: 8,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(16)),
//                   ),
//                   child: Container(
//                     padding: EdgeInsets.all(8),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: <Widget>[
//                         Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: <Widget>[
//                               Container(
//                                 child: Text(
//                                     "'From': ${data[i]['flyFrom'].toString()}" +
//                                         "\n'To': ${data[i]['flyTo'].toString()}" +
//                                         "\n'Dollars': ${data[i]['price'].toString()}"),
//                               ),
//                               Container(
//                                 child: RaisedButton(
//                                   onPressed: () async {
//                                     String url = data[i]['deep_link'];
//                                     if (await canLaunch(url)) {
//                                       await launch(url);
//                                       print(url);
//                                     } else {
//                                       throw 'Could not launch $url';
//                                     }
//                                   },
//                                   child: Text('buy ticket $i'),
//                                 ),
//                               ),
//                             ]),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
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
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
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
                              height: MediaQuery.of(context).size.height * .33,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                              alignment: Alignment.center,
                              child: Text("From : ${widget.data[i]['flyFrom'].toString()}" +
                                  "\nTo : ${widget.data[i]['flyTo'].toString()}" +
                                  "\nDistance : ${widget.data[i]['distance'].toString()}" +
                                  "\nFly-Duration : ${widget.data[i]['fly_duration'].toString()}" +
                                  "\nreturn-Duration : ${widget.data[i]['return_duration'].toString()}" +
                                  "\nDollars : ${widget.data[i]['price'].toString()}"),
                            ),
                        body: Container(
                          child: RaisedButton(
                            onPressed: () async {
                              String url = widget.data[i]['deep_link'];
                              if (await canLaunch(url)) {
                                await launch(url);
                                print(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                            child: Text('buy ticket $i'),
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
  // return Container(
  //   color: Colors.amber, //Color.fromARGB(255, 251, 108, 112),
  //   child: OrientationBuilder(
  //     builder: (context, orientation) {

  // return  ListView.builder(
  //   itemCount: widget.data == null ? 0 : widget.data.length,
  //   itemBuilder: (BuildContext context, i) {
  //     return Container(
  //       // height: orientation == Orientation.landscape
  //       //     ? MediaQuery.of(context).size.height
  //       //     : MediaQuery.of(context).size.height * .35,
  //       padding: EdgeInsets.all(8),
  //       child: Card(
  //         child: Column(
  //           children: <Widget>[
  //             Container(
  //                 color: Colors.blue,
  //                 padding: EdgeInsets.all(8),
  //                 child: Column(
  //                   children: <Widget>[
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                       crossAxisAlignment: CrossAxisAlignment.center,
  //                       children: <Widget>[
  //                         Column(
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           crossAxisAlignment: CrossAxisAlignment.center,
  //                           children: <Widget>[
  //                             Container(
  //                               child: Text("'From': ${widget.data[i]['flyFrom'].toString()}" +
  //                                   "\n'To': ${widget.data[i]['flyTo'].toString()}" +
  //                                   "\n'Dollars': ${widget.data[i]['price'].toString()}"),
  //                             ),
  //                             Container(
  //                               child: RaisedButton(
  //                                 onPressed: () async {
  //                                   String url = widget.data[i]['deep_link'];
  //                                   if (await canLaunch(url)) {
  //                                     await launch(url);
  //                                     print(url);
  //                                   } else {
  //                                     throw 'Could not launch $url';
  //                                   }
  //                                 },
  //                                 child: Text('buy ticket $i'),
  //                               ),
  //                             ),
  //                             Container(
  //                               child: IconButton(
  //                                 icon: Icon(Icons.arrow_downward,
  //                                     color: Colors.white),
  //                                 onPressed: () {
  //                                   GestureDetector(
  //                                     child: AnimatedContainer(
  //                                       duration:
  //                                           const Duration(milliseconds: 120),
  //                                       child:  Text("Bottom Screen"),
  //                                       //  here is where I need to target the Card that I clicked
  //                                       height: 100,
  //                                       //color: Colors.tealAccent,
  //                                     ),
  //                                   );
  //                                 },
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ],
  //                     ),
  //                   ],
  //                 )),

  //             /// magic box
  //           ],
  //         ),
  //       ),
  //     );
  //   },
  // );

  //     },
  //   ),
  // );
}
