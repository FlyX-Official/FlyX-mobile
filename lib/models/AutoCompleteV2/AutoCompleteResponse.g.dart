// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AutoCompleteResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_AutoCompleteResponse _$_$_AutoCompleteResponseFromJson(
    Map<String, dynamic> json) {
  return _$_AutoCompleteResponse(
    hits: (json['hits'] as List)
        ?.map((e) => e == null ? null : Hit.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$_$_AutoCompleteResponseToJson(
        _$_AutoCompleteResponse instance) =>
    <String, dynamic>{
      'hits': instance.hits,
    };

_$_Hit _$_$_HitFromJson(Map<String, dynamic> json) {
  return _$_Hit(
    highlightResult: json['highlightResult'] == null
        ? null
        : HighlightResult.fromJson(
            json['highlightResult'] as Map<String, dynamic>),
    homepage: json['homepage'] as String,
    iata: json['iata'] as String,
    location: json['location'] == null
        ? null
        : HitLocation.fromJson(json['location'] as Map<String, dynamic>),
    name: json['name'] as String,
    objectId: json['objectId'] as String,
    rankingInfo: json['rankingInfo'] == null
        ? null
        : RankingInfo.fromJson(json['rankingInfo'] as Map<String, dynamic>),
    snippetResult: json['snippetResult'] == null
        ? null
        : SnippetResult.fromJson(json['snippetResult'] as Map<String, dynamic>),
    wikiLink: json['wikiLink'] as String,
  );
}

Map<String, dynamic> _$_$_HitToJson(_$_Hit instance) => <String, dynamic>{
      'highlightResult': instance.highlightResult,
      'homepage': instance.homepage,
      'iata': instance.iata,
      'location': instance.location,
      'name': instance.name,
      'objectId': instance.objectId,
      'rankingInfo': instance.rankingInfo,
      'snippetResult': instance.snippetResult,
      'wikiLink': instance.wikiLink,
    };

_$_HighlightResult _$_$_HighlightResultFromJson(Map<String, dynamic> json) {
  return _$_HighlightResult(
    iata: json['iata'] == null
        ? null
        : Iata.fromJson(json['iata'] as Map<String, dynamic>),
    location: json['location'] == null
        ? null
        : HighlightResultLocation.fromJson(
            json['location'] as Map<String, dynamic>),
    name: json['name'] == null
        ? null
        : Iata.fromJson(json['name'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$_$_HighlightResultToJson(_$_HighlightResult instance) =>
    <String, dynamic>{
      'iata': instance.iata,
      'location': instance.location,
      'name': instance.name,
    };

_$_Iata _$_$_IataFromJson(Map<String, dynamic> json) {
  return _$_Iata(
    fullyHighlighted: json['fullyHighlighted'] as bool,
    matchedWords:
        (json['matchedWords'] as List)?.map((e) => e as String)?.toList(),
    matchLevel: json['matchLevel'] as String,
    value: json['value'] as String,
  );
}

Map<String, dynamic> _$_$_IataToJson(_$_Iata instance) => <String, dynamic>{
      'fullyHighlighted': instance.fullyHighlighted,
      'matchedWords': instance.matchedWords,
      'matchLevel': instance.matchLevel,
      'value': instance.value,
    };

_$_HighlightResultLocation _$_$_HighlightResultLocationFromJson(
    Map<String, dynamic> json) {
  return _$_HighlightResultLocation(
    city: json['city'] == null
        ? null
        : Iata.fromJson(json['city'] as Map<String, dynamic>),
    continent: json['continent'] == null
        ? null
        : Iata.fromJson(json['continent'] as Map<String, dynamic>),
    country: json['country'] == null
        ? null
        : Iata.fromJson(json['country'] as Map<String, dynamic>),
    subregion: json['subregion'] == null
        ? null
        : Iata.fromJson(json['subregion'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$_$_HighlightResultLocationToJson(
        _$_HighlightResultLocation instance) =>
    <String, dynamic>{
      'city': instance.city,
      'continent': instance.continent,
      'country': instance.country,
      'subregion': instance.subregion,
    };

_$_HitLocation _$_$_HitLocationFromJson(Map<String, dynamic> json) {
  return _$_HitLocation(
    city: json['city'] as String,
    continent: json['continent'] as String,
    country: json['country'] as String,
    geohash: json['geohash'] as String,
    latitude: (json['latitude'] as num)?.toDouble(),
    longitude: (json['longitude'] as num)?.toDouble(),
    subregion: json['subregion'] as String,
  );
}

Map<String, dynamic> _$_$_HitLocationToJson(_$_HitLocation instance) =>
    <String, dynamic>{
      'city': instance.city,
      'continent': instance.continent,
      'country': instance.country,
      'geohash': instance.geohash,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'subregion': instance.subregion,
    };

_$_SnippetResult _$_$_SnippetResultFromJson(Map<String, dynamic> json) {
  return _$_SnippetResult(
    homepage: json['homepage'] == null
        ? null
        : Homepage.fromJson(json['homepage'] as Map<String, dynamic>),
    iata: json['iata'] == null
        ? null
        : Homepage.fromJson(json['iata'] as Map<String, dynamic>),
    location: json['location'] == null
        ? null
        : SnippetResultLocation.fromJson(
            json['location'] as Map<String, dynamic>),
    name: json['name'] == null
        ? null
        : Homepage.fromJson(json['name'] as Map<String, dynamic>),
    wikiLink: json['wikiLink'] == null
        ? null
        : Homepage.fromJson(json['wikiLink'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$_$_SnippetResultToJson(_$_SnippetResult instance) =>
    <String, dynamic>{
      'homepage': instance.homepage,
      'iata': instance.iata,
      'location': instance.location,
      'name': instance.name,
      'wikiLink': instance.wikiLink,
    };

_$_RankingInfo _$_$_RankingInfoFromJson(Map<String, dynamic> json) {
  return _$_RankingInfo(
    nbTypos: json['nbTypos'] as int,
    firstMatchedWord: json['firstMatchedWord'] as int,
    proximityDistance: json['proximityDistance'] as int,
    userScore: json['userScore'] as int,
    geoDistance: json['geoDistance'] as int,
    geoPrecision: json['geoPrecision'] as int,
    nbExactWords: json['nbExactWords'] as int,
    words: json['words'] as int,
    filters: json['filters'] as int,
  );
}

Map<String, dynamic> _$_$_RankingInfoToJson(_$_RankingInfo instance) =>
    <String, dynamic>{
      'nbTypos': instance.nbTypos,
      'firstMatchedWord': instance.firstMatchedWord,
      'proximityDistance': instance.proximityDistance,
      'userScore': instance.userScore,
      'geoDistance': instance.geoDistance,
      'geoPrecision': instance.geoPrecision,
      'nbExactWords': instance.nbExactWords,
      'words': instance.words,
      'filters': instance.filters,
    };

_$_SnippetResultLocation _$_$_SnippetResultLocationFromJson(
    Map<String, dynamic> json) {
  return _$_SnippetResultLocation(
    city: json['city'] == null
        ? null
        : Homepage.fromJson(json['city'] as Map<String, dynamic>),
    continent: json['continent'] == null
        ? null
        : Homepage.fromJson(json['continent'] as Map<String, dynamic>),
    country: json['country'] == null
        ? null
        : Homepage.fromJson(json['country'] as Map<String, dynamic>),
    geohash: json['geohash'] == null
        ? null
        : Homepage.fromJson(json['geohash'] as Map<String, dynamic>),
    latitude: json['latitude'] == null
        ? null
        : Homepage.fromJson(json['latitude'] as Map<String, dynamic>),
    longitude: json['longitude'] == null
        ? null
        : Homepage.fromJson(json['longitude'] as Map<String, dynamic>),
    subregion: json['subregion'] == null
        ? null
        : Homepage.fromJson(json['subregion'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$_$_SnippetResultLocationToJson(
        _$_SnippetResultLocation instance) =>
    <String, dynamic>{
      'city': instance.city,
      'continent': instance.continent,
      'country': instance.country,
      'geohash': instance.geohash,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'subregion': instance.subregion,
    };

_$_HomePage _$_$_HomePageFromJson(Map<String, dynamic> json) {
  return _$_HomePage(
    matchLevel: json['matchLevel'] as String,
    value: json['value'] as String,
  );
}

Map<String, dynamic> _$_$_HomePageToJson(_$_HomePage instance) =>
    <String, dynamic>{
      'matchLevel': instance.matchLevel,
      'value': instance.value,
    };
