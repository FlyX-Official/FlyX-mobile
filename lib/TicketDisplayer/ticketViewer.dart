import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:flyx/TicketDisplayer/ticketCard.dart';
//import 'package:flyx/TicketDisplayer/testTicket.dart';
import 'package:flyx/TicketDisplayer/ticket.dart';

class TicketView extends StatelessWidget {
  // This widget is the root of your application.
  static String tag = 'card-page';
  @override
  Widget build(BuildContext context) {
    return TicketViewPage();
  }
}

class TicketViewPage extends StatefulWidget {
  @override
  _TicketViewPageState createState() => new _TicketViewPageState();
}

class _TicketViewPageState extends State<TicketViewPage>
    with AutomaticKeepAliveClientMixin<TicketViewPage> {
  String url = 'https://olivine-pamphlet.glitch.me/search';
  //'https://my-json-server.typicode.com/We-Fly/flightsniffer-mobile/db';
  List data;

  Future<String> makeRequest() async {
    var response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});

    var responseData = json.decode(response.body);
    print('${responseData['tickets']['data'][0]['deep_link'].toString()}') ;
    //search_par = responseData["tickets"]["search_params"];
    data = responseData["tickets"]["data"];
    setState(() {
      var responseData = json.decode(response.body);
      //search_par = responseData["tickets"]["search_params"];
      data = responseData["tickets"]["data"];
    });
  }

  @override
  void initState() {
    super.initState();
    this.makeRequest();
    setState(() {
      
      this.makeRequest();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: TicketListViewBuilder(
      data: data,
    ));
  }

  @override
  bool get wantKeepAlive => true;
}
