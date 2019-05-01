import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


Map<String, Object> postToHerokuServerData() {
 
  return {
    'oneWay': false,
    'from': "Fresno - FAT",
    'to': "New York - JFK",
    'radiusFrom': 100.0,
    'radiusTo': 100.0,
    "departureWindow": {
      'start': "2019-04-15 10:27:41.589807",
      'end': "2019-04-22 10:27:41.589810",
    }, //_originDate.toList(),
    "returnDepartureWindow": {
      'start': "2019-04-22 10:27:46.389438",
      'end': "2019-04-29 10:27:46.389472",
    }, // _destinationDate.toList(),
    //"TimeStamp": DateTime.now(),
  };
}

Future<Route> fetchPost() async {
  var testData = postToHerokuServerData();
  var testDataEnc = json.encode(testData);
  var url = "https://flyx-web-hosted.herokuapp.com/search";
  final response = await http.post(
    url,
    body: testDataEnc,
    headers: {"Content-Type": "application/json"},
  );

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    dynamic responseData = jsonDecode(response.body);
    dynamic responseRoutes = responseData['data'];
    return Route.fromJson(responseRoutes);
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

class Route {
  int aTimeUtc;
  int refreshTimestamp;
  bool bagsRecheckRequired;
  int routeReturn;
  double latTo;
  int flightNo;
  int price;
  int originalReturn;
  String operatingCarrier;
  String cityTo;
  String mapIdfrom;
  double lngFrom;

  String flyFrom;
  String id;
  int dTimeUtc;
  String equipment;
  String mapIdto;
  String combinationId;
  int dTime;
  String fareFamily;
  String flyTo;
  double latFrom;
  String airline;
  String fareClasses;
  double lngTo;
  String cityFrom;
  int lastSeen;
  int aTime;
  bool guarantee;
  String fareBasis;

  Route({
    this.aTimeUtc,
    this.refreshTimestamp,
    this.bagsRecheckRequired,
    this.routeReturn,
    this.latTo,
    this.flightNo,
    this.price,
    this.originalReturn,
    this.operatingCarrier,
    this.cityTo,
    this.mapIdfrom,
    this.lngFrom,
    this.flyFrom,
    this.id,
    this.dTimeUtc,
    this.equipment,
    this.mapIdto,
    this.combinationId,
    this.dTime,
    this.fareFamily,
    this.flyTo,
    this.latFrom,
    this.airline,
    this.fareClasses,
    this.lngTo,
    this.cityFrom,
    this.lastSeen,
    this.aTime,
    this.guarantee,
    this.fareBasis,
  });

  factory Route.fromJson(Map<String, dynamic> json) => new Route(
        aTimeUtc: json["aTimeUTC"] == null ? null : json["aTimeUTC"],
        refreshTimestamp: json["refresh_timestamp"] == null
            ? null
            : json["refresh_timestamp"],
        bagsRecheckRequired: json["bags_recheck_required"] == null
            ? null
            : json["bags_recheck_required"],
        routeReturn: json["return"] == null ? null : json["return"],
        latTo: json["latTo"] == null ? null : json["latTo"].toDouble(),
        flightNo: json["flight_no"] == null ? null : json["flight_no"],
        price: json["price"] == null ? null : json["price"],
        originalReturn:
            json["original_return"] == null ? null : json["original_return"],
        operatingCarrier: json["operating_carrier"] == null
            ? null
            : json["operating_carrier"],
        cityTo: json["cityTo"] == null ? null : json["cityTo"],
        mapIdfrom: json["mapIdfrom"] == null ? null : json["mapIdfrom"],
        lngFrom: json["lngFrom"] == null ? null : json["lngFrom"].toDouble(),
        flyFrom: json["flyFrom"] == null ? null : json["flyFrom"],
        id: json["id"] == null ? null : json["id"],
        dTimeUtc: json["dTimeUTC"] == null ? null : json["dTimeUTC"],
        equipment: json["equipment"] == null ? null : json["equipment"],
        mapIdto: json["mapIdto"] == null ? null : json["mapIdto"],
        combinationId:
            json["combination_id"] == null ? null : json["combination_id"],
        dTime: json["dTime"] == null ? null : json["dTime"],
        fareFamily: json["fare_family"] == null ? null : json["fare_family"],
        flyTo: json["flyTo"] == null ? null : json["flyTo"],
        latFrom: json["latFrom"] == null ? null : json["latFrom"].toDouble(),
        airline: json["airline"] == null ? null : json["airline"],
        fareClasses: json["fare_classes"] == null ? null : json["fare_classes"],
        lngTo: json["lngTo"] == null ? null : json["lngTo"].toDouble(),
        cityFrom: json["cityFrom"] == null ? null : json["cityFrom"],
        lastSeen: json["last_seen"] == null ? null : json["last_seen"],
        aTime: json["aTime"] == null ? null : json["aTime"],
        guarantee: json["guarantee"] == null ? null : json["guarantee"],
        fareBasis: json["fare_basis"] == null ? null : json["fare_basis"],
      );

  Map<String, dynamic> toJson() => {
        "aTimeUTC": aTimeUtc == null ? null : aTimeUtc,
        "refresh_timestamp": refreshTimestamp == null ? null : refreshTimestamp,
        "bags_recheck_required":
            bagsRecheckRequired == null ? null : bagsRecheckRequired,
        "return": routeReturn == null ? null : routeReturn,
        "latTo": latTo == null ? null : latTo,
        "flight_no": flightNo == null ? null : flightNo,
        "price": price == null ? null : price,
        "original_return": originalReturn == null ? null : originalReturn,
        "operating_carrier": operatingCarrier == null ? null : operatingCarrier,
        "cityTo": cityTo == null ? null : cityTo,
        "mapIdfrom": mapIdfrom == null ? null : mapIdfrom,
        "lngFrom": lngFrom == null ? null : lngFrom,
        "flyFrom": flyFrom == null ? null : flyFrom,
        "id": id == null ? null : id,
        "dTimeUTC": dTimeUtc == null ? null : dTimeUtc,
        "equipment": equipment == null ? null : equipment,
        "mapIdto": mapIdto == null ? null : mapIdto,
        "combination_id": combinationId == null ? null : combinationId,
        "dTime": dTime == null ? null : dTime,
        "fare_family": fareFamily == null ? null : fareFamily,
        "flyTo": flyTo == null ? null : flyTo,
        "latFrom": latFrom == null ? null : latFrom,
        "airline": airline == null ? null : airline,
        "fare_classes": fareClasses == null ? null : fareClasses,
        "lngTo": lngTo == null ? null : lngTo,
        "cityFrom": cityFrom == null ? null : cityFrom,
        "last_seen": lastSeen == null ? null : lastSeen,
        "aTime": aTime == null ? null : aTime,
        "guarantee": guarantee == null ? null : guarantee,
        "fare_basis": fareBasis == null ? null : fareBasis,
      };
}

void main() => runApp(MyApp(post: fetchPost()));

class MyApp extends StatelessWidget {
  final Future<Route> post;

  MyApp({Key key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<Route>(
            future: post,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data.airline.toString());
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // By default, show a loading spinner
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
