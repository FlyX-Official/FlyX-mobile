import 'package:flutter/material.dart';
import 'package:flyx/TicketDisplayer/ticket.dart';

class TicketListViewBuilder extends StatelessWidget {
  //final Ticket ticket;
  const TicketListViewBuilder({
    Key key,
    @required this.data,
  }) : super(key: key);

  final List data;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 251, 108, 112),
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
                        SizedBox(
                          //alignment: Alignment.center,

                          child: Text(data[i]["from"] +
                              "\n| |\n| |\nV\n" +
                              data[i]["to"]),
                        ),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                " Price: " +
                                    data[i]["pennyPrice"].toString() +
                                    "\n Duration: " +
                                    data[i]["duration"].toString(),
                              ),
                              Text(" \nDEPARTURE: " +
                                  data[i]["departure"] +
                                  "\nARRIVAL: " +
                                  data[i]["arrival"] +
                                  "\nColor: " +
                                  data[i]['color'] +
                                  "\nSourceLocation: " +
                                  data[i]["sourceLocation"] +
                                  "\nDestinationLocation: " +
                                  data[i]["destLocation"]),
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

/* new ListTile(
          leading:
              new Text(data[i]["from"] + "\n| |\n| |\nV\n" + data[i]["to"]),
          title: new Text(
            " Price: " +
                data[i]["pennyPrice"].toString() +
                " Duration: " +
                data[i]["duration"].toString(),
          ),
          subtitle: new Text(" \nDEPARTURE: " +
              data[i]["departure"] +
              "\nARRIVAL: " +
              data[i]["arrival"] +
              "\nColor: " +
              data[i]['color'] +
              "\nSourceLocation: " +
              data[i]["sourceLocation"] +
              "\nDestinationLocation: " +
              data[i]["destLocation"]),
        );*/
