import 'package:flutter/material.dart';

class TicketListViewBuilder extends StatelessWidget {
  const TicketListViewBuilder({
    Key key,
    @required this.data,
  }) : super(key: key);

  final List data;

  @override
  Widget build(BuildContext context) {
    return new ListView.separated(
      itemCount: data == null ? 0 : data.length,
      separatorBuilder: (context, i) => Divider(
            color: Colors.red,
          ),
      itemBuilder: (BuildContext context, i) {
        return new ListTile(
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
        );
      },
    );
  }
}
