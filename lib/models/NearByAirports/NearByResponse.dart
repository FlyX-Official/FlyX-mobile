// To parse this JSON data, do
//
//     final nearbyResponse = nearbyResponseFromJson(jsonString);

import 'dart:convert';

NearbyResponse nearbyResponseFromJson(String str) =>
    NearbyResponse.fromJson(json.decode(str));

String nearbyResponseToJson(NearbyResponse data) => json.encode(data.toJson());

class NearbyResponse {
  int took;
  bool timedOut;
  Shards shards;
  Hits hits;

  NearbyResponse({
    this.took,
    this.timedOut,
    this.shards,
    this.hits,
  });

  factory NearbyResponse.fromJson(Map<String, dynamic> json) => NearbyResponse(
        took: json["took"] == null ? null : json["took"],
        timedOut: json["timed_out"] == null ? null : json["timed_out"],
        shards:
            json["_shards"] == null ? null : Shards.fromJson(json["_shards"]),
        hits: json["hits"] == null ? null : Hits.fromJson(json["hits"]),
      );

  Map<String, dynamic> toJson() => {
        "took": took == null ? null : took,
        "timed_out": timedOut == null ? null : timedOut,
        "_shards": shards == null ? null : shards.toJson(),
        "hits": hits == null ? null : hits.toJson(),
      };
}

class Hits {
  int total;
  double maxScore;
  List<Hit> hits;

  Hits({
    this.total,
    this.maxScore,
    this.hits,
  });

  factory Hits.fromJson(Map<String, dynamic> json) => Hits(
        total: json["total"] == null ? null : json["total"],
        maxScore: json["max_score"] == null ? null : json["max_score"],
        hits: json["hits"] == null
            ? null
            : List<Hit>.from(json["hits"].map((x) => Hit.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total": total == null ? null : total,
        "max_score": maxScore == null ? null : maxScore,
        "hits": hits == null
            ? null
            : List<dynamic>.from(hits.map((x) => x.toJson())),
      };
}

class Hit {
  String index;
  String type;
  String id;
  double score;
  Source source;

  Hit({
    this.index,
    this.type,
    this.id,
    this.score,
    this.source,
  });

  factory Hit.fromJson(Map<String, dynamic> json) => Hit(
        index: json["_index"] == null ? null : json["_index"],
        type: json["_type"] == null ? null : json["_type"],
        id: json["_id"] == null ? null : json["_id"],
        score: json["_score"] == null ? null : json["_score"],
        source:
            json["_source"] == null ? null : Source.fromJson(json["_source"]),
      );

  Map<String, dynamic> toJson() => {
        "_index": index == null ? null : index,
        "_type": type == null ? null : type,
        "_id": id == null ? null : id,
        "_score": score == null ? null : score,
        "_source": source == null ? null : source.toJson(),
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

  factory Source.fromJson(Map<String, dynamic> json) => Source(
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

  Map<String, dynamic> toJson() => {
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

class Shards {
  int total;
  int successful;
  int skipped;
  int failed;

  Shards({
    this.total,
    this.successful,
    this.skipped,
    this.failed,
  });

  factory Shards.fromJson(Map<String, dynamic> json) => Shards(
        total: json["total"] == null ? null : json["total"],
        successful: json["successful"] == null ? null : json["successful"],
        skipped: json["skipped"] == null ? null : json["skipped"],
        failed: json["failed"] == null ? null : json["failed"],
      );

  Map<String, dynamic> toJson() => {
        "total": total == null ? null : total,
        "successful": successful == null ? null : successful,
        "skipped": skipped == null ? null : skipped,
        "failed": failed == null ? null : failed,
      };
}
