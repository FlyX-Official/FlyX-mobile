import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:wefly/TicketDisplayer/ticketCard.dart';
//import 'package:wefly/TicketDisplayer/testTicket.dart';
import 'package:wefly/TicketDisplayer/ticket.dart';

class TicketView extends StatelessWidget {
  // This widget is the root of your application.
  static String tag = 'card-page';
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new TicketViewPage(),
    );
  }
}

class TicketViewPage extends StatefulWidget {
  @override
  _TicketViewPageState createState() => new _TicketViewPageState();
}

class _TicketViewPageState extends State<TicketViewPage> {
  String url =
      'https://my-json-server.typicode.com/We-Fly/flightsniffer-mobile/db';
  List data;
  Future<String> makeRequest() async {
    var response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});

    setState(() {
      var extractdata = json.decode(response.body);
      data = extractdata["tickets"];
      
    });
  
  }

  @override
  void initState() {
    this.makeRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: TicketListViewBuilder(data: data));
  }
}
