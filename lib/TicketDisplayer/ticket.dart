import 'dart:async';
class Ticket {
  final List<Object> tickets;
  final Object data;
  final String from;
  final String to;
  final double pennyPrice;
  final double duration;
  final String departure;
  final String arrival;
  final String key;
  final List<Object> legs;
  final String color;
  final String sourceLocation;
  final String destLocation;

  Ticket(
      {this.tickets,
      this.data,
      this.from,
      this.to,
      this.pennyPrice,
      this.duration,
      this.departure,
      this.arrival,
      this.key,
      this.legs,
      this.color,
      this.sourceLocation,
      this.destLocation});

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      tickets: json['tickets'] as Object,
      data: json['data'],
      from: json["from"],
      to: json["to"],
      pennyPrice: json["pennyPrice"] as double,
      duration: json["duration"] as double,
      departure: json["departure"],
      arrival: json["arrival"],
      key: json["key"],
      legs: json["legs"] as Object,
      color: json["color"],
      sourceLocation: json["sourceLocation"],
      destLocation: json["destLocation"],
    );
  }
}
