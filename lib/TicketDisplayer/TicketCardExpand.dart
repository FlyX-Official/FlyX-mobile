import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flyx/TicketDisplayer/ticket.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:url_launcher/url_launcher.dart';

class TicketCardExpand extends StatefulWidget {
  const TicketCardExpand({
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
  _TicketCardExpand createState() => new _TicketCardExpand();
}

class _TicketCardExpand extends State<TicketCardExpand> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: ListView.builder(
      itemCount: widget.data == null ? 0 : widget.data.length,
      itemBuilder: (BuildContext context, i) {
        return Container(
          padding: EdgeInsets.all(8),
          child: Card(
              child: Column(
            children: <Widget>[
              new GestureDetector(
                onTap: () async {
                  // Transition to new page and display information
                  await Future.delayed(Duration(milliseconds: 200));
                  Navigator.push(
                    context,
                    SlowMaterialPageRoute(
                      builder: (context) {
                        return new PageItem(data: widget.data);
                      },
                      fullscreenDialog: true,
                    ),
                  );
                },
                child: Container(
                    color: Colors.blue,
                    padding: EdgeInsets.all(8),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    child: Text("'From': ${widget.data[i]['flyFrom'].toString()}" +
                                        "\n'To': ${widget.data[i]['flyTo'].toString()}" +
                                        "\n'Dollars': ${widget.data[i]['price'].toString()}"),
                                  ),
                                  Container(
                                    child: RaisedButton(
                                      onPressed: () async {
                                        String url =
                                            widget.data[i]['deep_link'];
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
                      ],
                    )),
              ),
            ],
          )),
        );
      },
    )));
  }
}

// Helper Classes for smooth transition
class PageItem extends StatelessWidget {
  // final int num;

  // const PageItem({Key key, this.num}) : super(key: key);
  const PageItem({
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
    return Hero(
      tag: "card$num",
      child: Scaffold(
        //backgroundColor: colorFromNum(num),
        appBar: AppBar(
          backgroundColor: Colors.white.withOpacity(0.2),
        ),
        body: new Container(
            color: Colors.blue,
            padding: EdgeInsets.all(8),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Text(
                                "'From': ${data[1]['flyFrom'].toString()}" +
                                    "\n'To': ${data[1]['flyTo'].toString()}" +
                                    "\n'Dollars': ${data[1]['price'].toString()}"),
                          ),
                          Container(
                            child: RaisedButton(
                              onPressed: () async {
                                String url = data[1]['deep_link'];
                                if (await canLaunch(url)) {
                                  await launch(url);
                                  print(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                              child: Text('buy ticket '),
                            ),
                          ),
                        ]),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}

class SlowMaterialPageRoute<T> extends MaterialPageRoute<T> {
  SlowMaterialPageRoute({
    WidgetBuilder builder,
    RouteSettings settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
            builder: builder,
            settings: settings,
            fullscreenDialog: fullscreenDialog);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 800);
}
