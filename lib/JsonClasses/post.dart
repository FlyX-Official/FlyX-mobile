// To parse this JSON data, do
//
//     final post = postFromJson(jsonString);

import 'dart:convert';

Post postFromJson(String str) {
    final jsonData = json.decode(str);
    return Post.fromJson(jsonData);
}

String postToJson(Post data) {
    final dyn = data.toJson();
    return json.encode(dyn);
}

class Post {
    bool oneWay;
    String from;
    String to;
    double radiusFrom;
    double radiusTo;
    DepartureWindow departureWindow;
    ReturnDepartureWindow returnDepartureWindow;

    Post({
        this.oneWay,
        this.from,
        this.to,
        this.radiusFrom,
        this.radiusTo,
        this.departureWindow,
        this.returnDepartureWindow,
    });

    factory Post.fromJson(Map<String, dynamic> json) => new Post(
        oneWay: json["oneWay"] == null ? null : json["oneWay"],
        from: json["from"] == null ? null : json["from"],
        to: json["to"] == null ? null : json["to"],
        radiusFrom: json["radiusFrom"] == null ? null : json["radiusFrom"].toDouble(),
        radiusTo: json["radiusTo"] == null ? null : json["radiusTo"].toDouble(),
        departureWindow: json["departureWindow"] == null ? null : DepartureWindow.fromJson(json["departureWindow"]),
        returnDepartureWindow: json["returnDepartureWindow"] == null ? null : ReturnDepartureWindow.fromJson(json["returnDepartureWindow"]),
    );

    Map<String, dynamic> toJson() => {
        "oneWay": oneWay == null ? null : oneWay,
        "from": from == null ? null : from,
        "to": to == null ? null : to,
        "radiusFrom": radiusFrom == null ? null : radiusFrom,
        "radiusTo": radiusTo == null ? null : radiusTo,
        "departureWindow": departureWindow == null ? null : departureWindow.toJson(),
        "returnDepartureWindow": returnDepartureWindow == null ? null : returnDepartureWindow.toJson(),
    };
}

class DepartureWindow {
    DateTime start;
    DateTime end;

    DepartureWindow({
        this.start,
        this.end,
    });

    factory DepartureWindow.fromJson(Map<String, dynamic> json) => new DepartureWindow(
        start: json["start"] == null ? null : DateTime.parse(json["start"]),
        end: json["end"] == null ? null : DateTime.parse(json["end"]),
    );

    Map<String, dynamic> toJson() => {
        "start": start == null ? null : start.toIso8601String(),
        "end": end == null ? null : end.toIso8601String(),
    };
}

class ReturnDepartureWindow {
    DateTime start;
    DateTime end;

    ReturnDepartureWindow({
        this.start,
        this.end,
    });

    factory ReturnDepartureWindow.fromJson(Map<String, dynamic> json) => new ReturnDepartureWindow(
        start: json["start"] == null ? null : DateTime.parse(json["start"]),
        end: json["end"] == null ? null : DateTime.parse(json["end"]),
    );

    Map<String, dynamic> toJson() => {
        "start": start == null ? null : start.toIso8601String(),
        "end": end == null ? null : end.toIso8601String(),
    };
}