// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters

part of 'AutoCompleteResponse.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

AutoCompleteResponse _$AutoCompleteResponseFromJson(Map<String, dynamic> json) {
  return _AutoCompleteResponse.fromJson(json);
}

mixin _$AutoCompleteResponse {
  @nullable
  List<Hit> get hits;

  AutoCompleteResponse copyWith({@nullable List<Hit> hits});

  Map<String, dynamic> toJson();
}

@JsonSerializable()
class _$_AutoCompleteResponse
    with DiagnosticableTreeMixin
    implements _AutoCompleteResponse {
  const _$_AutoCompleteResponse({@required @nullable this.hits});

  factory _$_AutoCompleteResponse.fromJson(Map<String, dynamic> json) =>
      _$_$_AutoCompleteResponseFromJson(json);

  @override
  @nullable
  final List<Hit> hits;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AutoCompleteResponse(hits: $hits)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AutoCompleteResponse'))
      ..add(DiagnosticsProperty('hits', hits));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _AutoCompleteResponse &&
            (identical(other.hits, hits) ||
                const DeepCollectionEquality().equals(other.hits, hits)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(hits);

  @override
  _$_AutoCompleteResponse copyWith({
    Object hits = freezed,
  }) {
    return _$_AutoCompleteResponse(
      hits: hits == freezed ? this.hits : hits as List<Hit>,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return _$_$_AutoCompleteResponseToJson(this);
  }
}

abstract class _AutoCompleteResponse implements AutoCompleteResponse {
  const factory _AutoCompleteResponse({@required @nullable List<Hit> hits}) =
      _$_AutoCompleteResponse;

  factory _AutoCompleteResponse.fromJson(Map<String, dynamic> json) =
      _$_AutoCompleteResponse.fromJson;

  @override
  @nullable
  List<Hit> get hits;

  @override
  _AutoCompleteResponse copyWith({@nullable List<Hit> hits});
}

Hit _$HitFromJson(Map<String, dynamic> json) {
  return _Hit.fromJson(json);
}

mixin _$Hit {
  @nullable
  HighlightResult get highlightResult;
  @nullable
  String get homepage;
  @nullable
  String get iata;
  @nullable
  HitLocation get location;
  @nullable
  String get name;
  @nullable
  String get objectId;
  @nullable
  RankingInfo get rankingInfo;
  @nullable
  SnippetResult get snippetResult;
  @nullable
  String get wikiLink;

  Hit copyWith(
      {@nullable HighlightResult highlightResult,
      @nullable String homepage,
      @nullable String iata,
      @nullable HitLocation location,
      @nullable String name,
      @nullable String objectId,
      @nullable RankingInfo rankingInfo,
      @nullable SnippetResult snippetResult,
      @nullable String wikiLink});

  Map<String, dynamic> toJson();
}

@JsonSerializable()
class _$_Hit with DiagnosticableTreeMixin implements _Hit {
  const _$_Hit(
      {@required @nullable this.highlightResult,
      @required @nullable this.homepage,
      @required @nullable this.iata,
      @required @nullable this.location,
      @required @nullable this.name,
      @required @nullable this.objectId,
      @required @nullable this.rankingInfo,
      @required @nullable this.snippetResult,
      @required @nullable this.wikiLink});

  factory _$_Hit.fromJson(Map<String, dynamic> json) => _$_$_HitFromJson(json);

  @override
  @nullable
  final HighlightResult highlightResult;
  @override
  @nullable
  final String homepage;
  @override
  @nullable
  final String iata;
  @override
  @nullable
  final HitLocation location;
  @override
  @nullable
  final String name;
  @override
  @nullable
  final String objectId;
  @override
  @nullable
  final RankingInfo rankingInfo;
  @override
  @nullable
  final SnippetResult snippetResult;
  @override
  @nullable
  final String wikiLink;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Hit(highlightResult: $highlightResult, homepage: $homepage, iata: $iata, location: $location, name: $name, objectId: $objectId, rankingInfo: $rankingInfo, snippetResult: $snippetResult, wikiLink: $wikiLink)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Hit'))
      ..add(DiagnosticsProperty('highlightResult', highlightResult))
      ..add(DiagnosticsProperty('homepage', homepage))
      ..add(DiagnosticsProperty('iata', iata))
      ..add(DiagnosticsProperty('location', location))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('objectId', objectId))
      ..add(DiagnosticsProperty('rankingInfo', rankingInfo))
      ..add(DiagnosticsProperty('snippetResult', snippetResult))
      ..add(DiagnosticsProperty('wikiLink', wikiLink));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Hit &&
            (identical(other.highlightResult, highlightResult) ||
                const DeepCollectionEquality()
                    .equals(other.highlightResult, highlightResult)) &&
            (identical(other.homepage, homepage) ||
                const DeepCollectionEquality()
                    .equals(other.homepage, homepage)) &&
            (identical(other.iata, iata) ||
                const DeepCollectionEquality().equals(other.iata, iata)) &&
            (identical(other.location, location) ||
                const DeepCollectionEquality()
                    .equals(other.location, location)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.objectId, objectId) ||
                const DeepCollectionEquality()
                    .equals(other.objectId, objectId)) &&
            (identical(other.rankingInfo, rankingInfo) ||
                const DeepCollectionEquality()
                    .equals(other.rankingInfo, rankingInfo)) &&
            (identical(other.snippetResult, snippetResult) ||
                const DeepCollectionEquality()
                    .equals(other.snippetResult, snippetResult)) &&
            (identical(other.wikiLink, wikiLink) ||
                const DeepCollectionEquality()
                    .equals(other.wikiLink, wikiLink)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(highlightResult) ^
      const DeepCollectionEquality().hash(homepage) ^
      const DeepCollectionEquality().hash(iata) ^
      const DeepCollectionEquality().hash(location) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(objectId) ^
      const DeepCollectionEquality().hash(rankingInfo) ^
      const DeepCollectionEquality().hash(snippetResult) ^
      const DeepCollectionEquality().hash(wikiLink);

  @override
  _$_Hit copyWith({
    Object highlightResult = freezed,
    Object homepage = freezed,
    Object iata = freezed,
    Object location = freezed,
    Object name = freezed,
    Object objectId = freezed,
    Object rankingInfo = freezed,
    Object snippetResult = freezed,
    Object wikiLink = freezed,
  }) {
    return _$_Hit(
      highlightResult: highlightResult == freezed
          ? this.highlightResult
          : highlightResult as HighlightResult,
      homepage: homepage == freezed ? this.homepage : homepage as String,
      iata: iata == freezed ? this.iata : iata as String,
      location: location == freezed ? this.location : location as HitLocation,
      name: name == freezed ? this.name : name as String,
      objectId: objectId == freezed ? this.objectId : objectId as String,
      rankingInfo: rankingInfo == freezed
          ? this.rankingInfo
          : rankingInfo as RankingInfo,
      snippetResult: snippetResult == freezed
          ? this.snippetResult
          : snippetResult as SnippetResult,
      wikiLink: wikiLink == freezed ? this.wikiLink : wikiLink as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return _$_$_HitToJson(this);
  }
}

abstract class _Hit implements Hit {
  const factory _Hit(
      {@required @nullable HighlightResult highlightResult,
      @required @nullable String homepage,
      @required @nullable String iata,
      @required @nullable HitLocation location,
      @required @nullable String name,
      @required @nullable String objectId,
      @required @nullable RankingInfo rankingInfo,
      @required @nullable SnippetResult snippetResult,
      @required @nullable String wikiLink}) = _$_Hit;

  factory _Hit.fromJson(Map<String, dynamic> json) = _$_Hit.fromJson;

  @override
  @nullable
  HighlightResult get highlightResult;
  @override
  @nullable
  String get homepage;
  @override
  @nullable
  String get iata;
  @override
  @nullable
  HitLocation get location;
  @override
  @nullable
  String get name;
  @override
  @nullable
  String get objectId;
  @override
  @nullable
  RankingInfo get rankingInfo;
  @override
  @nullable
  SnippetResult get snippetResult;
  @override
  @nullable
  String get wikiLink;

  @override
  _Hit copyWith(
      {@nullable HighlightResult highlightResult,
      @nullable String homepage,
      @nullable String iata,
      @nullable HitLocation location,
      @nullable String name,
      @nullable String objectId,
      @nullable RankingInfo rankingInfo,
      @nullable SnippetResult snippetResult,
      @nullable String wikiLink});
}

HighlightResult _$HighlightResultFromJson(Map<String, dynamic> json) {
  return _HighlightResult.fromJson(json);
}

mixin _$HighlightResult {
  @nullable
  Iata get iata;
  @nullable
  HighlightResultLocation get location;
  @nullable
  Iata get name;

  HighlightResult copyWith(
      {@nullable Iata iata,
      @nullable HighlightResultLocation location,
      @nullable Iata name});

  Map<String, dynamic> toJson();
}

@JsonSerializable()
class _$_HighlightResult
    with DiagnosticableTreeMixin
    implements _HighlightResult {
  const _$_HighlightResult(
      {@required @nullable this.iata,
      @required @nullable this.location,
      @required @nullable this.name});

  factory _$_HighlightResult.fromJson(Map<String, dynamic> json) =>
      _$_$_HighlightResultFromJson(json);

  @override
  @nullable
  final Iata iata;
  @override
  @nullable
  final HighlightResultLocation location;
  @override
  @nullable
  final Iata name;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'HighlightResult(iata: $iata, location: $location, name: $name)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'HighlightResult'))
      ..add(DiagnosticsProperty('iata', iata))
      ..add(DiagnosticsProperty('location', location))
      ..add(DiagnosticsProperty('name', name));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _HighlightResult &&
            (identical(other.iata, iata) ||
                const DeepCollectionEquality().equals(other.iata, iata)) &&
            (identical(other.location, location) ||
                const DeepCollectionEquality()
                    .equals(other.location, location)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(iata) ^
      const DeepCollectionEquality().hash(location) ^
      const DeepCollectionEquality().hash(name);

  @override
  _$_HighlightResult copyWith({
    Object iata = freezed,
    Object location = freezed,
    Object name = freezed,
  }) {
    return _$_HighlightResult(
      iata: iata == freezed ? this.iata : iata as Iata,
      location: location == freezed
          ? this.location
          : location as HighlightResultLocation,
      name: name == freezed ? this.name : name as Iata,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return _$_$_HighlightResultToJson(this);
  }
}

abstract class _HighlightResult implements HighlightResult {
  const factory _HighlightResult(
      {@required @nullable Iata iata,
      @required @nullable HighlightResultLocation location,
      @required @nullable Iata name}) = _$_HighlightResult;

  factory _HighlightResult.fromJson(Map<String, dynamic> json) =
      _$_HighlightResult.fromJson;

  @override
  @nullable
  Iata get iata;
  @override
  @nullable
  HighlightResultLocation get location;
  @override
  @nullable
  Iata get name;

  @override
  _HighlightResult copyWith(
      {@nullable Iata iata,
      @nullable HighlightResultLocation location,
      @nullable Iata name});
}

Iata _$IataFromJson(Map<String, dynamic> json) {
  return _Iata.fromJson(json);
}

mixin _$Iata {
  @nullable
  bool get fullyHighlighted;
  @nullable
  List<String> get matchedWords;
  @nullable
  String get matchLevel;
  @nullable
  String get value;

  Iata copyWith(
      {@nullable bool fullyHighlighted,
      @nullable List<String> matchedWords,
      @nullable String matchLevel,
      @nullable String value});

  Map<String, dynamic> toJson();
}

@JsonSerializable()
class _$_Iata with DiagnosticableTreeMixin implements _Iata {
  const _$_Iata(
      {@required @nullable this.fullyHighlighted,
      @required @nullable this.matchedWords,
      @required @nullable this.matchLevel,
      @required @nullable this.value});

  factory _$_Iata.fromJson(Map<String, dynamic> json) =>
      _$_$_IataFromJson(json);

  @override
  @nullable
  final bool fullyHighlighted;
  @override
  @nullable
  final List<String> matchedWords;
  @override
  @nullable
  final String matchLevel;
  @override
  @nullable
  final String value;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Iata(fullyHighlighted: $fullyHighlighted, matchedWords: $matchedWords, matchLevel: $matchLevel, value: $value)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Iata'))
      ..add(DiagnosticsProperty('fullyHighlighted', fullyHighlighted))
      ..add(DiagnosticsProperty('matchedWords', matchedWords))
      ..add(DiagnosticsProperty('matchLevel', matchLevel))
      ..add(DiagnosticsProperty('value', value));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Iata &&
            (identical(other.fullyHighlighted, fullyHighlighted) ||
                const DeepCollectionEquality()
                    .equals(other.fullyHighlighted, fullyHighlighted)) &&
            (identical(other.matchedWords, matchedWords) ||
                const DeepCollectionEquality()
                    .equals(other.matchedWords, matchedWords)) &&
            (identical(other.matchLevel, matchLevel) ||
                const DeepCollectionEquality()
                    .equals(other.matchLevel, matchLevel)) &&
            (identical(other.value, value) ||
                const DeepCollectionEquality().equals(other.value, value)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(fullyHighlighted) ^
      const DeepCollectionEquality().hash(matchedWords) ^
      const DeepCollectionEquality().hash(matchLevel) ^
      const DeepCollectionEquality().hash(value);

  @override
  _$_Iata copyWith({
    Object fullyHighlighted = freezed,
    Object matchedWords = freezed,
    Object matchLevel = freezed,
    Object value = freezed,
  }) {
    return _$_Iata(
      fullyHighlighted: fullyHighlighted == freezed
          ? this.fullyHighlighted
          : fullyHighlighted as bool,
      matchedWords: matchedWords == freezed
          ? this.matchedWords
          : matchedWords as List<String>,
      matchLevel:
          matchLevel == freezed ? this.matchLevel : matchLevel as String,
      value: value == freezed ? this.value : value as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return _$_$_IataToJson(this);
  }
}

abstract class _Iata implements Iata {
  const factory _Iata(
      {@required @nullable bool fullyHighlighted,
      @required @nullable List<String> matchedWords,
      @required @nullable String matchLevel,
      @required @nullable String value}) = _$_Iata;

  factory _Iata.fromJson(Map<String, dynamic> json) = _$_Iata.fromJson;

  @override
  @nullable
  bool get fullyHighlighted;
  @override
  @nullable
  List<String> get matchedWords;
  @override
  @nullable
  String get matchLevel;
  @override
  @nullable
  String get value;

  @override
  _Iata copyWith(
      {@nullable bool fullyHighlighted,
      @nullable List<String> matchedWords,
      @nullable String matchLevel,
      @nullable String value});
}

HighlightResultLocation _$HighlightResultLocationFromJson(
    Map<String, dynamic> json) {
  return _HighlightResultLocation.fromJson(json);
}

mixin _$HighlightResultLocation {
  @nullable
  Iata get city;
  @nullable
  Iata get continent;
  @nullable
  Iata get country;
  @nullable
  Iata get subregion;

  HighlightResultLocation copyWith(
      {@nullable Iata city,
      @nullable Iata continent,
      @nullable Iata country,
      @nullable Iata subregion});

  Map<String, dynamic> toJson();
}

@JsonSerializable()
class _$_HighlightResultLocation
    with DiagnosticableTreeMixin
    implements _HighlightResultLocation {
  const _$_HighlightResultLocation(
      {@required @nullable this.city,
      @required @nullable this.continent,
      @required @nullable this.country,
      @required @nullable this.subregion});

  factory _$_HighlightResultLocation.fromJson(Map<String, dynamic> json) =>
      _$_$_HighlightResultLocationFromJson(json);

  @override
  @nullable
  final Iata city;
  @override
  @nullable
  final Iata continent;
  @override
  @nullable
  final Iata country;
  @override
  @nullable
  final Iata subregion;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'HighlightResultLocation(city: $city, continent: $continent, country: $country, subregion: $subregion)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'HighlightResultLocation'))
      ..add(DiagnosticsProperty('city', city))
      ..add(DiagnosticsProperty('continent', continent))
      ..add(DiagnosticsProperty('country', country))
      ..add(DiagnosticsProperty('subregion', subregion));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _HighlightResultLocation &&
            (identical(other.city, city) ||
                const DeepCollectionEquality().equals(other.city, city)) &&
            (identical(other.continent, continent) ||
                const DeepCollectionEquality()
                    .equals(other.continent, continent)) &&
            (identical(other.country, country) ||
                const DeepCollectionEquality()
                    .equals(other.country, country)) &&
            (identical(other.subregion, subregion) ||
                const DeepCollectionEquality()
                    .equals(other.subregion, subregion)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(city) ^
      const DeepCollectionEquality().hash(continent) ^
      const DeepCollectionEquality().hash(country) ^
      const DeepCollectionEquality().hash(subregion);

  @override
  _$_HighlightResultLocation copyWith({
    Object city = freezed,
    Object continent = freezed,
    Object country = freezed,
    Object subregion = freezed,
  }) {
    return _$_HighlightResultLocation(
      city: city == freezed ? this.city : city as Iata,
      continent: continent == freezed ? this.continent : continent as Iata,
      country: country == freezed ? this.country : country as Iata,
      subregion: subregion == freezed ? this.subregion : subregion as Iata,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return _$_$_HighlightResultLocationToJson(this);
  }
}

abstract class _HighlightResultLocation implements HighlightResultLocation {
  const factory _HighlightResultLocation(
      {@required @nullable Iata city,
      @required @nullable Iata continent,
      @required @nullable Iata country,
      @required @nullable Iata subregion}) = _$_HighlightResultLocation;

  factory _HighlightResultLocation.fromJson(Map<String, dynamic> json) =
      _$_HighlightResultLocation.fromJson;

  @override
  @nullable
  Iata get city;
  @override
  @nullable
  Iata get continent;
  @override
  @nullable
  Iata get country;
  @override
  @nullable
  Iata get subregion;

  @override
  _HighlightResultLocation copyWith(
      {@nullable Iata city,
      @nullable Iata continent,
      @nullable Iata country,
      @nullable Iata subregion});
}

HitLocation _$HitLocationFromJson(Map<String, dynamic> json) {
  return _HitLocation.fromJson(json);
}

mixin _$HitLocation {
  @nullable
  String get city;
  @nullable
  String get continent;
  @nullable
  String get country;
  @nullable
  String get geohash;
  @nullable
  double get latitude;
  @nullable
  double get longitude;
  @nullable
  String get subregion;

  HitLocation copyWith(
      {@nullable String city,
      @nullable String continent,
      @nullable String country,
      @nullable String geohash,
      @nullable double latitude,
      @nullable double longitude,
      @nullable String subregion});

  Map<String, dynamic> toJson();
}

@JsonSerializable()
class _$_HitLocation with DiagnosticableTreeMixin implements _HitLocation {
  const _$_HitLocation(
      {@required @nullable this.city,
      @required @nullable this.continent,
      @required @nullable this.country,
      @required @nullable this.geohash,
      @required @nullable this.latitude,
      @required @nullable this.longitude,
      @required @nullable this.subregion});

  factory _$_HitLocation.fromJson(Map<String, dynamic> json) =>
      _$_$_HitLocationFromJson(json);

  @override
  @nullable
  final String city;
  @override
  @nullable
  final String continent;
  @override
  @nullable
  final String country;
  @override
  @nullable
  final String geohash;
  @override
  @nullable
  final double latitude;
  @override
  @nullable
  final double longitude;
  @override
  @nullable
  final String subregion;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'HitLocation(city: $city, continent: $continent, country: $country, geohash: $geohash, latitude: $latitude, longitude: $longitude, subregion: $subregion)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'HitLocation'))
      ..add(DiagnosticsProperty('city', city))
      ..add(DiagnosticsProperty('continent', continent))
      ..add(DiagnosticsProperty('country', country))
      ..add(DiagnosticsProperty('geohash', geohash))
      ..add(DiagnosticsProperty('latitude', latitude))
      ..add(DiagnosticsProperty('longitude', longitude))
      ..add(DiagnosticsProperty('subregion', subregion));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _HitLocation &&
            (identical(other.city, city) ||
                const DeepCollectionEquality().equals(other.city, city)) &&
            (identical(other.continent, continent) ||
                const DeepCollectionEquality()
                    .equals(other.continent, continent)) &&
            (identical(other.country, country) ||
                const DeepCollectionEquality()
                    .equals(other.country, country)) &&
            (identical(other.geohash, geohash) ||
                const DeepCollectionEquality()
                    .equals(other.geohash, geohash)) &&
            (identical(other.latitude, latitude) ||
                const DeepCollectionEquality()
                    .equals(other.latitude, latitude)) &&
            (identical(other.longitude, longitude) ||
                const DeepCollectionEquality()
                    .equals(other.longitude, longitude)) &&
            (identical(other.subregion, subregion) ||
                const DeepCollectionEquality()
                    .equals(other.subregion, subregion)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(city) ^
      const DeepCollectionEquality().hash(continent) ^
      const DeepCollectionEquality().hash(country) ^
      const DeepCollectionEquality().hash(geohash) ^
      const DeepCollectionEquality().hash(latitude) ^
      const DeepCollectionEquality().hash(longitude) ^
      const DeepCollectionEquality().hash(subregion);

  @override
  _$_HitLocation copyWith({
    Object city = freezed,
    Object continent = freezed,
    Object country = freezed,
    Object geohash = freezed,
    Object latitude = freezed,
    Object longitude = freezed,
    Object subregion = freezed,
  }) {
    return _$_HitLocation(
      city: city == freezed ? this.city : city as String,
      continent: continent == freezed ? this.continent : continent as String,
      country: country == freezed ? this.country : country as String,
      geohash: geohash == freezed ? this.geohash : geohash as String,
      latitude: latitude == freezed ? this.latitude : latitude as double,
      longitude: longitude == freezed ? this.longitude : longitude as double,
      subregion: subregion == freezed ? this.subregion : subregion as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return _$_$_HitLocationToJson(this);
  }
}

abstract class _HitLocation implements HitLocation {
  const factory _HitLocation(
      {@required @nullable String city,
      @required @nullable String continent,
      @required @nullable String country,
      @required @nullable String geohash,
      @required @nullable double latitude,
      @required @nullable double longitude,
      @required @nullable String subregion}) = _$_HitLocation;

  factory _HitLocation.fromJson(Map<String, dynamic> json) =
      _$_HitLocation.fromJson;

  @override
  @nullable
  String get city;
  @override
  @nullable
  String get continent;
  @override
  @nullable
  String get country;
  @override
  @nullable
  String get geohash;
  @override
  @nullable
  double get latitude;
  @override
  @nullable
  double get longitude;
  @override
  @nullable
  String get subregion;

  @override
  _HitLocation copyWith(
      {@nullable String city,
      @nullable String continent,
      @nullable String country,
      @nullable String geohash,
      @nullable double latitude,
      @nullable double longitude,
      @nullable String subregion});
}

SnippetResult _$SnippetResultFromJson(Map<String, dynamic> json) {
  return _SnippetResult.fromJson(json);
}

mixin _$SnippetResult {
  @nullable
  Homepage get homepage;
  @nullable
  Homepage get iata;
  @nullable
  SnippetResultLocation get location;
  @nullable
  Homepage get name;
  @nullable
  Homepage get wikiLink;

  SnippetResult copyWith(
      {@nullable Homepage homepage,
      @nullable Homepage iata,
      @nullable SnippetResultLocation location,
      @nullable Homepage name,
      @nullable Homepage wikiLink});

  Map<String, dynamic> toJson();
}

@JsonSerializable()
class _$_SnippetResult with DiagnosticableTreeMixin implements _SnippetResult {
  const _$_SnippetResult(
      {@required @nullable this.homepage,
      @required @nullable this.iata,
      @required @nullable this.location,
      @required @nullable this.name,
      @required @nullable this.wikiLink});

  factory _$_SnippetResult.fromJson(Map<String, dynamic> json) =>
      _$_$_SnippetResultFromJson(json);

  @override
  @nullable
  final Homepage homepage;
  @override
  @nullable
  final Homepage iata;
  @override
  @nullable
  final SnippetResultLocation location;
  @override
  @nullable
  final Homepage name;
  @override
  @nullable
  final Homepage wikiLink;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SnippetResult(homepage: $homepage, iata: $iata, location: $location, name: $name, wikiLink: $wikiLink)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SnippetResult'))
      ..add(DiagnosticsProperty('homepage', homepage))
      ..add(DiagnosticsProperty('iata', iata))
      ..add(DiagnosticsProperty('location', location))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('wikiLink', wikiLink));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _SnippetResult &&
            (identical(other.homepage, homepage) ||
                const DeepCollectionEquality()
                    .equals(other.homepage, homepage)) &&
            (identical(other.iata, iata) ||
                const DeepCollectionEquality().equals(other.iata, iata)) &&
            (identical(other.location, location) ||
                const DeepCollectionEquality()
                    .equals(other.location, location)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.wikiLink, wikiLink) ||
                const DeepCollectionEquality()
                    .equals(other.wikiLink, wikiLink)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(homepage) ^
      const DeepCollectionEquality().hash(iata) ^
      const DeepCollectionEquality().hash(location) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(wikiLink);

  @override
  _$_SnippetResult copyWith({
    Object homepage = freezed,
    Object iata = freezed,
    Object location = freezed,
    Object name = freezed,
    Object wikiLink = freezed,
  }) {
    return _$_SnippetResult(
      homepage: homepage == freezed ? this.homepage : homepage as Homepage,
      iata: iata == freezed ? this.iata : iata as Homepage,
      location: location == freezed
          ? this.location
          : location as SnippetResultLocation,
      name: name == freezed ? this.name : name as Homepage,
      wikiLink: wikiLink == freezed ? this.wikiLink : wikiLink as Homepage,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return _$_$_SnippetResultToJson(this);
  }
}

abstract class _SnippetResult implements SnippetResult {
  const factory _SnippetResult(
      {@required @nullable Homepage homepage,
      @required @nullable Homepage iata,
      @required @nullable SnippetResultLocation location,
      @required @nullable Homepage name,
      @required @nullable Homepage wikiLink}) = _$_SnippetResult;

  factory _SnippetResult.fromJson(Map<String, dynamic> json) =
      _$_SnippetResult.fromJson;

  @override
  @nullable
  Homepage get homepage;
  @override
  @nullable
  Homepage get iata;
  @override
  @nullable
  SnippetResultLocation get location;
  @override
  @nullable
  Homepage get name;
  @override
  @nullable
  Homepage get wikiLink;

  @override
  _SnippetResult copyWith(
      {@nullable Homepage homepage,
      @nullable Homepage iata,
      @nullable SnippetResultLocation location,
      @nullable Homepage name,
      @nullable Homepage wikiLink});
}

RankingInfo _$RankingInfoFromJson(Map<String, dynamic> json) {
  return _RankingInfo.fromJson(json);
}

mixin _$RankingInfo {
  @nullable
  int get nbTypos;
  @nullable
  int get firstMatchedWord;
  @nullable
  int get proximityDistance;
  @nullable
  int get userScore;
  @nullable
  int get geoDistance;
  @nullable
  int get geoPrecision;
  @nullable
  int get nbExactWords;
  @nullable
  int get words;
  @nullable
  int get filters;

  RankingInfo copyWith(
      {@nullable int nbTypos,
      @nullable int firstMatchedWord,
      @nullable int proximityDistance,
      @nullable int userScore,
      @nullable int geoDistance,
      @nullable int geoPrecision,
      @nullable int nbExactWords,
      @nullable int words,
      @nullable int filters});

  Map<String, dynamic> toJson();
}

@JsonSerializable()
class _$_RankingInfo with DiagnosticableTreeMixin implements _RankingInfo {
  const _$_RankingInfo(
      {@required @nullable this.nbTypos,
      @required @nullable this.firstMatchedWord,
      @required @nullable this.proximityDistance,
      @required @nullable this.userScore,
      @required @nullable this.geoDistance,
      @required @nullable this.geoPrecision,
      @required @nullable this.nbExactWords,
      @required @nullable this.words,
      @required @nullable this.filters});

  factory _$_RankingInfo.fromJson(Map<String, dynamic> json) =>
      _$_$_RankingInfoFromJson(json);

  @override
  @nullable
  final int nbTypos;
  @override
  @nullable
  final int firstMatchedWord;
  @override
  @nullable
  final int proximityDistance;
  @override
  @nullable
  final int userScore;
  @override
  @nullable
  final int geoDistance;
  @override
  @nullable
  final int geoPrecision;
  @override
  @nullable
  final int nbExactWords;
  @override
  @nullable
  final int words;
  @override
  @nullable
  final int filters;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'RankingInfo(nbTypos: $nbTypos, firstMatchedWord: $firstMatchedWord, proximityDistance: $proximityDistance, userScore: $userScore, geoDistance: $geoDistance, geoPrecision: $geoPrecision, nbExactWords: $nbExactWords, words: $words, filters: $filters)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'RankingInfo'))
      ..add(DiagnosticsProperty('nbTypos', nbTypos))
      ..add(DiagnosticsProperty('firstMatchedWord', firstMatchedWord))
      ..add(DiagnosticsProperty('proximityDistance', proximityDistance))
      ..add(DiagnosticsProperty('userScore', userScore))
      ..add(DiagnosticsProperty('geoDistance', geoDistance))
      ..add(DiagnosticsProperty('geoPrecision', geoPrecision))
      ..add(DiagnosticsProperty('nbExactWords', nbExactWords))
      ..add(DiagnosticsProperty('words', words))
      ..add(DiagnosticsProperty('filters', filters));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _RankingInfo &&
            (identical(other.nbTypos, nbTypos) ||
                const DeepCollectionEquality()
                    .equals(other.nbTypos, nbTypos)) &&
            (identical(other.firstMatchedWord, firstMatchedWord) ||
                const DeepCollectionEquality()
                    .equals(other.firstMatchedWord, firstMatchedWord)) &&
            (identical(other.proximityDistance, proximityDistance) ||
                const DeepCollectionEquality()
                    .equals(other.proximityDistance, proximityDistance)) &&
            (identical(other.userScore, userScore) ||
                const DeepCollectionEquality()
                    .equals(other.userScore, userScore)) &&
            (identical(other.geoDistance, geoDistance) ||
                const DeepCollectionEquality()
                    .equals(other.geoDistance, geoDistance)) &&
            (identical(other.geoPrecision, geoPrecision) ||
                const DeepCollectionEquality()
                    .equals(other.geoPrecision, geoPrecision)) &&
            (identical(other.nbExactWords, nbExactWords) ||
                const DeepCollectionEquality()
                    .equals(other.nbExactWords, nbExactWords)) &&
            (identical(other.words, words) ||
                const DeepCollectionEquality().equals(other.words, words)) &&
            (identical(other.filters, filters) ||
                const DeepCollectionEquality().equals(other.filters, filters)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(nbTypos) ^
      const DeepCollectionEquality().hash(firstMatchedWord) ^
      const DeepCollectionEquality().hash(proximityDistance) ^
      const DeepCollectionEquality().hash(userScore) ^
      const DeepCollectionEquality().hash(geoDistance) ^
      const DeepCollectionEquality().hash(geoPrecision) ^
      const DeepCollectionEquality().hash(nbExactWords) ^
      const DeepCollectionEquality().hash(words) ^
      const DeepCollectionEquality().hash(filters);

  @override
  _$_RankingInfo copyWith({
    Object nbTypos = freezed,
    Object firstMatchedWord = freezed,
    Object proximityDistance = freezed,
    Object userScore = freezed,
    Object geoDistance = freezed,
    Object geoPrecision = freezed,
    Object nbExactWords = freezed,
    Object words = freezed,
    Object filters = freezed,
  }) {
    return _$_RankingInfo(
      nbTypos: nbTypos == freezed ? this.nbTypos : nbTypos as int,
      firstMatchedWord: firstMatchedWord == freezed
          ? this.firstMatchedWord
          : firstMatchedWord as int,
      proximityDistance: proximityDistance == freezed
          ? this.proximityDistance
          : proximityDistance as int,
      userScore: userScore == freezed ? this.userScore : userScore as int,
      geoDistance:
          geoDistance == freezed ? this.geoDistance : geoDistance as int,
      geoPrecision:
          geoPrecision == freezed ? this.geoPrecision : geoPrecision as int,
      nbExactWords:
          nbExactWords == freezed ? this.nbExactWords : nbExactWords as int,
      words: words == freezed ? this.words : words as int,
      filters: filters == freezed ? this.filters : filters as int,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return _$_$_RankingInfoToJson(this);
  }
}

abstract class _RankingInfo implements RankingInfo {
  const factory _RankingInfo(
      {@required @nullable int nbTypos,
      @required @nullable int firstMatchedWord,
      @required @nullable int proximityDistance,
      @required @nullable int userScore,
      @required @nullable int geoDistance,
      @required @nullable int geoPrecision,
      @required @nullable int nbExactWords,
      @required @nullable int words,
      @required @nullable int filters}) = _$_RankingInfo;

  factory _RankingInfo.fromJson(Map<String, dynamic> json) =
      _$_RankingInfo.fromJson;

  @override
  @nullable
  int get nbTypos;
  @override
  @nullable
  int get firstMatchedWord;
  @override
  @nullable
  int get proximityDistance;
  @override
  @nullable
  int get userScore;
  @override
  @nullable
  int get geoDistance;
  @override
  @nullable
  int get geoPrecision;
  @override
  @nullable
  int get nbExactWords;
  @override
  @nullable
  int get words;
  @override
  @nullable
  int get filters;

  @override
  _RankingInfo copyWith(
      {@nullable int nbTypos,
      @nullable int firstMatchedWord,
      @nullable int proximityDistance,
      @nullable int userScore,
      @nullable int geoDistance,
      @nullable int geoPrecision,
      @nullable int nbExactWords,
      @nullable int words,
      @nullable int filters});
}

SnippetResultLocation _$SnippetResultLocationFromJson(
    Map<String, dynamic> json) {
  return _SnippetResultLocation.fromJson(json);
}

mixin _$SnippetResultLocation {
  @nullable
  Homepage get city;
  @nullable
  Homepage get continent;
  @nullable
  Homepage get country;
  @nullable
  Homepage get geohash;
  @nullable
  Homepage get latitude;
  @nullable
  Homepage get longitude;
  @nullable
  Homepage get subregion;

  SnippetResultLocation copyWith(
      {@nullable Homepage city,
      @nullable Homepage continent,
      @nullable Homepage country,
      @nullable Homepage geohash,
      @nullable Homepage latitude,
      @nullable Homepage longitude,
      @nullable Homepage subregion});

  Map<String, dynamic> toJson();
}

@JsonSerializable()
class _$_SnippetResultLocation
    with DiagnosticableTreeMixin
    implements _SnippetResultLocation {
  const _$_SnippetResultLocation(
      {@required @nullable this.city,
      @required @nullable this.continent,
      @required @nullable this.country,
      @required @nullable this.geohash,
      @required @nullable this.latitude,
      @required @nullable this.longitude,
      @required @nullable this.subregion});

  factory _$_SnippetResultLocation.fromJson(Map<String, dynamic> json) =>
      _$_$_SnippetResultLocationFromJson(json);

  @override
  @nullable
  final Homepage city;
  @override
  @nullable
  final Homepage continent;
  @override
  @nullable
  final Homepage country;
  @override
  @nullable
  final Homepage geohash;
  @override
  @nullable
  final Homepage latitude;
  @override
  @nullable
  final Homepage longitude;
  @override
  @nullable
  final Homepage subregion;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SnippetResultLocation(city: $city, continent: $continent, country: $country, geohash: $geohash, latitude: $latitude, longitude: $longitude, subregion: $subregion)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SnippetResultLocation'))
      ..add(DiagnosticsProperty('city', city))
      ..add(DiagnosticsProperty('continent', continent))
      ..add(DiagnosticsProperty('country', country))
      ..add(DiagnosticsProperty('geohash', geohash))
      ..add(DiagnosticsProperty('latitude', latitude))
      ..add(DiagnosticsProperty('longitude', longitude))
      ..add(DiagnosticsProperty('subregion', subregion));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _SnippetResultLocation &&
            (identical(other.city, city) ||
                const DeepCollectionEquality().equals(other.city, city)) &&
            (identical(other.continent, continent) ||
                const DeepCollectionEquality()
                    .equals(other.continent, continent)) &&
            (identical(other.country, country) ||
                const DeepCollectionEquality()
                    .equals(other.country, country)) &&
            (identical(other.geohash, geohash) ||
                const DeepCollectionEquality()
                    .equals(other.geohash, geohash)) &&
            (identical(other.latitude, latitude) ||
                const DeepCollectionEquality()
                    .equals(other.latitude, latitude)) &&
            (identical(other.longitude, longitude) ||
                const DeepCollectionEquality()
                    .equals(other.longitude, longitude)) &&
            (identical(other.subregion, subregion) ||
                const DeepCollectionEquality()
                    .equals(other.subregion, subregion)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(city) ^
      const DeepCollectionEquality().hash(continent) ^
      const DeepCollectionEquality().hash(country) ^
      const DeepCollectionEquality().hash(geohash) ^
      const DeepCollectionEquality().hash(latitude) ^
      const DeepCollectionEquality().hash(longitude) ^
      const DeepCollectionEquality().hash(subregion);

  @override
  _$_SnippetResultLocation copyWith({
    Object city = freezed,
    Object continent = freezed,
    Object country = freezed,
    Object geohash = freezed,
    Object latitude = freezed,
    Object longitude = freezed,
    Object subregion = freezed,
  }) {
    return _$_SnippetResultLocation(
      city: city == freezed ? this.city : city as Homepage,
      continent: continent == freezed ? this.continent : continent as Homepage,
      country: country == freezed ? this.country : country as Homepage,
      geohash: geohash == freezed ? this.geohash : geohash as Homepage,
      latitude: latitude == freezed ? this.latitude : latitude as Homepage,
      longitude: longitude == freezed ? this.longitude : longitude as Homepage,
      subregion: subregion == freezed ? this.subregion : subregion as Homepage,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return _$_$_SnippetResultLocationToJson(this);
  }
}

abstract class _SnippetResultLocation implements SnippetResultLocation {
  const factory _SnippetResultLocation(
      {@required @nullable Homepage city,
      @required @nullable Homepage continent,
      @required @nullable Homepage country,
      @required @nullable Homepage geohash,
      @required @nullable Homepage latitude,
      @required @nullable Homepage longitude,
      @required @nullable Homepage subregion}) = _$_SnippetResultLocation;

  factory _SnippetResultLocation.fromJson(Map<String, dynamic> json) =
      _$_SnippetResultLocation.fromJson;

  @override
  @nullable
  Homepage get city;
  @override
  @nullable
  Homepage get continent;
  @override
  @nullable
  Homepage get country;
  @override
  @nullable
  Homepage get geohash;
  @override
  @nullable
  Homepage get latitude;
  @override
  @nullable
  Homepage get longitude;
  @override
  @nullable
  Homepage get subregion;

  @override
  _SnippetResultLocation copyWith(
      {@nullable Homepage city,
      @nullable Homepage continent,
      @nullable Homepage country,
      @nullable Homepage geohash,
      @nullable Homepage latitude,
      @nullable Homepage longitude,
      @nullable Homepage subregion});
}

Homepage _$HomepageFromJson(Map<String, dynamic> json) {
  return _HomePage.fromJson(json);
}

mixin _$Homepage {
  @nullable
  String get matchLevel;
  @nullable
  String get value;

  Homepage copyWith({@nullable String matchLevel, @nullable String value});

  Map<String, dynamic> toJson();
}

@JsonSerializable()
class _$_HomePage with DiagnosticableTreeMixin implements _HomePage {
  const _$_HomePage(
      {@required @nullable this.matchLevel, @required @nullable this.value});

  factory _$_HomePage.fromJson(Map<String, dynamic> json) =>
      _$_$_HomePageFromJson(json);

  @override
  @nullable
  final String matchLevel;
  @override
  @nullable
  final String value;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Homepage(matchLevel: $matchLevel, value: $value)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Homepage'))
      ..add(DiagnosticsProperty('matchLevel', matchLevel))
      ..add(DiagnosticsProperty('value', value));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _HomePage &&
            (identical(other.matchLevel, matchLevel) ||
                const DeepCollectionEquality()
                    .equals(other.matchLevel, matchLevel)) &&
            (identical(other.value, value) ||
                const DeepCollectionEquality().equals(other.value, value)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(matchLevel) ^
      const DeepCollectionEquality().hash(value);

  @override
  _$_HomePage copyWith({
    Object matchLevel = freezed,
    Object value = freezed,
  }) {
    return _$_HomePage(
      matchLevel:
          matchLevel == freezed ? this.matchLevel : matchLevel as String,
      value: value == freezed ? this.value : value as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return _$_$_HomePageToJson(this);
  }
}

abstract class _HomePage implements Homepage {
  const factory _HomePage(
      {@required @nullable String matchLevel,
      @required @nullable String value}) = _$_HomePage;

  factory _HomePage.fromJson(Map<String, dynamic> json) = _$_HomePage.fromJson;

  @override
  @nullable
  String get matchLevel;
  @override
  @nullable
  String get value;

  @override
  _HomePage copyWith({@nullable String matchLevel, @nullable String value});
}
