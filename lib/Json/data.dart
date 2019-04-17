// To parse this JSON data, do
//
//     final data = dataFromJson(jsonString);

import 'dart:convert';

Data dataFromJson(String str) {
    final jsonData = json.decode(str);
    return Data.fromJson(jsonData);
}

String dataToJson(Data data) {
    final dyn = data.toJson();
    return json.encode(dyn);
}

class Data {
    Tickets tickets;

    Data({
        this.tickets,
    });

    factory Data.fromJson(Map<String, dynamic> json) => new Data(
        tickets: json["tickets"] == null ? null : Tickets.fromJson(json["tickets"]),
    );

    Map<String, dynamic> toJson() => {
        "tickets": tickets == null ? null : tickets.toJson(),
    };
}

class Tickets {
    List<dynamic> refTasks;
    SearchParams searchParams;
    double currencyRate;
    List<dynamic> refresh;
    List<dynamic> connections;
    String currency;
    int results;
    double del;
    List<dynamic> allAirlines;
    int time;
    List<dynamic> allStopoverAirports;
    List<Datum> data;
    String searchId;

    Tickets({
        this.refTasks,
        this.searchParams,
        this.currencyRate,
        this.refresh,
        this.connections,
        this.currency,
        this.results,
        this.del,
        this.allAirlines,
        this.time,
        this.allStopoverAirports,
        this.data,
        this.searchId,
    });

    factory Tickets.fromJson(Map<String, dynamic> json) => new Tickets(
        refTasks: json["ref_tasks"] == null ? null : new List<dynamic>.from(json["ref_tasks"].map((x) => x)),
        searchParams: json["search_params"] == null ? null : SearchParams.fromJson(json["search_params"]),
        currencyRate: json["currency_rate"] == null ? null : json["currency_rate"].toDouble(),
        refresh: json["refresh"] == null ? null : new List<dynamic>.from(json["refresh"].map((x) => x)),
        connections: json["connections"] == null ? null : new List<dynamic>.from(json["connections"].map((x) => x)),
        currency: json["currency"] == null ? null : json["currency"],
        results: json["_results"] == null ? null : json["_results"],
        del: json["del"] == null ? null : json["del"].toDouble(),
        allAirlines: json["all_airlines"] == null ? null : new List<dynamic>.from(json["all_airlines"].map((x) => x)),
        time: json["time"] == null ? null : json["time"],
        allStopoverAirports: json["all_stopover_airports"] == null ? null : new List<dynamic>.from(json["all_stopover_airports"].map((x) => x)),
        data: json["data"] == null ? null : new List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        searchId: json["search_id"] == null ? null : json["search_id"],
    );

    Map<String, dynamic> toJson() => {
        "ref_tasks": refTasks == null ? null : new List<dynamic>.from(refTasks.map((x) => x)),
        "search_params": searchParams == null ? null : searchParams.toJson(),
        "currency_rate": currencyRate == null ? null : currencyRate,
        "refresh": refresh == null ? null : new List<dynamic>.from(refresh.map((x) => x)),
        "connections": connections == null ? null : new List<dynamic>.from(connections.map((x) => x)),
        "currency": currency == null ? null : currency,
        "_results": results == null ? null : results,
        "del": del == null ? null : del,
        "all_airlines": allAirlines == null ? null : new List<dynamic>.from(allAirlines.map((x) => x)),
        "time": time == null ? null : time,
        "all_stopover_airports": allStopoverAirports == null ? null : new List<dynamic>.from(allStopoverAirports.map((x) => x)),
        "data": data == null ? null : new List<dynamic>.from(data.map((x) => x.toJson())),
        "search_id": searchId == null ? null : searchId,
    };
}

class Datum {
    ReturnDuration returnDuration;
    double quality;
    FlyFrom flyTo;
    String deepLink;
    MapIdto mapIdto;
    int nightsInDest;
    List<String> airlines;
    int pnrCount;
    String flyDuration;
    Bag baglimit;
    bool hasAirportChange;
    double distance;
    List<String> typeFlights;
    Bag bagsPrice;
    FlyFrom flyFrom;
    int dTimeUtc;
    int p2;
    int p3;
    int p1;
    int dTime;
    List<FoundOn> foundOn;
    CityFrom cityFrom;
    MapIdfrom mapIdfrom;
    String bookingToken;
    TripDuration duration;
    String id;
    Conversion conversion;
    Country countryTo;
    int aTimeUtc;
    int price;
    List<List<FlyFrom>> routes;
    CityTo cityTo;
    List<dynamic> transfers;
    List<Route> route;
    bool facilitatedBookingAvailable;
    int aTime;
    Country countryFrom;

    Datum({
        this.returnDuration,
        this.quality,
        this.flyTo,
        this.deepLink,
        this.mapIdto,
        this.nightsInDest,
        this.airlines,
        this.pnrCount,
        this.flyDuration,
        this.baglimit,
        this.hasAirportChange,
        this.distance,
        this.typeFlights,
        this.bagsPrice,
        this.flyFrom,
        this.dTimeUtc,
        this.p2,
        this.p3,
        this.p1,
        this.dTime,
        this.foundOn,
        this.cityFrom,
        this.mapIdfrom,
        this.bookingToken,
        this.duration,
        this.id,
        this.conversion,
        this.countryTo,
        this.aTimeUtc,
        this.price,
        this.routes,
        this.cityTo,
        this.transfers,
        this.route,
        this.facilitatedBookingAvailable,
        this.aTime,
        this.countryFrom,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => new Datum(
        returnDuration: json["return_duration"] == null ? null : returnDurationValues.map[json["return_duration"]],
        quality: json["quality"] == null ? null : json["quality"].toDouble(),
        flyTo: json["flyTo"] == null ? null : flyFromValues.map[json["flyTo"]],
        deepLink: json["deep_link"] == null ? null : json["deep_link"],
        mapIdto: json["mapIdto"] == null ? null : mapIdtoValues.map[json["mapIdto"]],
        nightsInDest: json["nightsInDest"] == null ? null : json["nightsInDest"],
        airlines: json["airlines"] == null ? null : new List<String>.from(json["airlines"].map((x) => x)),
        pnrCount: json["pnr_count"] == null ? null : json["pnr_count"],
        flyDuration: json["fly_duration"] == null ? null : json["fly_duration"],
        baglimit: json["baglimit"] == null ? null : Bag.fromJson(json["baglimit"]),
        hasAirportChange: json["has_airport_change"] == null ? null : json["has_airport_change"],
        distance: json["distance"] == null ? null : json["distance"].toDouble(),
        typeFlights: json["type_flights"] == null ? null : new List<String>.from(json["type_flights"].map((x) => x)),
        bagsPrice: json["bags_price"] == null ? null : Bag.fromJson(json["bags_price"]),
        flyFrom: json["flyFrom"] == null ? null : flyFromValues.map[json["flyFrom"]],
        dTimeUtc: json["dTimeUTC"] == null ? null : json["dTimeUTC"],
        p2: json["p2"] == null ? null : json["p2"],
        p3: json["p3"] == null ? null : json["p3"],
        p1: json["p1"] == null ? null : json["p1"],
        dTime: json["dTime"] == null ? null : json["dTime"],
        foundOn: json["found_on"] == null ? null : new List<FoundOn>.from(json["found_on"].map((x) => foundOnValues.map[x])),
        cityFrom: json["cityFrom"] == null ? null : cityFromValues.map[json["cityFrom"]],
        mapIdfrom: json["mapIdfrom"] == null ? null : mapIdfromValues.map[json["mapIdfrom"]],
        bookingToken: json["booking_token"] == null ? null : json["booking_token"],
        duration: json["duration"] == null ? null : TripDuration.fromJson(json["duration"]),
        id: json["id"] == null ? null : json["id"],
        conversion: json["conversion"] == null ? null : Conversion.fromJson(json["conversion"]),
        countryTo: json["countryTo"] == null ? null : Country.fromJson(json["countryTo"]),
        aTimeUtc: json["aTimeUTC"] == null ? null : json["aTimeUTC"],
        price: json["price"] == null ? null : json["price"],
        routes: json["routes"] == null ? null : new List<List<FlyFrom>>.from(json["routes"].map((x) => new List<FlyFrom>.from(x.map((x) => flyFromValues.map[x])))),
        cityTo: json["cityTo"] == null ? null : cityToValues.map[json["cityTo"]],
        transfers: json["transfers"] == null ? null : new List<dynamic>.from(json["transfers"].map((x) => x)),
        route: json["route"] == null ? null : new List<Route>.from(json["route"].map((x) => Route.fromJson(x))),
        facilitatedBookingAvailable: json["facilitated_booking_available"] == null ? null : json["facilitated_booking_available"],
        aTime: json["aTime"] == null ? null : json["aTime"],
        countryFrom: json["countryFrom"] == null ? null : Country.fromJson(json["countryFrom"]),
    );

    Map<String, dynamic> toJson() => {
        "return_duration": returnDuration == null ? null : returnDurationValues.reverse[returnDuration],
        "quality": quality == null ? null : quality,
        "flyTo": flyTo == null ? null : flyFromValues.reverse[flyTo],
        "deep_link": deepLink == null ? null : deepLink,
        "mapIdto": mapIdto == null ? null : mapIdtoValues.reverse[mapIdto],
        "nightsInDest": nightsInDest == null ? null : nightsInDest,
        "airlines": airlines == null ? null : new List<dynamic>.from(airlines.map((x) => x)),
        "pnr_count": pnrCount == null ? null : pnrCount,
        "fly_duration": flyDuration == null ? null : flyDuration,
        "baglimit": baglimit == null ? null : baglimit.toJson(),
        "has_airport_change": hasAirportChange == null ? null : hasAirportChange,
        "distance": distance == null ? null : distance,
        "type_flights": typeFlights == null ? null : new List<dynamic>.from(typeFlights.map((x) => x)),
        "bags_price": bagsPrice == null ? null : bagsPrice.toJson(),
        "flyFrom": flyFrom == null ? null : flyFromValues.reverse[flyFrom],
        "dTimeUTC": dTimeUtc == null ? null : dTimeUtc,
        "p2": p2 == null ? null : p2,
        "p3": p3 == null ? null : p3,
        "p1": p1 == null ? null : p1,
        "dTime": dTime == null ? null : dTime,
        "found_on": foundOn == null ? null : new List<dynamic>.from(foundOn.map((x) => foundOnValues.reverse[x])),
        "cityFrom": cityFrom == null ? null : cityFromValues.reverse[cityFrom],
        "mapIdfrom": mapIdfrom == null ? null : mapIdfromValues.reverse[mapIdfrom],
        "booking_token": bookingToken == null ? null : bookingToken,
        "duration": duration == null ? null : duration.toJson(),
        "id": id == null ? null : id,
        "conversion": conversion == null ? null : conversion.toJson(),
        "countryTo": countryTo == null ? null : countryTo.toJson(),
        "aTimeUTC": aTimeUtc == null ? null : aTimeUtc,
        "price": price == null ? null : price,
        "routes": routes == null ? null : new List<dynamic>.from(routes.map((x) => new List<dynamic>.from(x.map((x) => flyFromValues.reverse[x])))),
        "cityTo": cityTo == null ? null : cityToValues.reverse[cityTo],
        "transfers": transfers == null ? null : new List<dynamic>.from(transfers.map((x) => x)),
        "route": route == null ? null : new List<dynamic>.from(route.map((x) => x.toJson())),
        "facilitated_booking_available": facilitatedBookingAvailable == null ? null : facilitatedBookingAvailable,
        "aTime": aTime == null ? null : aTime,
        "countryFrom": countryFrom == null ? null : countryFrom.toJson(),
    };
}

class Bag {
    Bag();

    factory Bag.fromJson(Map<String, dynamic> json) => new Bag(
    );

    Map<String, dynamic> toJson() => {
    };
}

enum CityFrom { HYDERABAD }

final cityFromValues = new EnumValues({
    "Hyderabad": CityFrom.HYDERABAD
});

enum CityTo { FRESNO }

final cityToValues = new EnumValues({
    "Fresno": CityTo.FRESNO
});

class Conversion {
    int usd;
    int eur;

    Conversion({
        this.usd,
        this.eur,
    });

    factory Conversion.fromJson(Map<String, dynamic> json) => new Conversion(
        usd: json["USD"] == null ? null : json["USD"],
        eur: json["EUR"] == null ? null : json["EUR"],
    );

    Map<String, dynamic> toJson() => {
        "USD": usd == null ? null : usd,
        "EUR": eur == null ? null : eur,
    };
}

class Country {
    Code code;
    Name name;

    Country({
        this.code,
        this.name,
    });

    factory Country.fromJson(Map<String, dynamic> json) => new Country(
        code: json["code"] == null ? null : codeValues.map[json["code"]],
        name: json["name"] == null ? null : nameValues.map[json["name"]],
    );

    Map<String, dynamic> toJson() => {
        "code": code == null ? null : codeValues.reverse[code],
        "name": name == null ? null : nameValues.reverse[name],
    };
}

enum Code { IN, US }

final codeValues = new EnumValues({
    "IN": Code.IN,
    "US": Code.US
});

enum Name { INDIA, UNITED_STATES }

final nameValues = new EnumValues({
    "India": Name.INDIA,
    "United States": Name.UNITED_STATES
});

class TripDuration {
    int total;
    int durationReturn;
    int departure;

    TripDuration({
        this.total,
        this.durationReturn,
        this.departure,
    });

    factory TripDuration.fromJson(Map<String, dynamic> json) => new TripDuration(
        total: json["total"] == null ? null : json["total"],
        durationReturn: json["return"] == null ? null : json["return"],
        departure: json["departure"] == null ? null : json["departure"],
    );

    Map<String, dynamic> toJson() => {
        "total": total == null ? null : total,
        "return": durationReturn == null ? null : durationReturn,
        "departure": departure == null ? null : departure,
    };
}

enum FlyFrom { HYD, FAT }

final flyFromValues = new EnumValues({
    "FAT": FlyFrom.FAT,
    "HYD": FlyFrom.HYD
});

enum FoundOn { DEPRECATED }

final foundOnValues = new EnumValues({
    "deprecated": FoundOn.DEPRECATED
});

enum MapIdfrom { HYDERABAD }

final mapIdfromValues = new EnumValues({
    "hyderabad": MapIdfrom.HYDERABAD
});

enum MapIdto { FRESNO }

final mapIdtoValues = new EnumValues({
    "fresno": MapIdto.FRESNO
});

enum ReturnDuration { THE_52_H_27_M, THE_39_H_44_M }

final returnDurationValues = new EnumValues({
    "39h 44m": ReturnDuration.THE_39_H_44_M,
    "52h 27m": ReturnDuration.THE_52_H_27_M
});

class Route {
    int aTimeUtc;
    int refreshTimestamp;
    bool bagsRecheckRequired;
    int routeReturn;
    double latTo;
    int flightNo;
    int price;
    int originalReturn;
    String operatingCarrier;
    String cityTo;
    String mapIdfrom;
    double lngFrom;
    VehicleType vehicleType;
    String flyFrom;
    String id;
    int dTimeUtc;
    String equipment;
    String mapIdto;
    String combinationId;
    int dTime;
    String fareFamily;
    FoundOn foundOn;
    String flyTo;
    FoundOn source;
    double latFrom;
    String airline;
    String fareClasses;
    double lngTo;
    String cityFrom;
    int lastSeen;
    int aTime;
    bool guarantee;
    String fareBasis;

    Route({
        this.aTimeUtc,
        this.refreshTimestamp,
        this.bagsRecheckRequired,
        this.routeReturn,
        this.latTo,
        this.flightNo,
        this.price,
        this.originalReturn,
        this.operatingCarrier,
        this.cityTo,
        this.mapIdfrom,
        this.lngFrom,
        this.vehicleType,
        this.flyFrom,
        this.id,
        this.dTimeUtc,
        this.equipment,
        this.mapIdto,
        this.combinationId,
        this.dTime,
        this.fareFamily,
        this.foundOn,
        this.flyTo,
        this.source,
        this.latFrom,
        this.airline,
        this.fareClasses,
        this.lngTo,
        this.cityFrom,
        this.lastSeen,
        this.aTime,
        this.guarantee,
        this.fareBasis,
    });

    factory Route.fromJson(Map<String, dynamic> json) => new Route(
        aTimeUtc: json["aTimeUTC"] == null ? null : json["aTimeUTC"],
        refreshTimestamp: json["refresh_timestamp"] == null ? null : json["refresh_timestamp"],
        bagsRecheckRequired: json["bags_recheck_required"] == null ? null : json["bags_recheck_required"],
        routeReturn: json["return"] == null ? null : json["return"],
        latTo: json["latTo"] == null ? null : json["latTo"].toDouble(),
        flightNo: json["flight_no"] == null ? null : json["flight_no"],
        price: json["price"] == null ? null : json["price"],
        originalReturn: json["original_return"] == null ? null : json["original_return"],
        operatingCarrier: json["operating_carrier"] == null ? null : json["operating_carrier"],
        cityTo: json["cityTo"] == null ? null : json["cityTo"],
        mapIdfrom: json["mapIdfrom"] == null ? null : json["mapIdfrom"],
        lngFrom: json["lngFrom"] == null ? null : json["lngFrom"].toDouble(),
        vehicleType: json["vehicle_type"] == null ? null : vehicleTypeValues.map[json["vehicle_type"]],
        flyFrom: json["flyFrom"] == null ? null : json["flyFrom"],
        id: json["id"] == null ? null : json["id"],
        dTimeUtc: json["dTimeUTC"] == null ? null : json["dTimeUTC"],
        equipment: json["equipment"] == null ? null : json["equipment"],
        mapIdto: json["mapIdto"] == null ? null : json["mapIdto"],
        combinationId: json["combination_id"] == null ? null : json["combination_id"],
        dTime: json["dTime"] == null ? null : json["dTime"],
        fareFamily: json["fare_family"] == null ? null : json["fare_family"],
        foundOn: json["found_on"] == null ? null : foundOnValues.map[json["found_on"]],
        flyTo: json["flyTo"] == null ? null : json["flyTo"],
        source: json["source"] == null ? null : foundOnValues.map[json["source"]],
        latFrom: json["latFrom"] == null ? null : json["latFrom"].toDouble(),
        airline: json["airline"] == null ? null : json["airline"],
        fareClasses: json["fare_classes"] == null ? null : json["fare_classes"],
        lngTo: json["lngTo"] == null ? null : json["lngTo"].toDouble(),
        cityFrom: json["cityFrom"] == null ? null : json["cityFrom"],
        lastSeen: json["last_seen"] == null ? null : json["last_seen"],
        aTime: json["aTime"] == null ? null : json["aTime"],
        guarantee: json["guarantee"] == null ? null : json["guarantee"],
        fareBasis: json["fare_basis"] == null ? null : json["fare_basis"],
    );

    Map<String, dynamic> toJson() => {
        "aTimeUTC": aTimeUtc == null ? null : aTimeUtc,
        "refresh_timestamp": refreshTimestamp == null ? null : refreshTimestamp,
        "bags_recheck_required": bagsRecheckRequired == null ? null : bagsRecheckRequired,
        "return": routeReturn == null ? null : routeReturn,
        "latTo": latTo == null ? null : latTo,
        "flight_no": flightNo == null ? null : flightNo,
        "price": price == null ? null : price,
        "original_return": originalReturn == null ? null : originalReturn,
        "operating_carrier": operatingCarrier == null ? null : operatingCarrier,
        "cityTo": cityTo == null ? null : cityTo,
        "mapIdfrom": mapIdfrom == null ? null : mapIdfrom,
        "lngFrom": lngFrom == null ? null : lngFrom,
        "vehicle_type": vehicleType == null ? null : vehicleTypeValues.reverse[vehicleType],
        "flyFrom": flyFrom == null ? null : flyFrom,
        "id": id == null ? null : id,
        "dTimeUTC": dTimeUtc == null ? null : dTimeUtc,
        "equipment": equipment == null ? null : equipment,
        "mapIdto": mapIdto == null ? null : mapIdto,
        "combination_id": combinationId == null ? null : combinationId,
        "dTime": dTime == null ? null : dTime,
        "fare_family": fareFamily == null ? null : fareFamily,
        "found_on": foundOn == null ? null : foundOnValues.reverse[foundOn],
        "flyTo": flyTo == null ? null : flyTo,
        "source": source == null ? null : foundOnValues.reverse[source],
        "latFrom": latFrom == null ? null : latFrom,
        "airline": airline == null ? null : airline,
        "fare_classes": fareClasses == null ? null : fareClasses,
        "lngTo": lngTo == null ? null : lngTo,
        "cityFrom": cityFrom == null ? null : cityFrom,
        "last_seen": lastSeen == null ? null : lastSeen,
        "aTime": aTime == null ? null : aTime,
        "guarantee": guarantee == null ? null : guarantee,
        "fare_basis": fareBasis == null ? null : fareBasis,
    };
}

enum VehicleType { AIRCRAFT }

final vehicleTypeValues = new EnumValues({
    "aircraft": VehicleType.AIRCRAFT
});

class SearchParams {
    String toType;
    String flyFromType;
    Seats seats;

    SearchParams({
        this.toType,
        this.flyFromType,
        this.seats,
    });

    factory SearchParams.fromJson(Map<String, dynamic> json) => new SearchParams(
        toType: json["to_type"] == null ? null : json["to_type"],
        flyFromType: json["flyFrom_type"] == null ? null : json["flyFrom_type"],
        seats: json["seats"] == null ? null : Seats.fromJson(json["seats"]),
    );

    Map<String, dynamic> toJson() => {
        "to_type": toType == null ? null : toType,
        "flyFrom_type": flyFromType == null ? null : flyFromType,
        "seats": seats == null ? null : seats.toJson(),
    };
}

class Seats {
    int infants;
    int passengers;
    int adults;
    int children;

    Seats({
        this.infants,
        this.passengers,
        this.adults,
        this.children,
    });

    factory Seats.fromJson(Map<String, dynamic> json) => new Seats(
        infants: json["infants"] == null ? null : json["infants"],
        passengers: json["passengers"] == null ? null : json["passengers"],
        adults: json["adults"] == null ? null : json["adults"],
        children: json["children"] == null ? null : json["children"],
    );

    Map<String, dynamic> toJson() => {
        "infants": infants == null ? null : infants,
        "passengers": passengers == null ? null : passengers,
        "adults": adults == null ? null : adults,
        "children": children == null ? null : children,
    };
}

class EnumValues<T> {
    Map<String, T> map;
    Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        if (reverseMap == null) {
            reverseMap = map.map((k, v) => new MapEntry(v, k));
        }
        return reverseMap;
    }
}
