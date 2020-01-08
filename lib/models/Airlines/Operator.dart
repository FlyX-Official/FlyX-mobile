// To parse this JSON data, do
//
//     final operatorData = operatorDataFromJson(jsonString);

import 'dart:convert';

OperatorData operatorDataFromJson(String str) =>
    OperatorData.fromJson(json.decode(str));

String operatorDataToJson(OperatorData data) => json.encode(data.toJson());

class OperatorData {
  List<Operator> airlineOperator;
  List<Operator> busOperator;
  List<Operator> trainOperator;

  OperatorData({
    this.airlineOperator,
    this.busOperator,
    this.trainOperator,
  });

  factory OperatorData.fromJson(Map<String, dynamic> json) => OperatorData(
        airlineOperator: json["airlineOperator"] == null
            ? null
            : List<Operator>.from(
                json["airlineOperator"].map((x) => Operator.fromJson(x))),
        busOperator: json["busOperator"] == null
            ? null
            : List<Operator>.from(
                json["busOperator"].map((x) => Operator.fromJson(x))),
        trainOperator: json["trainOperator"] == null
            ? null
            : List<Operator>.from(
                json["trainOperator"].map((x) => Operator.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "airlineOperator": airlineOperator == null
            ? null
            : List<dynamic>.from(airlineOperator.map((x) => x.toJson())),
        "busOperator": busOperator == null
            ? null
            : List<dynamic>.from(busOperator.map((x) => x.toJson())),
        "trainOperator": trainOperator == null
            ? null
            : List<dynamic>.from(trainOperator.map((x) => x.toJson())),
      };
}

class Operator {
  String id;
  int lcc;
  String name;
  String logo;

  Operator({
    this.id,
    this.lcc,
    this.name,
    this.logo,
  });

  factory Operator.fromJson(Map<String, dynamic> json) => Operator(
        id: json["id"] == null ? null : json["id"],
        lcc: json["lcc"] == null ? null : json["lcc"],
        name: json["name"] == null ? null : json["name"],
        logo: json["logo"] == null ? null : json["logo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "lcc": lcc == null ? null : lcc,
        "name": name == null ? null : name,
        "logo": logo == null ? null : logo,
      };
}
