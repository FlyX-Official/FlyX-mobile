// To parse this JSON data, do
//
//     final autoCompleteResponse = autoCompleteResponseFromJson(jsonString);

import 'dart:convert';

AutoCompleteResponse autoCompleteResponseFromJson(String str) => AutoCompleteResponse.fromJson(json.decode(str));

String autoCompleteResponseToJson(AutoCompleteResponse data) => json.encode(data.toJson());

class AutoCompleteResponse {
    final int took;
    final bool timedOut;
    final Shards shards;
    final Hits hits;
    final Suggest suggest;

    AutoCompleteResponse({
        this.took,
        this.timedOut,
        this.shards,
        this.hits,
        this.suggest,
    });

    AutoCompleteResponse copyWith({
        int took,
        bool timedOut,
        Shards shards,
        Hits hits,
        Suggest suggest,
    }) => 
        AutoCompleteResponse(
            took: took ?? this.took,
            timedOut: timedOut ?? this.timedOut,
            shards: shards ?? this.shards,
            hits: hits ?? this.hits,
            suggest: suggest ?? this.suggest,
        );

    factory AutoCompleteResponse.fromJson(Map<String, dynamic> json) => AutoCompleteResponse(
        took: json["took"] == null ? null : json["took"],
        timedOut: json["timed_out"] == null ? null : json["timed_out"],
        shards: json["_shards"] == null ? null : Shards.fromJson(json["_shards"]),
        hits: json["hits"] == null ? null : Hits.fromJson(json["hits"]),
        suggest: json["suggest"] == null ? null : Suggest.fromJson(json["suggest"]),
    );

    Map<String, dynamic> toJson() => {
        "took": took == null ? null : took,
        "timed_out": timedOut == null ? null : timedOut,
        "_shards": shards == null ? null : shards.toJson(),
        "hits": hits == null ? null : hits.toJson(),
        "suggest": suggest == null ? null : suggest.toJson(),
    };
}

class Hits {
    final int total;
    final int maxScore;
    final List<dynamic> hits;

    Hits({
        this.total,
        this.maxScore,
        this.hits,
    });

    Hits copyWith({
        int total,
        int maxScore,
        List<dynamic> hits,
    }) => 
        Hits(
            total: total ?? this.total,
            maxScore: maxScore ?? this.maxScore,
            hits: hits ?? this.hits,
        );

    factory Hits.fromJson(Map<String, dynamic> json) => Hits(
        total: json["total"] == null ? null : json["total"],
        maxScore: json["max_score"] == null ? null : json["max_score"],
        hits: json["hits"] == null ? null : List<dynamic>.from(json["hits"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "total": total == null ? null : total,
        "max_score": maxScore == null ? null : maxScore,
        "hits": hits == null ? null : List<dynamic>.from(hits.map((x) => x)),
    };
}

class Shards {
    final int total;
    final int successful;
    final int skipped;
    final int failed;

    Shards({
        this.total,
        this.successful,
        this.skipped,
        this.failed,
    });

    Shards copyWith({
        int total,
        int successful,
        int skipped,
        int failed,
    }) => 
        Shards(
            total: total ?? this.total,
            successful: successful ?? this.successful,
            skipped: skipped ?? this.skipped,
            failed: failed ?? this.failed,
        );

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

class Suggest {
    final List<City> city;
    final List<City> iata;
    final List<City> name;

    Suggest({
        this.city,
        this.iata,
        this.name,
    });

    Suggest copyWith({
        List<City> city,
        List<City> iata,
        List<City> name,
    }) => 
        Suggest(
            city: city ?? this.city,
            iata: iata ?? this.iata,
            name: name ?? this.name,
        );

    factory Suggest.fromJson(Map<String, dynamic> json) => Suggest(
        city: json["City"] == null ? null : List<City>.from(json["City"].map((x) => City.fromJson(x))),
        iata: json["Iata"] == null ? null : List<City>.from(json["Iata"].map((x) => City.fromJson(x))),
        name: json["Name"] == null ? null : List<City>.from(json["Name"].map((x) => City.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "City": city == null ? null : List<dynamic>.from(city.map((x) => x.toJson())),
        "Iata": iata == null ? null : List<dynamic>.from(iata.map((x) => x.toJson())),
        "Name": name == null ? null : List<dynamic>.from(name.map((x) => x.toJson())),
    };
}

class City {
    final String text;
    final int offset;
    final int length;
    final List<Option> options;

    City({
        this.text,
        this.offset,
        this.length,
        this.options,
    });

    City copyWith({
        String text,
        int offset,
        int length,
        List<Option> options,
    }) => 
        City(
            text: text ?? this.text,
            offset: offset ?? this.offset,
            length: length ?? this.length,
            options: options ?? this.options,
        );

    factory City.fromJson(Map<String, dynamic> json) => City(
        text: json["text"] == null ? null : json["text"],
        offset: json["offset"] == null ? null : json["offset"],
        length: json["length"] == null ? null : json["length"],
        options: json["options"] == null ? null : List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "text": text == null ? null : text,
        "offset": offset == null ? null : offset,
        "length": length == null ? null : length,
        "options": options == null ? null : List<dynamic>.from(options.map((x) => x.toJson())),
    };
}

class Option {
    final String text;
    final String index;
    final String type;
    final String id;
    final int score;
    final Source source;

    Option({
        this.text,
        this.index,
        this.type,
        this.id,
        this.score,
        this.source,
    });

    Option copyWith({
        String text,
        String index,
        String type,
        String id,
        int score,
        Source source,
    }) => 
        Option(
            text: text ?? this.text,
            index: index ?? this.index,
            type: type ?? this.type,
            id: id ?? this.id,
            score: score ?? this.score,
            source: source ?? this.source,
        );

    factory Option.fromJson(Map<String, dynamic> json) => Option(
        text: json["text"] == null ? null : json["text"],
        index: json["_index"] == null ? null : json["_index"],
        type: json["_type"] == null ? null : json["_type"],
        id: json["_id"] == null ? null : json["_id"],
        score: json["_score"] == null ? null : json["_score"],
        source: json["_source"] == null ? null : Source.fromJson(json["_source"]),
    );

    Map<String, dynamic> toJson() => {
        "text": text == null ? null : text,
        "_index": index == null ? null : index,
        "_type": type == null ? null : type,
        "_id": id == null ? null : id,
        "_score": score == null ? null : score,
        "_source": source == null ? null : source.toJson(),
    };
}

class Source {
    final String name;
    final String city;
    final String country;
    final String iata;
    final String icao;
    final double latitude;
    final double longitude;
    final String geohash;
    final String combined;
    final String iataCompletion;

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

    Source copyWith({
        String name,
        String city,
        String country,
        String iata,
        String icao,
        double latitude,
        double longitude,
        String geohash,
        String combined,
        String iataCompletion,
    }) => 
        Source(
            name: name ?? this.name,
            city: city ?? this.city,
            country: country ?? this.country,
            iata: iata ?? this.iata,
            icao: icao ?? this.icao,
            latitude: latitude ?? this.latitude,
            longitude: longitude ?? this.longitude,
            geohash: geohash ?? this.geohash,
            combined: combined ?? this.combined,
            iataCompletion: iataCompletion ?? this.iataCompletion,
        );

    factory Source.fromJson(Map<String, dynamic> json) => Source(
        name: json["Name"] == null ? null : json["Name"],
        city: json["City"] == null ? null : json["City"],
        country: json["Country"] == null ? null : json["Country"],
        iata: json["IATA"] == null ? null : json["IATA"],
        icao: json["ICAO"] == null ? null : json["ICAO"],
        latitude: json["Latitude"] == null ? null : json["Latitude"].toDouble(),
        longitude: json["Longitude"] == null ? null : json["Longitude"].toDouble(),
        geohash: json["Geohash"] == null ? null : json["Geohash"],
        combined: json["Combined"] == null ? null : json["Combined"],
        iataCompletion: json["IATA_Completion"] == null ? null : json["IATA_Completion"],
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
