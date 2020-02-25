import 'package:json_annotation/json_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
part 'AutoCompleteResponse.freezed.dart';
part 'AutoCompleteResponse.g.dart';

@freezed
abstract class AutoCompleteResponse with _$AutoCompleteResponse {
  const factory AutoCompleteResponse({
    @nullable @required List<Hit> hits,
  }) = _AutoCompleteResponse;

  factory AutoCompleteResponse.fromJson(Map<String, dynamic> json) =>
      _$AutoCompleteResponseFromJson(json);
}

@freezed
abstract class Hit with _$Hit {
  const factory Hit({
    @nullable @required HighlightResult highlightResult,
    @nullable @required String homepage,
    @nullable @required String iata,
    @nullable @required HitLocation location,
    @nullable @required String name,
    @nullable @required String objectId,
    @nullable @required RankingInfo rankingInfo,
    @nullable @required SnippetResult snippetResult,
    @nullable @required String wikiLink,
  }) = _Hit;

  factory Hit.fromJson(Map<String, dynamic> json) => _$HitFromJson(json);
}

@freezed
abstract class HighlightResult with _$HighlightResult {
  const factory HighlightResult({
    @nullable @required Iata iata,
    @nullable @required HighlightResultLocation location,
    @nullable @required Iata name,
  }) = _HighlightResult;

  factory HighlightResult.fromJson(Map<String, dynamic> json) =>
      _$HighlightResultFromJson(json);
}

@freezed
abstract class Iata with _$Iata {
  const factory Iata({
    @nullable @required bool fullyHighlighted,
    @nullable @required List<String> matchedWords,
    @nullable @required String matchLevel,
    @nullable @required String value,
  }) = _Iata;

  factory Iata.fromJson(Map<String, dynamic> json) => _$IataFromJson(json);
}

@freezed
abstract class HighlightResultLocation with _$HighlightResultLocation {
  const factory HighlightResultLocation({
    @nullable @required Iata city,
    @nullable @required Iata continent,
    @nullable @required Iata country,
    @nullable @required Iata subregion,
  }) = _HighlightResultLocation;

  factory HighlightResultLocation.fromJson(Map<String, dynamic> json) =>
      _$HighlightResultLocationFromJson(json);
}

@freezed
abstract class HitLocation with _$HitLocation {
  const factory HitLocation({
    @nullable @required String city,
    @nullable @required String continent,
    @nullable @required String country,
    @nullable @required String geohash,
    @nullable @required double latitude,
    @nullable @required double longitude,
    @nullable @required String subregion,
  }) = _HitLocation;

  factory HitLocation.fromJson(Map<String, dynamic> json) =>
      _$HitLocationFromJson(json);
}

@freezed
abstract class SnippetResult with _$SnippetResult {
  const factory SnippetResult({
    @nullable @required Homepage homepage,
    @nullable @required Homepage iata,
    @nullable @required SnippetResultLocation location,
    @nullable @required Homepage name,
    @nullable @required Homepage wikiLink,
  }) = _SnippetResult;

  factory SnippetResult.fromJson(Map<String, dynamic> json) =>
      _$SnippetResultFromJson(json);
}

@freezed
abstract class RankingInfo with _$RankingInfo {
  const factory RankingInfo({
    @nullable @required int nbTypos,
    @nullable @required int firstMatchedWord,
    @nullable @required int proximityDistance,
    @nullable @required int userScore,
    @nullable @required int geoDistance,
    @nullable @required int geoPrecision,
    @nullable @required int nbExactWords,
    @nullable @required int words,
    @nullable @required int filters,
  }) = _RankingInfo;

  factory RankingInfo.fromJson(Map<String, dynamic> json) =>
      _$RankingInfoFromJson(json);
}

@freezed
abstract class SnippetResultLocation with _$SnippetResultLocation {
  const factory SnippetResultLocation({
    @nullable @required Homepage city,
    @nullable @required Homepage continent,
    @nullable @required Homepage country,
    @nullable @required Homepage geohash,
    @nullable @required Homepage latitude,
    @nullable @required Homepage longitude,
    @nullable @required Homepage subregion,
  }) = _SnippetResultLocation;

  factory SnippetResultLocation.fromJson(Map<String, dynamic> json) =>
      _$SnippetResultLocationFromJson(json);
}

@freezed
abstract class Homepage with _$Homepage {
  const factory Homepage({
    @nullable @required String matchLevel,
    @nullable @required String value,
  }) = _HomePage;

  factory Homepage.fromJson(Map<String, dynamic> json) =>
      _$HomepageFromJson(json);
}
