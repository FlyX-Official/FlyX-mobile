// To parse this JSON data, do
//
//     final trip = tripFromJson(jsonString);

import 'dart:convert';

Trip tripFromJson(String str) => Trip.fromJson(json.decode(str));

String tripToJson(Trip data) => json.encode(data.toJson());

class Trip {
  final String searchId;
  final List<Datum> data;
  final List<dynamic> connections;
  final int time;
  final String currency;
  final double currencyRate;
  final double fxRate;
  final List<dynamic> refresh;
  final double del;
  final List<dynamic> refTasks;
  final SearchParams searchParams;
  final List<dynamic> allStopoverAirports;
  final List<dynamic> allAirlines;

  Trip({
    this.searchId,
    this.data,
    this.connections,
    this.time,
    this.currency,
    this.currencyRate,
    this.fxRate,
    this.refresh,
    this.del,
    this.refTasks,
    this.searchParams,
    this.allStopoverAirports,
    this.allAirlines,
  });

  Trip copyWith({
    String searchId,
    List<Datum> data,
    List<dynamic> connections,
    int time,
    String currency,
    double currencyRate,
    double fxRate,
    List<dynamic> refresh,
    double del,
    List<dynamic> refTasks,
    SearchParams searchParams,
    List<dynamic> allStopoverAirports,
    List<dynamic> allAirlines,
  }) =>
      Trip(
        searchId: searchId ?? this.searchId,
        data: data ?? this.data,
        connections: connections ?? this.connections,
        time: time ?? this.time,
        currency: currency ?? this.currency,
        currencyRate: currencyRate ?? this.currencyRate,
        fxRate: fxRate ?? this.fxRate,
        refresh: refresh ?? this.refresh,
        del: del ?? this.del,
        refTasks: refTasks ?? this.refTasks,
        searchParams: searchParams ?? this.searchParams,
        allStopoverAirports: allStopoverAirports ?? this.allStopoverAirports,
        allAirlines: allAirlines ?? this.allAirlines,
      );

  factory Trip.fromJson(Map<String, dynamic> json) => Trip(
        searchId: json["search_id"] == null ? null : json["search_id"],
        data: json["data"] == null
            ? null
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        connections: json["connections"] == null
            ? null
            : List<dynamic>.from(json["connections"].map((x) => x)),
        time: json["time"] == null ? null : json["time"],
        currency: json["currency"] == null ? null : json["currency"],
        currencyRate: json["currency_rate"] == null
            ? null
            : json["currency_rate"].toDouble(),
        fxRate: json["fx_rate"] == null ? null : json["fx_rate"].toDouble(),
        refresh: json["refresh"] == null
            ? null
            : List<dynamic>.from(json["refresh"].map((x) => x)),
        del: json["del"] == null ? null : json["del"].toDouble(),
        refTasks: json["ref_tasks"] == null
            ? null
            : List<dynamic>.from(json["ref_tasks"].map((x) => x)),
        searchParams: json["search_params"] == null
            ? null
            : SearchParams.fromJson(json["search_params"]),
        allStopoverAirports: json["all_stopover_airports"] == null
            ? null
            : List<dynamic>.from(json["all_stopover_airports"].map((x) => x)),
        allAirlines: json["all_airlines"] == null
            ? null
            : List<dynamic>.from(json["all_airlines"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "search_id": searchId == null ? null : searchId,
        "data": data == null
            ? null
            : List<dynamic>.from(data.map((x) => x.toJson())),
        "connections": connections == null
            ? null
            : List<dynamic>.from(connections.map((x) => x)),
        "time": time == null ? null : time,
        "currency": currency == null ? null : currency,
        "currency_rate": currencyRate == null ? null : currencyRate,
        "fx_rate": fxRate == null ? null : fxRate,
        "refresh":
            refresh == null ? null : List<dynamic>.from(refresh.map((x) => x)),
        "del": del == null ? null : del,
        "ref_tasks": refTasks == null
            ? null
            : List<dynamic>.from(refTasks.map((x) => x)),
        "search_params": searchParams == null ? null : searchParams.toJson(),
        "all_stopover_airports": allStopoverAirports == null
            ? null
            : List<dynamic>.from(allStopoverAirports.map((x) => x)),
        "all_airlines": allAirlines == null
            ? null
            : List<dynamic>.from(allAirlines.map((x) => x)),
      };
}

class Datum {
  final String id;
  final Map<String, double> bagsPrice;
  final Baglimit baglimit;
  final int p1;
  final int p2;
  final int p3;
  final int price;
  final List<Route> route;
  final List<String> airlines;
  final int pnrCount;
  final List<dynamic> transfers;
  final bool hasAirportChange;
  final int technicalStops;
  final Availability availability;
  final List<String> typeFlights;
  final int dTime;
  final int dTimeUtc;
  final int aTime;
  final int aTimeUtc;
  final int nightsInDest;
  final String flyFrom;
  final String flyTo;
  final String cityFrom;
  final String cityTo;
  final String cityCodeFrom;
  final String cityCodeTo;
  final Country countryFrom;
  final Country countryTo;
  final String mapIdfrom;
  final String mapIdto;
  final double distance;
  final List<List<String>> routes;
  final bool virtualInterlining;
  final String flyDuration;
  final Duration duration;
  final String returnDuration;
  final bool facilitatedBookingAvailable;
  final List<String> foundOn;
  final Conversion conversion;
  final double quality;
  final String bookingToken;
  final String deepLink;

  Datum({
    this.id,
    this.bagsPrice,
    this.baglimit,
    this.p1,
    this.p2,
    this.p3,
    this.price,
    this.route,
    this.airlines,
    this.pnrCount,
    this.transfers,
    this.hasAirportChange,
    this.technicalStops,
    this.availability,
    this.typeFlights,
    this.dTime,
    this.dTimeUtc,
    this.aTime,
    this.aTimeUtc,
    this.nightsInDest,
    this.flyFrom,
    this.flyTo,
    this.cityFrom,
    this.cityTo,
    this.cityCodeFrom,
    this.cityCodeTo,
    this.countryFrom,
    this.countryTo,
    this.mapIdfrom,
    this.mapIdto,
    this.distance,
    this.routes,
    this.virtualInterlining,
    this.flyDuration,
    this.duration,
    this.returnDuration,
    this.facilitatedBookingAvailable,
    this.foundOn,
    this.conversion,
    this.quality,
    this.bookingToken,
    this.deepLink,
  });

  Datum copyWith({
    String id,
    Map<String, double> bagsPrice,
    Baglimit baglimit,
    int p1,
    int p2,
    int p3,
    int price,
    List<Route> route,
    List<String> airlines,
    int pnrCount,
    List<dynamic> transfers,
    bool hasAirportChange,
    int technicalStops,
    Availability availability,
    List<String> typeFlights,
    int dTime,
    int dTimeUtc,
    int aTime,
    int aTimeUtc,
    int nightsInDest,
    String flyFrom,
    String flyTo,
    String cityFrom,
    String cityTo,
    String cityCodeFrom,
    String cityCodeTo,
    Country countryFrom,
    Country countryTo,
    String mapIdfrom,
    String mapIdto,
    double distance,
    List<List<String>> routes,
    bool virtualInterlining,
    String flyDuration,
    Duration duration,
    String returnDuration,
    bool facilitatedBookingAvailable,
    List<String> foundOn,
    Conversion conversion,
    double quality,
    String bookingToken,
    String deepLink,
  }) =>
      Datum(
        id: id ?? this.id,
        bagsPrice: bagsPrice ?? this.bagsPrice,
        baglimit: baglimit ?? this.baglimit,
        p1: p1 ?? this.p1,
        p2: p2 ?? this.p2,
        p3: p3 ?? this.p3,
        price: price ?? this.price,
        route: route ?? this.route,
        airlines: airlines ?? this.airlines,
        pnrCount: pnrCount ?? this.pnrCount,
        transfers: transfers ?? this.transfers,
        hasAirportChange: hasAirportChange ?? this.hasAirportChange,
        technicalStops: technicalStops ?? this.technicalStops,
        availability: availability ?? this.availability,
        typeFlights: typeFlights ?? this.typeFlights,
        dTime: dTime ?? this.dTime,
        dTimeUtc: dTimeUtc ?? this.dTimeUtc,
        aTime: aTime ?? this.aTime,
        aTimeUtc: aTimeUtc ?? this.aTimeUtc,
        nightsInDest: nightsInDest ?? this.nightsInDest,
        flyFrom: flyFrom ?? this.flyFrom,
        flyTo: flyTo ?? this.flyTo,
        cityFrom: cityFrom ?? this.cityFrom,
        cityTo: cityTo ?? this.cityTo,
        cityCodeFrom: cityCodeFrom ?? this.cityCodeFrom,
        cityCodeTo: cityCodeTo ?? this.cityCodeTo,
        countryFrom: countryFrom ?? this.countryFrom,
        countryTo: countryTo ?? this.countryTo,
        mapIdfrom: mapIdfrom ?? this.mapIdfrom,
        mapIdto: mapIdto ?? this.mapIdto,
        distance: distance ?? this.distance,
        routes: routes ?? this.routes,
        virtualInterlining: virtualInterlining ?? this.virtualInterlining,
        flyDuration: flyDuration ?? this.flyDuration,
        duration: duration ?? this.duration,
        returnDuration: returnDuration ?? this.returnDuration,
        facilitatedBookingAvailable:
            facilitatedBookingAvailable ?? this.facilitatedBookingAvailable,
        foundOn: foundOn ?? this.foundOn,
        conversion: conversion ?? this.conversion,
        quality: quality ?? this.quality,
        bookingToken: bookingToken ?? this.bookingToken,
        deepLink: deepLink ?? this.deepLink,
      );

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"] == null ? null : json["id"],
        bagsPrice: json["bags_price"] == null
            ? null
            : Map.from(json["bags_price"])
                .map((k, v) => MapEntry<String, double>(k, v.toDouble())),
        baglimit: json["baglimit"] == null
            ? null
            : Baglimit.fromJson(json["baglimit"]),
        p1: json["p1"] == null ? null : json["p1"],
        p2: json["p2"] == null ? null : json["p2"],
        p3: json["p3"] == null ? null : json["p3"],
        price: json["price"] == null ? null : json["price"],
        route: json["route"] == null
            ? null
            : List<Route>.from(json["route"].map((x) => Route.fromJson(x))),
        airlines: json["airlines"] == null
            ? null
            : List<String>.from(json["airlines"].map((x) => x)),
        pnrCount: json["pnr_count"] == null ? null : json["pnr_count"],
        transfers: json["transfers"] == null
            ? null
            : List<dynamic>.from(json["transfers"].map((x) => x)),
        hasAirportChange: json["has_airport_change"] == null
            ? null
            : json["has_airport_change"],
        technicalStops:
            json["technical_stops"] == null ? null : json["technical_stops"],
        availability: json["availability"] == null
            ? null
            : Availability.fromJson(json["availability"]),
        typeFlights: json["type_flights"] == null
            ? null
            : List<String>.from(json["type_flights"].map((x) => x)),
        dTime: json["dTime"] == null ? null : json["dTime"],
        dTimeUtc: json["dTimeUTC"] == null ? null : json["dTimeUTC"],
        aTime: json["aTime"] == null ? null : json["aTime"],
        aTimeUtc: json["aTimeUTC"] == null ? null : json["aTimeUTC"],
        nightsInDest:
            json["nightsInDest"] == null ? null : json["nightsInDest"],
        flyFrom: json["flyFrom"] == null ? null : json["flyFrom"],
        flyTo: json["flyTo"] == null ? null : json["flyTo"],
        cityFrom: json["cityFrom"] == null ? null : json["cityFrom"],
        cityTo: json["cityTo"] == null ? null : json["cityTo"],
        cityCodeFrom:
            json["cityCodeFrom"] == null ? null : json["cityCodeFrom"],
        cityCodeTo: json["cityCodeTo"] == null ? null : json["cityCodeTo"],
        countryFrom: json["countryFrom"] == null
            ? null
            : Country.fromJson(json["countryFrom"]),
        countryTo: json["countryTo"] == null
            ? null
            : Country.fromJson(json["countryTo"]),
        mapIdfrom: json["mapIdfrom"] == null ? null : json["mapIdfrom"],
        mapIdto: json["mapIdto"] == null ? null : json["mapIdto"],
        distance: json["distance"] == null ? null : json["distance"].toDouble(),
        routes: json["routes"] == null
            ? null
            : List<List<String>>.from(
                json["routes"].map((x) => List<String>.from(x.map((x) => x)))),
        virtualInterlining: json["virtual_interlining"] == null
            ? null
            : json["virtual_interlining"],
        flyDuration: json["fly_duration"] == null ? null : json["fly_duration"],
        duration: json["duration"] == null
            ? null
            : Duration.fromJson(json["duration"]),
        returnDuration:
            json["return_duration"] == null ? null : json["return_duration"],
        facilitatedBookingAvailable:
            json["facilitated_booking_available"] == null
                ? null
                : json["facilitated_booking_available"],
        foundOn: json["found_on"] == null
            ? null
            : List<String>.from(json["found_on"].map((x) => x)),
        conversion: json["conversion"] == null
            ? null
            : Conversion.fromJson(json["conversion"]),
        quality: json["quality"] == null ? null : json["quality"].toDouble(),
        bookingToken:
            json["booking_token"] == null ? null : json["booking_token"],
        deepLink: json["deep_link"] == null ? null : json["deep_link"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "bags_price": bagsPrice == null
            ? null
            : Map.from(bagsPrice)
                .map((k, v) => MapEntry<String, dynamic>(k, v)),
        "baglimit": baglimit == null ? null : baglimit.toJson(),
        "p1": p1 == null ? null : p1,
        "p2": p2 == null ? null : p2,
        "p3": p3 == null ? null : p3,
        "price": price == null ? null : price,
        "route": route == null
            ? null
            : List<dynamic>.from(route.map((x) => x.toJson())),
        "airlines": airlines == null
            ? null
            : List<dynamic>.from(airlines.map((x) => x)),
        "pnr_count": pnrCount == null ? null : pnrCount,
        "transfers": transfers == null
            ? null
            : List<dynamic>.from(transfers.map((x) => x)),
        "has_airport_change":
            hasAirportChange == null ? null : hasAirportChange,
        "technical_stops": technicalStops == null ? null : technicalStops,
        "availability": availability == null ? null : availability.toJson(),
        "type_flights": typeFlights == null
            ? null
            : List<dynamic>.from(typeFlights.map((x) => x)),
        "dTime": dTime == null ? null : dTime,
        "dTimeUTC": dTimeUtc == null ? null : dTimeUtc,
        "aTime": aTime == null ? null : aTime,
        "aTimeUTC": aTimeUtc == null ? null : aTimeUtc,
        "nightsInDest": nightsInDest == null ? null : nightsInDest,
        "flyFrom": flyFrom == null ? null : flyFrom,
        "flyTo": flyTo == null ? null : flyTo,
        "cityFrom": cityFrom == null ? null : cityFrom,
        "cityTo": cityTo == null ? null : cityTo,
        "cityCodeFrom": cityCodeFrom == null ? null : cityCodeFrom,
        "cityCodeTo": cityCodeTo == null ? null : cityCodeTo,
        "countryFrom": countryFrom == null ? null : countryFrom.toJson(),
        "countryTo": countryTo == null ? null : countryTo.toJson(),
        "mapIdfrom": mapIdfrom == null ? null : mapIdfrom,
        "mapIdto": mapIdto == null ? null : mapIdto,
        "distance": distance == null ? null : distance,
        "routes": routes == null
            ? null
            : List<dynamic>.from(
                routes.map((x) => List<dynamic>.from(x.map((x) => x)))),
        "virtual_interlining":
            virtualInterlining == null ? null : virtualInterlining,
        "fly_duration": flyDuration == null ? null : flyDuration,
        "duration": duration == null ? null : duration.toJson(),
        "return_duration": returnDuration == null ? null : returnDuration,
        "facilitated_booking_available": facilitatedBookingAvailable == null
            ? null
            : facilitatedBookingAvailable,
        "found_on":
            foundOn == null ? null : List<dynamic>.from(foundOn.map((x) => x)),
        "conversion": conversion == null ? null : conversion.toJson(),
        "quality": quality == null ? null : quality,
        "booking_token": bookingToken == null ? null : bookingToken,
        "deep_link": deepLink == null ? null : deepLink,
      };
}

class Availability {
  final int seats;

  Availability({
    this.seats,
  });

  Availability copyWith({
    int seats,
  }) =>
      Availability(
        seats: seats ?? this.seats,
      );

  factory Availability.fromJson(Map<String, dynamic> json) => Availability(
        seats: json["seats"] == null ? null : json["seats"],
      );

  Map<String, dynamic> toJson() => {
        "seats": seats == null ? null : seats,
      };
}

class Baglimit {
  final int handWidth;
  final int handHeight;
  final int handLength;
  final int handWeight;
  final int holdWidth;
  final int holdHeight;
  final int holdLength;
  final int holdDimensionsSum;
  final int holdWeight;

  Baglimit({
    this.handWidth,
    this.handHeight,
    this.handLength,
    this.handWeight,
    this.holdWidth,
    this.holdHeight,
    this.holdLength,
    this.holdDimensionsSum,
    this.holdWeight,
  });

  Baglimit copyWith({
    int handWidth,
    int handHeight,
    int handLength,
    int handWeight,
    int holdWidth,
    int holdHeight,
    int holdLength,
    int holdDimensionsSum,
    int holdWeight,
  }) =>
      Baglimit(
        handWidth: handWidth ?? this.handWidth,
        handHeight: handHeight ?? this.handHeight,
        handLength: handLength ?? this.handLength,
        handWeight: handWeight ?? this.handWeight,
        holdWidth: holdWidth ?? this.holdWidth,
        holdHeight: holdHeight ?? this.holdHeight,
        holdLength: holdLength ?? this.holdLength,
        holdDimensionsSum: holdDimensionsSum ?? this.holdDimensionsSum,
        holdWeight: holdWeight ?? this.holdWeight,
      );

  factory Baglimit.fromJson(Map<String, dynamic> json) => Baglimit(
        handWidth: json["hand_width"] == null ? null : json["hand_width"],
        handHeight: json["hand_height"] == null ? null : json["hand_height"],
        handLength: json["hand_length"] == null ? null : json["hand_length"],
        handWeight: json["hand_weight"] == null ? null : json["hand_weight"],
        holdWidth: json["hold_width"] == null ? null : json["hold_width"],
        holdHeight: json["hold_height"] == null ? null : json["hold_height"],
        holdLength: json["hold_length"] == null ? null : json["hold_length"],
        holdDimensionsSum: json["hold_dimensions_sum"] == null
            ? null
            : json["hold_dimensions_sum"],
        holdWeight: json["hold_weight"] == null ? null : json["hold_weight"],
      );

  Map<String, dynamic> toJson() => {
        "hand_width": handWidth == null ? null : handWidth,
        "hand_height": handHeight == null ? null : handHeight,
        "hand_length": handLength == null ? null : handLength,
        "hand_weight": handWeight == null ? null : handWeight,
        "hold_width": holdWidth == null ? null : holdWidth,
        "hold_height": holdHeight == null ? null : holdHeight,
        "hold_length": holdLength == null ? null : holdLength,
        "hold_dimensions_sum":
            holdDimensionsSum == null ? null : holdDimensionsSum,
        "hold_weight": holdWeight == null ? null : holdWeight,
      };
}

class Conversion {
  final int usd;
  final int eur;

  Conversion({
    this.usd,
    this.eur,
  });

  Conversion copyWith({
    int usd,
    int eur,
  }) =>
      Conversion(
        usd: usd ?? this.usd,
        eur: eur ?? this.eur,
      );

  factory Conversion.fromJson(Map<String, dynamic> json) => Conversion(
        usd: json["USD"] == null ? null : json["USD"],
        eur: json["EUR"] == null ? null : json["EUR"],
      );

  Map<String, dynamic> toJson() => {
        "USD": usd == null ? null : usd,
        "EUR": eur == null ? null : eur,
      };
}

class Country {
  final String code;
  final String name;

  Country({
    this.code,
    this.name,
  });

  Country copyWith({
    String code,
    String name,
  }) =>
      Country(
        code: code ?? this.code,
        name: name ?? this.name,
      );

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        code: json["code"] == null ? null : json["code"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "name": name == null ? null : name,
      };
}

class Duration {
  final int departure;
  final int durationReturn;
  final int total;

  Duration({
    this.departure,
    this.durationReturn,
    this.total,
  });

  Duration copyWith({
    int departure,
    int durationReturn,
    int total,
  }) =>
      Duration(
        departure: departure ?? this.departure,
        durationReturn: durationReturn ?? this.durationReturn,
        total: total ?? this.total,
      );

  factory Duration.fromJson(Map<String, dynamic> json) => Duration(
        departure: json["departure"] == null ? null : json["departure"],
        durationReturn: json["return"] == null ? null : json["return"],
        total: json["total"] == null ? null : json["total"],
      );

  Map<String, dynamic> toJson() => {
        "departure": departure == null ? null : departure,
        "return": durationReturn == null ? null : durationReturn,
        "total": total == null ? null : total,
      };
}

class Route {
  final String fareBasis;
  final String fareCategory;
  final String fareClasses;
  final int price;
  final String fareFamily;
  final String foundOn;
  final int lastSeen;
  final int refreshTimestamp;
  final String source;
  final int routeReturn;
  final bool bagsRecheckRequired;
  final bool guarantee;
  final String id;
  final String combinationId;
  final int originalReturn;
  final int aTime;
  final int dTime;
  final int aTimeUtc;
  final int dTimeUtc;
  final String mapIdfrom;
  final String mapIdto;
  final String cityTo;
  final String cityFrom;
  final String cityCodeFrom;
  final String cityCodeTo;
  final String flyTo;
  final String flyFrom;
  final String airline;
  final String operatingCarrier;
  final String equipment;
  final double latFrom;
  final double lngFrom;
  final double latTo;
  final double lngTo;
  final int flightNo;
  final String vehicleType;
  final String operatingFlightNo;
  final bool followingTechnicalStop;

  Route({
    this.fareBasis,
    this.fareCategory,
    this.fareClasses,
    this.price,
    this.fareFamily,
    this.foundOn,
    this.lastSeen,
    this.refreshTimestamp,
    this.source,
    this.routeReturn,
    this.bagsRecheckRequired,
    this.guarantee,
    this.id,
    this.combinationId,
    this.originalReturn,
    this.aTime,
    this.dTime,
    this.aTimeUtc,
    this.dTimeUtc,
    this.mapIdfrom,
    this.mapIdto,
    this.cityTo,
    this.cityFrom,
    this.cityCodeFrom,
    this.cityCodeTo,
    this.flyTo,
    this.flyFrom,
    this.airline,
    this.operatingCarrier,
    this.equipment,
    this.latFrom,
    this.lngFrom,
    this.latTo,
    this.lngTo,
    this.flightNo,
    this.vehicleType,
    this.operatingFlightNo,
    this.followingTechnicalStop,
  });

  Route copyWith({
    String fareBasis,
    String fareCategory,
    String fareClasses,
    int price,
    String fareFamily,
    String foundOn,
    int lastSeen,
    int refreshTimestamp,
    String source,
    int routeReturn,
    bool bagsRecheckRequired,
    bool guarantee,
    String id,
    String combinationId,
    int originalReturn,
    int aTime,
    int dTime,
    int aTimeUtc,
    int dTimeUtc,
    String mapIdfrom,
    String mapIdto,
    String cityTo,
    String cityFrom,
    String cityCodeFrom,
    String cityCodeTo,
    String flyTo,
    String flyFrom,
    String airline,
    String operatingCarrier,
    String equipment,
    double latFrom,
    double lngFrom,
    double latTo,
    double lngTo,
    int flightNo,
    String vehicleType,
    String operatingFlightNo,
    bool followingTechnicalStop,
  }) =>
      Route(
        fareBasis: fareBasis ?? this.fareBasis,
        fareCategory: fareCategory ?? this.fareCategory,
        fareClasses: fareClasses ?? this.fareClasses,
        price: price ?? this.price,
        fareFamily: fareFamily ?? this.fareFamily,
        foundOn: foundOn ?? this.foundOn,
        lastSeen: lastSeen ?? this.lastSeen,
        refreshTimestamp: refreshTimestamp ?? this.refreshTimestamp,
        source: source ?? this.source,
        routeReturn: routeReturn ?? this.routeReturn,
        bagsRecheckRequired: bagsRecheckRequired ?? this.bagsRecheckRequired,
        guarantee: guarantee ?? this.guarantee,
        id: id ?? this.id,
        combinationId: combinationId ?? this.combinationId,
        originalReturn: originalReturn ?? this.originalReturn,
        aTime: aTime ?? this.aTime,
        dTime: dTime ?? this.dTime,
        aTimeUtc: aTimeUtc ?? this.aTimeUtc,
        dTimeUtc: dTimeUtc ?? this.dTimeUtc,
        mapIdfrom: mapIdfrom ?? this.mapIdfrom,
        mapIdto: mapIdto ?? this.mapIdto,
        cityTo: cityTo ?? this.cityTo,
        cityFrom: cityFrom ?? this.cityFrom,
        cityCodeFrom: cityCodeFrom ?? this.cityCodeFrom,
        cityCodeTo: cityCodeTo ?? this.cityCodeTo,
        flyTo: flyTo ?? this.flyTo,
        flyFrom: flyFrom ?? this.flyFrom,
        airline: airline ?? this.airline,
        operatingCarrier: operatingCarrier ?? this.operatingCarrier,
        equipment: equipment ?? this.equipment,
        latFrom: latFrom ?? this.latFrom,
        lngFrom: lngFrom ?? this.lngFrom,
        latTo: latTo ?? this.latTo,
        lngTo: lngTo ?? this.lngTo,
        flightNo: flightNo ?? this.flightNo,
        vehicleType: vehicleType ?? this.vehicleType,
        operatingFlightNo: operatingFlightNo ?? this.operatingFlightNo,
        followingTechnicalStop:
            followingTechnicalStop ?? this.followingTechnicalStop,
      );

  factory Route.fromJson(Map<String, dynamic> json) => Route(
        fareBasis: json["fare_basis"] == null ? null : json["fare_basis"],
        fareCategory:
            json["fare_category"] == null ? null : json["fare_category"],
        fareClasses: json["fare_classes"] == null ? null : json["fare_classes"],
        price: json["price"] == null ? null : json["price"],
        fareFamily: json["fare_family"] == null ? null : json["fare_family"],
        foundOn: json["found_on"] == null ? null : json["found_on"],
        lastSeen: json["last_seen"] == null ? null : json["last_seen"],
        refreshTimestamp: json["refresh_timestamp"] == null
            ? null
            : json["refresh_timestamp"],
        source: json["source"] == null ? null : json["source"],
        routeReturn: json["return"] == null ? null : json["return"],
        bagsRecheckRequired: json["bags_recheck_required"] == null
            ? null
            : json["bags_recheck_required"],
        guarantee: json["guarantee"] == null ? null : json["guarantee"],
        id: json["id"] == null ? null : json["id"],
        combinationId:
            json["combination_id"] == null ? null : json["combination_id"],
        originalReturn:
            json["original_return"] == null ? null : json["original_return"],
        aTime: json["aTime"] == null ? null : json["aTime"],
        dTime: json["dTime"] == null ? null : json["dTime"],
        aTimeUtc: json["aTimeUTC"] == null ? null : json["aTimeUTC"],
        dTimeUtc: json["dTimeUTC"] == null ? null : json["dTimeUTC"],
        mapIdfrom: json["mapIdfrom"] == null ? null : json["mapIdfrom"],
        mapIdto: json["mapIdto"] == null ? null : json["mapIdto"],
        cityTo: json["cityTo"] == null ? null : json["cityTo"],
        cityFrom: json["cityFrom"] == null ? null : json["cityFrom"],
        cityCodeFrom:
            json["cityCodeFrom"] == null ? null : json["cityCodeFrom"],
        cityCodeTo: json["cityCodeTo"] == null ? null : json["cityCodeTo"],
        flyTo: json["flyTo"] == null ? null : json["flyTo"],
        flyFrom: json["flyFrom"] == null ? null : json["flyFrom"],
        airline: json["airline"] == null ? null : json["airline"],
        operatingCarrier: json["operating_carrier"] == null
            ? null
            : json["operating_carrier"],
        equipment: json["equipment"] == null ? null : json["equipment"],
        latFrom: json["latFrom"] == null ? null : json["latFrom"].toDouble(),
        lngFrom: json["lngFrom"] == null ? null : json["lngFrom"].toDouble(),
        latTo: json["latTo"] == null ? null : json["latTo"].toDouble(),
        lngTo: json["lngTo"] == null ? null : json["lngTo"].toDouble(),
        flightNo: json["flight_no"] == null ? null : json["flight_no"],
        vehicleType: json["vehicle_type"] == null ? null : json["vehicle_type"],
        operatingFlightNo: json["operating_flight_no"] == null
            ? null
            : json["operating_flight_no"],
        followingTechnicalStop: json["following_technical_stop"] == null
            ? null
            : json["following_technical_stop"],
      );

  Map<String, dynamic> toJson() => {
        "fare_basis": fareBasis == null ? null : fareBasis,
        "fare_category": fareCategory == null ? null : fareCategory,
        "fare_classes": fareClasses == null ? null : fareClasses,
        "price": price == null ? null : price,
        "fare_family": fareFamily == null ? null : fareFamily,
        "found_on": foundOn == null ? null : foundOn,
        "last_seen": lastSeen == null ? null : lastSeen,
        "refresh_timestamp": refreshTimestamp == null ? null : refreshTimestamp,
        "source": source == null ? null : source,
        "return": routeReturn == null ? null : routeReturn,
        "bags_recheck_required":
            bagsRecheckRequired == null ? null : bagsRecheckRequired,
        "guarantee": guarantee == null ? null : guarantee,
        "id": id == null ? null : id,
        "combination_id": combinationId == null ? null : combinationId,
        "original_return": originalReturn == null ? null : originalReturn,
        "aTime": aTime == null ? null : aTime,
        "dTime": dTime == null ? null : dTime,
        "aTimeUTC": aTimeUtc == null ? null : aTimeUtc,
        "dTimeUTC": dTimeUtc == null ? null : dTimeUtc,
        "mapIdfrom": mapIdfrom == null ? null : mapIdfrom,
        "mapIdto": mapIdto == null ? null : mapIdto,
        "cityTo": cityTo == null ? null : cityTo,
        "cityFrom": cityFrom == null ? null : cityFrom,
        "cityCodeFrom": cityCodeFrom == null ? null : cityCodeFrom,
        "cityCodeTo": cityCodeTo == null ? null : cityCodeTo,
        "flyTo": flyTo == null ? null : flyTo,
        "flyFrom": flyFrom == null ? null : flyFrom,
        "airline": airline == null ? null : airline,
        "operating_carrier": operatingCarrier == null ? null : operatingCarrier,
        "equipment": equipment == null ? null : equipment,
        "latFrom": latFrom == null ? null : latFrom,
        "lngFrom": lngFrom == null ? null : lngFrom,
        "latTo": latTo == null ? null : latTo,
        "lngTo": lngTo == null ? null : lngTo,
        "flight_no": flightNo == null ? null : flightNo,
        "vehicle_type": vehicleType == null ? null : vehicleType,
        "operating_flight_no":
            operatingFlightNo == null ? null : operatingFlightNo,
        "following_technical_stop":
            followingTechnicalStop == null ? null : followingTechnicalStop,
      };
}

class SearchParams {
  final String flyFromType;
  final String toType;
  final Seats seats;

  SearchParams({
    this.flyFromType,
    this.toType,
    this.seats,
  });

  SearchParams copyWith({
    String flyFromType,
    String toType,
    Seats seats,
  }) =>
      SearchParams(
        flyFromType: flyFromType ?? this.flyFromType,
        toType: toType ?? this.toType,
        seats: seats ?? this.seats,
      );

  factory SearchParams.fromJson(Map<String, dynamic> json) => SearchParams(
        flyFromType: json["flyFrom_type"] == null ? null : json["flyFrom_type"],
        toType: json["to_type"] == null ? null : json["to_type"],
        seats: json["seats"] == null ? null : Seats.fromJson(json["seats"]),
      );

  Map<String, dynamic> toJson() => {
        "flyFrom_type": flyFromType == null ? null : flyFromType,
        "to_type": toType == null ? null : toType,
        "seats": seats == null ? null : seats.toJson(),
      };
}

class Seats {
  final int passengers;
  final int adults;
  final int children;
  final int infants;

  Seats({
    this.passengers,
    this.adults,
    this.children,
    this.infants,
  });

  Seats copyWith({
    int passengers,
    int adults,
    int children,
    int infants,
  }) =>
      Seats(
        passengers: passengers ?? this.passengers,
        adults: adults ?? this.adults,
        children: children ?? this.children,
        infants: infants ?? this.infants,
      );

  factory Seats.fromJson(Map<String, dynamic> json) => Seats(
        passengers: json["passengers"] == null ? null : json["passengers"],
        adults: json["adults"] == null ? null : json["adults"],
        children: json["children"] == null ? null : json["children"],
        infants: json["infants"] == null ? null : json["infants"],
      );

  Map<String, dynamic> toJson() => {
        "passengers": passengers == null ? null : passengers,
        "adults": adults == null ? null : adults,
        "children": children == null ? null : children,
        "infants": infants == null ? null : infants,
      };
}
