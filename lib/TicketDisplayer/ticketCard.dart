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
                              height: MediaQuery.of(context).size.height * .33,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                              alignment: Alignment.center,
                              child: Text("From : ${widget.data[i]['flyFrom'].toString()} ( ${widget.data[i]['cityFrom'].toString()} )" +
                                  "\nTo : ${widget.data[i]['flyTo'].toString()} ( ${widget.data[i]['cityTo'].toString()} )" +
                                  "\nDistance : ${widget.data[i]['distance'].toString()} Miles" +
                                  "\nFly-Duration : ${widget.data[i]['fly_duration'].toString()}" +
                                  "\nreturn-Duration : ${widget.data[i]['return_duration'].toString()}" +
                                  "\nDollars : ${widget.data[i]['price'].toString()}"),
                            ),
                        body: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Divider(),
                              RaisedButton(
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
                                child: Text('buy ticket $i'),
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
