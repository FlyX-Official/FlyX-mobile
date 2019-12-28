// To parse this JSON data, do
//
//     final trip = tripFromJson(jsonString);

import 'dart:convert';

Trip tripFromJson(String str) => Trip.fromJson(json.decode(str));

String tripToJson(Trip data) => json.encode(data.toJson());

class Trip {
    String searchId;
    List<Datum> data;
    List<dynamic> connections;
    int time;
    String currency;
    double currencyRate;
    double fxRate;
    List<dynamic> refresh;
    double del;
    List<dynamic> refTasks;
    SearchParams searchParams;
    List<dynamic> allStopoverAirports;
    List<dynamic> allAirlines;

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

    factory Trip.fromJson(Map<String, dynamic> json) => Trip(
        searchId: json["search_id"] == null ? null : json["search_id"],
        data: json["data"] == null ? null : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        connections: json["connections"] == null ? null : List<dynamic>.from(json["connections"].map((x) => x)),
        time: json["time"] == null ? null : json["time"],
        currency: json["currency"] == null ? null : json["currency"],
        currencyRate: json["currency_rate"] == null ? null : json["currency_rate"].toDouble(),
        fxRate: json["fx_rate"] == null ? null : json["fx_rate"].toDouble(),
        refresh: json["refresh"] == null ? null : List<dynamic>.from(json["refresh"].map((x) => x)),
        del: json["del"] == null ? null : json["del"].toDouble(),
        refTasks: json["ref_tasks"] == null ? null : List<dynamic>.from(json["ref_tasks"].map((x) => x)),
        searchParams: json["search_params"] == null ? null : SearchParams.fromJson(json["search_params"]),
        allStopoverAirports: json["all_stopover_airports"] == null ? null : List<dynamic>.from(json["all_stopover_airports"].map((x) => x)),
        allAirlines: json["all_airlines"] == null ? null : List<dynamic>.from(json["all_airlines"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "search_id": searchId == null ? null : searchId,
        "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
        "connections": connections == null ? null : List<dynamic>.from(connections.map((x) => x)),
        "time": time == null ? null : time,
        "currency": currency == null ? null : currency,
        "currency_rate": currencyRate == null ? null : currencyRate,
        "fx_rate": fxRate == null ? null : fxRate,
        "refresh": refresh == null ? null : List<dynamic>.from(refresh.map((x) => x)),
        "del": del == null ? null : del,
        "ref_tasks": refTasks == null ? null : List<dynamic>.from(refTasks.map((x) => x)),
        "search_params": searchParams == null ? null : searchParams.toJson(),
        "all_stopover_airports": allStopoverAirports == null ? null : List<dynamic>.from(allStopoverAirports.map((x) => x)),
        "all_airlines": allAirlines == null ? null : List<dynamic>.from(allAirlines.map((x) => x)),
    };
}

class Datum {
    String id;
    Map<String, double> bagsPrice;
    Baglimit baglimit;
    int p1;
    int p2;
    int p3;
    int price;
    List<Route> route;
    List<String> airlines;
    int pnrCount;
    List<dynamic> transfers;
    bool hasAirportChange;
    Availability availability;
    int dTime;
    int dTimeUtc;
    int aTime;
    int aTimeUtc;
    int nightsInDest;
    String flyFrom;
    String flyTo;
    String cityFrom;
    String cityTo;
    Country countryFrom;
    Country countryTo;
    String mapIdfrom;
    String mapIdto;
    double distance;
    List<List<String>> routes;
    bool virtualInterlining;
    String flyDuration;
    Duration duration;
    String returnDuration;
    bool facilitatedBookingAvailable;
    List<String> typeFlights;
    List<String> foundOn;
    Conversion conversion;
    String bookingToken;
    double quality;
    String deepLink;

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
        this.availability,
        this.dTime,
        this.dTimeUtc,
        this.aTime,
        this.aTimeUtc,
        this.nightsInDest,
        this.flyFrom,
        this.flyTo,
        this.cityFrom,
        this.cityTo,
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
        this.typeFlights,
        this.foundOn,
        this.conversion,
        this.bookingToken,
        this.quality,
        this.deepLink,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"] == null ? null : json["id"],
        bagsPrice: json["bags_price"] == null ? null : Map.from(json["bags_price"]).map((k, v) => MapEntry<String, double>(k, v.toDouble())),
        baglimit: json["baglimit"] == null ? null : Baglimit.fromJson(json["baglimit"]),
        p1: json["p1"] == null ? null : json["p1"],
        p2: json["p2"] == null ? null : json["p2"],
        p3: json["p3"] == null ? null : json["p3"],
        price: json["price"] == null ? null : json["price"],
        route: json["route"] == null ? null : List<Route>.from(json["route"].map((x) => Route.fromJson(x))),
        airlines: json["airlines"] == null ? null : List<String>.from(json["airlines"].map((x) => x)),
        pnrCount: json["pnr_count"] == null ? null : json["pnr_count"],
        transfers: json["transfers"] == null ? null : List<dynamic>.from(json["transfers"].map((x) => x)),
        hasAirportChange: json["has_airport_change"] == null ? null : json["has_airport_change"],
        availability: json["availability"] == null ? null : Availability.fromJson(json["availability"]),
        dTime: json["dTime"] == null ? null : json["dTime"],
        dTimeUtc: json["dTimeUTC"] == null ? null : json["dTimeUTC"],
        aTime: json["aTime"] == null ? null : json["aTime"],
        aTimeUtc: json["aTimeUTC"] == null ? null : json["aTimeUTC"],
        nightsInDest: json["nightsInDest"] == null ? null : json["nightsInDest"],
        flyFrom: json["flyFrom"] == null ? null : json["flyFrom"],
        flyTo: json["flyTo"] == null ? null : json["flyTo"],
        cityFrom: json["cityFrom"] == null ? null : json["cityFrom"],
        cityTo: json["cityTo"] == null ? null : json["cityTo"],
        countryFrom: json["countryFrom"] == null ? null : Country.fromJson(json["countryFrom"]),
        countryTo: json["countryTo"] == null ? null : Country.fromJson(json["countryTo"]),
        mapIdfrom: json["mapIdfrom"] == null ? null : json["mapIdfrom"],
        mapIdto: json["mapIdto"] == null ? null : json["mapIdto"],
        distance: json["distance"] == null ? null : json["distance"].toDouble(),
        routes: json["routes"] == null ? null : List<List<String>>.from(json["routes"].map((x) => List<String>.from(x.map((x) => x)))),
        virtualInterlining: json["virtual_interlining"] == null ? null : json["virtual_interlining"],
        flyDuration: json["fly_duration"] == null ? null : json["fly_duration"],
        duration: json["duration"] == null ? null : Duration.fromJson(json["duration"]),
        returnDuration: json["return_duration"] == null ? null : json["return_duration"],
        facilitatedBookingAvailable: json["facilitated_booking_available"] == null ? null : json["facilitated_booking_available"],
        typeFlights: json["type_flights"] == null ? null : List<String>.from(json["type_flights"].map((x) => x)),
        foundOn: json["found_on"] == null ? null : List<String>.from(json["found_on"].map((x) => x)),
        conversion: json["conversion"] == null ? null : Conversion.fromJson(json["conversion"]),
        bookingToken: json["booking_token"] == null ? null : json["booking_token"],
        quality: json["quality"] == null ? null : json["quality"].toDouble(),
        deepLink: json["deep_link"] == null ? null : json["deep_link"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "bags_price": bagsPrice == null ? null : Map.from(bagsPrice).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "baglimit": baglimit == null ? null : baglimit.toJson(),
        "p1": p1 == null ? null : p1,
        "p2": p2 == null ? null : p2,
        "p3": p3 == null ? null : p3,
        "price": price == null ? null : price,
        "route": route == null ? null : List<dynamic>.from(route.map((x) => x.toJson())),
        "airlines": airlines == null ? null : List<dynamic>.from(airlines.map((x) => x)),
        "pnr_count": pnrCount == null ? null : pnrCount,
        "transfers": transfers == null ? null : List<dynamic>.from(transfers.map((x) => x)),
        "has_airport_change": hasAirportChange == null ? null : hasAirportChange,
        "availability": availability == null ? null : availability.toJson(),
        "dTime": dTime == null ? null : dTime,
        "dTimeUTC": dTimeUtc == null ? null : dTimeUtc,
        "aTime": aTime == null ? null : aTime,
        "aTimeUTC": aTimeUtc == null ? null : aTimeUtc,
        "nightsInDest": nightsInDest == null ? null : nightsInDest,
        "flyFrom": flyFrom == null ? null : flyFrom,
        "flyTo": flyTo == null ? null : flyTo,
        "cityFrom": cityFrom == null ? null : cityFrom,
        "cityTo": cityTo == null ? null : cityTo,
        "countryFrom": countryFrom == null ? null : countryFrom.toJson(),
        "countryTo": countryTo == null ? null : countryTo.toJson(),
        "mapIdfrom": mapIdfrom == null ? null : mapIdfrom,
        "mapIdto": mapIdto == null ? null : mapIdto,
        "distance": distance == null ? null : distance,
        "routes": routes == null ? null : List<dynamic>.from(routes.map((x) => List<dynamic>.from(x.map((x) => x)))),
        "virtual_interlining": virtualInterlining == null ? null : virtualInterlining,
        "fly_duration": flyDuration == null ? null : flyDuration,
        "duration": duration == null ? null : duration.toJson(),
        "return_duration": returnDuration == null ? null : returnDuration,
        "facilitated_booking_available": facilitatedBookingAvailable == null ? null : facilitatedBookingAvailable,
        "type_flights": typeFlights == null ? null : List<dynamic>.from(typeFlights.map((x) => x)),
        "found_on": foundOn == null ? null : List<dynamic>.from(foundOn.map((x) => x)),
        "conversion": conversion == null ? null : conversion.toJson(),
        "booking_token": bookingToken == null ? null : bookingToken,
        "quality": quality == null ? null : quality,
        "deep_link": deepLink == null ? null : deepLink,
    };
}

class Availability {
    int seats;

    Availability({
        this.seats,
    });

    factory Availability.fromJson(Map<String, dynamic> json) => Availability(
        seats: json["seats"] == null ? null : json["seats"],
    );

    Map<String, dynamic> toJson() => {
        "seats": seats == null ? null : seats,
    };
}

class Baglimit {
    int handWidth;
    int handHeight;
    int handLength;
    int handWeight;
    int holdWidth;
    int holdHeight;
    int holdLength;
    int holdDimensionsSum;
    int holdWeight;

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

    factory Baglimit.fromJson(Map<String, dynamic> json) => Baglimit(
        handWidth: json["hand_width"] == null ? null : json["hand_width"],
        handHeight: json["hand_height"] == null ? null : json["hand_height"],
        handLength: json["hand_length"] == null ? null : json["hand_length"],
        handWeight: json["hand_weight"] == null ? null : json["hand_weight"],
        holdWidth: json["hold_width"] == null ? null : json["hold_width"],
        holdHeight: json["hold_height"] == null ? null : json["hold_height"],
        holdLength: json["hold_length"] == null ? null : json["hold_length"],
        holdDimensionsSum: json["hold_dimensions_sum"] == null ? null : json["hold_dimensions_sum"],
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
        "hold_dimensions_sum": holdDimensionsSum == null ? null : holdDimensionsSum,
        "hold_weight": holdWeight == null ? null : holdWeight,
    };
}

class Conversion {
    int usd;
    int eur;

    Conversion({
        this.usd,
        this.eur,
    });

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
    String code;
    String name;

    Country({
        this.code,
        this.name,
    });

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
    int departure;
    int durationReturn;
    int total;

    Duration({
        this.departure,
        this.durationReturn,
        this.total,
    });

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
    String id;
    String combinationId;
    int routeReturn;
    int originalReturn;
    String source;
    String foundOn;
    int price;
    int aTime;
    int dTime;
    int aTimeUtc;
    int dTimeUtc;
    String mapIdfrom;
    String mapIdto;
    String cityTo;
    String cityFrom;
    String flyTo;
    String airline;
    String operatingCarrier;
    dynamic equipment;
    String flyFrom;
    double latFrom;
    double lngFrom;
    double latTo;
    double lngTo;
    int flightNo;
    String vehicleType;
    int refreshTimestamp;
    bool bagsRecheckRequired;
    bool guarantee;
    String fareClasses;
    String fareBasis;
    String fareFamily;
    String fareCategory;
    int lastSeen;
    String operatingFlightNo;
    String stationFrom;
    String stationTo;

    Route({
        this.id,
        this.combinationId,
        this.routeReturn,
        this.originalReturn,
        this.source,
        this.foundOn,
        this.price,
        this.aTime,
        this.dTime,
        this.aTimeUtc,
        this.dTimeUtc,
        this.mapIdfrom,
        this.mapIdto,
        this.cityTo,
        this.cityFrom,
        this.flyTo,
        this.airline,
        this.operatingCarrier,
        this.equipment,
        this.flyFrom,
        this.latFrom,
        this.lngFrom,
        this.latTo,
        this.lngTo,
        this.flightNo,
        this.vehicleType,
        this.refreshTimestamp,
        this.bagsRecheckRequired,
        this.guarantee,
        this.fareClasses,
        this.fareBasis,
        this.fareFamily,
        this.fareCategory,
        this.lastSeen,
        this.operatingFlightNo,
        this.stationFrom,
        this.stationTo,
    });

    factory Route.fromJson(Map<String, dynamic> json) => Route(
        id: json["id"] == null ? null : json["id"],
        combinationId: json["combination_id"] == null ? null : json["combination_id"],
        routeReturn: json["return"] == null ? null : json["return"],
        originalReturn: json["original_return"] == null ? null : json["original_return"],
        source: json["source"] == null ? null : json["source"],
        foundOn: json["found_on"] == null ? null : json["found_on"],
        price: json["price"] == null ? null : json["price"],
        aTime: json["aTime"] == null ? null : json["aTime"],
        dTime: json["dTime"] == null ? null : json["dTime"],
        aTimeUtc: json["aTimeUTC"] == null ? null : json["aTimeUTC"],
        dTimeUtc: json["dTimeUTC"] == null ? null : json["dTimeUTC"],
        mapIdfrom: json["mapIdfrom"] == null ? null : json["mapIdfrom"],
        mapIdto: json["mapIdto"] == null ? null : json["mapIdto"],
        cityTo: json["cityTo"] == null ? null : json["cityTo"],
        cityFrom: json["cityFrom"] == null ? null : json["cityFrom"],
        flyTo: json["flyTo"] == null ? null : json["flyTo"],
        airline: json["airline"] == null ? null : json["airline"],
        operatingCarrier: json["operating_carrier"] == null ? null : json["operating_carrier"],
        equipment: json["equipment"],
        flyFrom: json["flyFrom"] == null ? null : json["flyFrom"],
        latFrom: json["latFrom"] == null ? null : json["latFrom"].toDouble(),
        lngFrom: json["lngFrom"] == null ? null : json["lngFrom"].toDouble(),
        latTo: json["latTo"] == null ? null : json["latTo"].toDouble(),
        lngTo: json["lngTo"] == null ? null : json["lngTo"].toDouble(),
        flightNo: json["flight_no"] == null ? null : json["flight_no"],
        vehicleType: json["vehicle_type"] == null ? null : json["vehicle_type"],
        refreshTimestamp: json["refresh_timestamp"] == null ? null : json["refresh_timestamp"],
        bagsRecheckRequired: json["bags_recheck_required"] == null ? null : json["bags_recheck_required"],
        guarantee: json["guarantee"] == null ? null : json["guarantee"],
        fareClasses: json["fare_classes"] == null ? null : json["fare_classes"],
        fareBasis: json["fare_basis"] == null ? null : json["fare_basis"],
        fareFamily: json["fare_family"] == null ? null : json["fare_family"],
        fareCategory: json["fare_category"] == null ? null : json["fare_category"],
        lastSeen: json["last_seen"] == null ? null : json["last_seen"],
        operatingFlightNo: json["operating_flight_no"] == null ? null : json["operating_flight_no"],
        stationFrom: json["stationFrom"] == null ? null : json["stationFrom"],
        stationTo: json["stationTo"] == null ? null : json["stationTo"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "combination_id": combinationId == null ? null : combinationId,
        "return": routeReturn == null ? null : routeReturn,
        "original_return": originalReturn == null ? null : originalReturn,
        "source": source == null ? null : source,
        "found_on": foundOn == null ? null : foundOn,
        "price": price == null ? null : price,
        "aTime": aTime == null ? null : aTime,
        "dTime": dTime == null ? null : dTime,
        "aTimeUTC": aTimeUtc == null ? null : aTimeUtc,
        "dTimeUTC": dTimeUtc == null ? null : dTimeUtc,
        "mapIdfrom": mapIdfrom == null ? null : mapIdfrom,
        "mapIdto": mapIdto == null ? null : mapIdto,
        "cityTo": cityTo == null ? null : cityTo,
        "cityFrom": cityFrom == null ? null : cityFrom,
        "flyTo": flyTo == null ? null : flyTo,
        "airline": airline == null ? null : airline,
        "operating_carrier": operatingCarrier == null ? null : operatingCarrier,
        "equipment": equipment,
        "flyFrom": flyFrom == null ? null : flyFrom,
        "latFrom": latFrom == null ? null : latFrom,
        "lngFrom": lngFrom == null ? null : lngFrom,
        "latTo": latTo == null ? null : latTo,
        "lngTo": lngTo == null ? null : lngTo,
        "flight_no": flightNo == null ? null : flightNo,
        "vehicle_type": vehicleType == null ? null : vehicleType,
        "refresh_timestamp": refreshTimestamp == null ? null : refreshTimestamp,
        "bags_recheck_required": bagsRecheckRequired == null ? null : bagsRecheckRequired,
        "guarantee": guarantee == null ? null : guarantee,
        "fare_classes": fareClasses == null ? null : fareClasses,
        "fare_basis": fareBasis == null ? null : fareBasis,
        "fare_family": fareFamily == null ? null : fareFamily,
        "fare_category": fareCategory == null ? null : fareCategory,
        "last_seen": lastSeen == null ? null : lastSeen,
        "operating_flight_no": operatingFlightNo == null ? null : operatingFlightNo,
        "stationFrom": stationFrom == null ? null : stationFrom,
        "stationTo": stationTo == null ? null : stationTo,
    };
}

class SearchParams {
    String flyFromType;
    String toType;
    Seats seats;

    SearchParams({
        this.flyFromType,
        this.toType,
        this.seats,
    });

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
    int passengers;
    int adults;
    int children;
    int infants;

    Seats({
        this.passengers,
        this.adults,
        this.children,
        this.infants,
    });

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
