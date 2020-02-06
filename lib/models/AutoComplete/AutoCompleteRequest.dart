// To parse this JSON data, do
//
//     final autoCompleteRequest = autoCompleteRequestFromJson(jsonString);

import 'dart:convert';

AutoCompleteRequest autoCompleteRequestFromJson(String str) =>
    AutoCompleteRequest.fromJson(json.decode(str));

String autoCompleteRequestToJson(AutoCompleteRequest data) =>
    json.encode(data.toJson());

class AutoCompleteRequest {
  final int size;
  final Suggest suggest;

  AutoCompleteRequest({
    this.size,
    this.suggest,
  });

  AutoCompleteRequest copyWith({
    int size,
    Suggest suggest,
  }) =>
      AutoCompleteRequest(
        size: size ?? this.size,
        suggest: suggest ?? this.suggest,
      );

  factory AutoCompleteRequest.fromJson(Map<String, dynamic> json) =>
      AutoCompleteRequest(
        size: json["size"] == null ? null : json["size"],
        suggest:
            json["suggest"] == null ? null : Suggest.fromJson(json["suggest"]),
      );

  Map<String, dynamic> toJson() => {
        "size": size == null ? null : size,
        "suggest": suggest == null ? null : suggest.toJson(),
      };
}

class Suggest {
  final String text;
  final City name;
  final City city;
  final City iata;

  Suggest({
    this.text,
    this.name,
    this.city,
    this.iata,
  });

  Suggest copyWith({
    String text,
    City name,
    City city,
    City iata,
  }) =>
      Suggest(
        text: text ?? this.text,
        name: name ?? this.name,
        city: city ?? this.city,
        iata: iata ?? this.iata,
      );

  factory Suggest.fromJson(Map<String, dynamic> json) => Suggest(
        text: json["text"] == null ? null : json["text"],
        name: json["Name"] == null ? null : City.fromJson(json["Name"]),
        city: json["City"] == null ? null : City.fromJson(json["City"]),
        iata: json["Iata"] == null ? null : City.fromJson(json["Iata"]),
      );

  Map<String, dynamic> toJson() => {
        "text": text == null ? null : text,
        "Name": name == null ? null : name.toJson(),
        "City": city == null ? null : city.toJson(),
        "Iata": iata == null ? null : iata.toJson(),
      };
}

class City {
  final Completion completion;

  City({
    this.completion,
  });

  City copyWith({
    Completion completion,
  }) =>
      City(
        completion: completion ?? this.completion,
      );

  factory City.fromJson(Map<String, dynamic> json) => City(
        completion: json["completion"] == null
            ? null
            : Completion.fromJson(json["completion"]),
      );

  Map<String, dynamic> toJson() => {
        "completion": completion == null ? null : completion.toJson(),
      };
}

class Completion {
  final String field;

  Completion({
    this.field,
  });

  Completion copyWith({
    String field,
  }) =>
      Completion(
        field: field ?? this.field,
      );

  factory Completion.fromJson(Map<String, dynamic> json) => Completion(
        field: json["field"] == null ? null : json["field"],
      );

  Map<String, dynamic> toJson() => {
        "field": field == null ? null : field,
      };
}
