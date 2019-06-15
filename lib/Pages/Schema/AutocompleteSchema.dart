
import 'dart:convert';

List<Suggestions> suggestionsFromJson(String str) {
  return new List<Suggestions>.from(
      json.decode(str).map((x) => Suggestions.fromMap(x)));
}

String suggestionsToJson(List<Suggestions> data) {
  return json.encode(new List<dynamic>.from(data.map((x) => x.toMap())));
}

class Suggestions {
  String text;
  String index;
  String type;
  String id;
  int score;
  Source source;

  Suggestions({
    this.text,
    this.index,
    this.type,
    this.id,
    this.score,
    this.source,
  });

  factory Suggestions.fromMap(Map<String, dynamic> json) => new Suggestions(
        text: json["text"] == null ? null : json["text"],
        index: json["_index"] == null ? null : json["_index"],
        type: json["_type"] == null ? null : json["_type"],
        id: json["_id"] == null ? null : json["_id"],
        score: json["_score"] == null ? null : json["_score"],
        source:
            json["_source"] == null ? null : Source.fromMap(json["_source"]),
      );

  Map<String, dynamic> toMap() => {
        "text": text == null ? null : text,
        "_index": index == null ? null : index,
        "_type": type == null ? null : type,
        "_id": id == null ? null : id,
        "_score": score == null ? null : score,
        "_source": source == null ? null : source.toMap(),
      };
}

class Source {
  String name;
  String city;
  String country;
  String iata;
  String icao;
  double latitude;
  double longitude;
  String geohash;
  String combined;
  String iataCompletion;

  Source({
    this.name,
    this.city,
    this.country,
    this.iata,
    this.icao,
    this.latitude,
    this.longitude,
    this.geohash,
    this.combined,
    this.iataCompletion,
  });

  factory Source.fromMap(Map<String, dynamic> json) => new Source(
        name: json["Name"] == null ? null : json["Name"],
        city: json["City"] == null ? null : json["City"],
        country: json["Country"] == null ? null : json["Country"],
        iata: json["IATA"] == null ? null : json["IATA"],
        icao: json["ICAO"] == null ? null : json["ICAO"],
        latitude: json["Latitude"] == null ? null : json["Latitude"].toDouble(),
        longitude:
            json["Longitude"] == null ? null : json["Longitude"].toDouble(),
        geohash: json["Geohash"] == null ? null : json["Geohash"],
        combined: json["Combined"] == null ? null : json["Combined"],
        iataCompletion:
            json["IATA_Completion"] == null ? null : json["IATA_Completion"],
      );

  Map<String, dynamic> toMap() => {
        "Name": name == null ? null : name,
        "City": city == null ? null : city,
        "Country": country == null ? null : country,
        "IATA": iata == null ? null : iata,
        "ICAO": icao == null ? null : icao,
        "Latitude": latitude == null ? null : latitude,
        "Longitude": longitude == null ? null : longitude,
        "Geohash": geohash == null ? null : geohash,
        "Combined": combined == null ? null : combined,
        "IATA_Completion": iataCompletion == null ? null : iataCompletion,
      };
}