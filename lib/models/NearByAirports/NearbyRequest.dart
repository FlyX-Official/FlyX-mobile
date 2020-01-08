// To parse this JSON data, do
//
//     final nearbyRequest = nearbyRequestFromJson(jsonString);

import 'dart:convert';

NearbyRequest nearbyRequestFromJson(String str) =>
    NearbyRequest.fromJson(json.decode(str));

String nearbyRequestToJson(NearbyRequest data) => json.encode(data.toJson());

class NearbyRequest {
  Query query;

  NearbyRequest({
    this.query,
  });

  factory NearbyRequest.fromJson(Map<String, dynamic> json) => NearbyRequest(
        query: json["query"] == null ? null : Query.fromJson(json["query"]),
      );

  Map<String, dynamic> toJson() => {
        "query": query == null ? null : query.toJson(),
      };
}

class Query {
  Bool queryBool;

  Query({
    this.queryBool,
  });

  factory Query.fromJson(Map<String, dynamic> json) => Query(
        queryBool: json["bool"] == null ? null : Bool.fromJson(json["bool"]),
      );

  Map<String, dynamic> toJson() => {
        "bool": queryBool == null ? null : queryBool.toJson(),
      };
}

class Bool {
  Must must;
  Filter filter;

  Bool({
    this.must,
    this.filter,
  });

  factory Bool.fromJson(Map<String, dynamic> json) => Bool(
        must: json["must"] == null ? null : Must.fromJson(json["must"]),
        filter: json["filter"] == null ? null : Filter.fromJson(json["filter"]),
      );

  Map<String, dynamic> toJson() => {
        "must": must == null ? null : must.toJson(),
        "filter": filter == null ? null : filter.toJson(),
      };
}

class Filter {
  GeoDistance geoDistance;

  Filter({
    this.geoDistance,
  });

  factory Filter.fromJson(Map<String, dynamic> json) => Filter(
        geoDistance: json["geo_distance"] == null
            ? null
            : GeoDistance.fromJson(json["geo_distance"]),
      );

  Map<String, dynamic> toJson() => {
        "geo_distance": geoDistance == null ? null : geoDistance.toJson(),
      };
}

class GeoDistance {
  String distance;
  String geohash;

  GeoDistance({
    this.distance,
    this.geohash,
  });

  factory GeoDistance.fromJson(Map<String, dynamic> json) => GeoDistance(
        distance: json["distance"] == null ? null : json["distance"],
        geohash: json["Geohash"] == null ? null : json["Geohash"],
      );

  Map<String, dynamic> toJson() => {
        "distance": distance == null ? null : distance,
        "Geohash": geohash == null ? null : geohash,
      };
}

class Must {
  MatchAll matchAll;

  Must({
    this.matchAll,
  });

  factory Must.fromJson(Map<String, dynamic> json) => Must(
        matchAll: json["match_all"] == null
            ? null
            : MatchAll.fromJson(json["match_all"]),
      );

  Map<String, dynamic> toJson() => {
        "match_all": matchAll == null ? null : matchAll.toJson(),
      };
}

class MatchAll {
  MatchAll();

  factory MatchAll.fromJson(Map<String, dynamic> json) => MatchAll();

  Map<String, dynamic> toJson() => {};
}
