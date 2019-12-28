// To parse this JSON data, do
//
//     final airline = airlineFromJson(jsonString);

import 'dart:convert';

List<Airline> airlineFromJson(String str) =>
    List<Airline>.from(json.decode(str).map((x) => Airline.fromJson(x)));

String airlineToJson(List<Airline> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Airline {
  String id, name, type;
  int lcc;

  Airline({
    this.id,
    this.lcc,
    this.name,
    this.type,
  });
  factory Airline.fromJson(Map<String, dynamic> json) => Airline(
        id: json["id"] == null ? null : json["id"],
        lcc: json["lcc"] == null ? null : json["lcc"],
        name: json["name"] == null ? null : json["name"],
        type: json["type"] == null ? null : json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "lcc": lcc == null ? null : lcc,
        "name": name == null ? null : name,
        "type": type == null ? null : type,
      };
}
