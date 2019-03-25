import 'package:flutter/material.dart';
import 'package:flyx/TicketDisplayer/ticket.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:url_launcher/url_launcher.dart';

class TicketListViewBuilder extends StatelessWidget {
  //final Ticket ticket;
  const TicketListViewBuilder({
    Key key,
    @required this.data,
    this.search_par,
    this.data_airlines,
    this.data_duration,
    this.data_route,
  }) : super(key: key);

  final List data;
  final List search_par;
  final List data_airlines;
  final List data_duration;
  final List data_route;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber, //Color.fromARGB(255, 251, 108, 112),
      child: OrientationBuilder(
        builder: (context, orientation) {
          return new ListView.builder(
            itemCount: data == null ? 0 : data.length,
            /*separatorBuilder: (context, i) => Divider(
                  color: Colors.red,
            ),*/
            itemBuilder: (BuildContext context, i) {
              return Container(
                height: orientation == Orientation.landscape
                    ? MediaQuery.of(context).size.height
                    : MediaQuery.of(context).size.height * .35,
                padding: EdgeInsets.all(8),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child: Text(
                                    "'From': ${data[i]['flyFrom'].toString()}" +
                                        "\n'To': ${data[i]['flyTo'].toString()}" +
                                        "\n'Dollars': ${data[i]['price'].toString()}"),
                              ),
                              Container(
                                child: RaisedButton(
                                  onPressed: () async {
                                    String url = data[i]['deep_link'];
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
                            ]),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
