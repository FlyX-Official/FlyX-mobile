import 'package:flutter/material.dart';
import 'package:flyx/services/UserQuery/UserQuery.dart';
import 'package:provider/provider.dart';

class TripType extends StatefulWidget {
  TripType({Key key}) : super(key: key);

  @override
  _TripTypeState createState() => _TripTypeState();
}

class _TripTypeState extends State<TripType> {
  @override
  Widget build(BuildContext context) {
    final UserQuery _query = Provider.of<UserQuery>(context);
    return Card(
      color: Colors.blueGrey,
      shape: const StadiumBorder(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Card(
            elevation: 0,
            shape: const StadiumBorder(),
            color: _query.isOneWay ? Colors.white : Colors.blueGrey,
            child: FlatButton(
              splashColor: Colors.transparent,
              onPressed: () => Provider.of<UserQuery>(context, listen: false)
                  .setOneWay(true),
              child: Text(
                'ONE-WAY',
                style: TextStyle(
                  color: _query.isOneWay ? Colors.blueGrey : Colors.white,
                ),
              ),
            ),
          ),
          Card(
            elevation: 0,
            shape: const StadiumBorder(),
            color: !_query.isOneWay ? Colors.white : Colors.blueGrey,
            child: FlatButton(
              splashColor: Colors.transparent,
              onPressed: () => Provider.of<UserQuery>(context, listen: false)
                  .setOneWay(false),
              child: Text(
                'ROUND-TRIP',
                style: TextStyle(
                  color: !_query.isOneWay ? Colors.blueGrey : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
