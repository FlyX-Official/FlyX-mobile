import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class UserQuery with ChangeNotifier {
  // GoogleMapController myMapController;

  // Circle _circle;
  // Map<CircleId, Circle> _circles = <CircleId, Circle>{};
  String _departureCityIata,
      _destinationCityIata,
      _departureDate,
      _returnDate,
      _departureCityGeoHash,
      _destinationCityGeohash,
      _sortFilter;

  bool _isOneWay = true, _isOrigin;
  // Marker _marker;
  // Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  double _originRadius = 0,
      _destinationRadius = 0,
      _departureCityLat,
      _destinationCityLat,
      _departureCityLong,
      _destinationCityLong;

  // Polyline _polyline;
  // Map<PolylineId, Polyline> _polylines = <PolylineId, Polyline>{};
  List<DateTime> _departureDateRange, _returnDateRange;
  // CircleId _selectedCircle;
  // MarkerId _selectedMarker;
  // PolylineId _selectedPolyline;

  bool get isOneWay => _isOneWay;

  bool get isOrigin => _isOrigin;

  // Marker get marker => _marker;

  // Circle get circle => _circle;

  // Polyline get poliline => _polyline;

  // MarkerId get selectedMarker => _selectedMarker;

  // CircleId get selectedCircle => _selectedCircle;

  // PolylineId get selectedPolyline => _selectedPolyline;

  // Map<MarkerId, Marker> get markers => _markers;

  // Map<PolylineId, Polyline> get polylines => _polylines;

  // Map<CircleId, Circle> get circles => _circles;

  double get departureCityLat => _departureCityLat;

  double get departureCityLong => _departureCityLong;

  double get destinationCityLat => _destinationCityLat;

  double get destinationCityLong => _destinationCityLong;

  double get originRadius => _originRadius;

  double get destinationRadius => _destinationRadius;

  String get departureCityIata => _departureCityIata;

  String get destinationCityIata => _destinationCityIata;

  String get departureDate => _departureDate;

  String get returnDate => _returnDate;

  String get departureCityGeoHash => _departureCityGeoHash;

  String get destinationCityGeoHash => _destinationCityGeohash;

  String get sortFilter => _sortFilter;

  List<DateTime> get departureDateRange => _departureDateRange;

  List<DateTime> get returnDateRange => _returnDateRange;

  void setOneWay(bool x) {
    _isOneWay = x;
    notifyListeners();
  }

  void setSortFilter(String x) {
    _sortFilter = x;
    notifyListeners();
  }

  void setIsOrigin(bool x) {
    _isOrigin = x;
    notifyListeners();
  }

  void setDepartureIata(String x) {
    _departureCityIata = x;
    notifyListeners();
  }

  void setDestinationIata(String x) {
    _destinationCityIata = x;
    notifyListeners();
  }

  void setOriginRadius(double x) {
    _originRadius = x;
    notifyListeners();
    // addOriginRaduisCircle();
  }

  void setDestinationRadius(double x) {
    _destinationRadius = x;
    notifyListeners();
    // addDestinationRaduisCircle();
  }

  void setDepartureDateRange(List<DateTime> x) {
    _departureDateRange = x;
    notifyListeners();

    if (x.first == x.last) {
      _departureDate = DateFormat.MMMd().format(x.first).toString();
      notifyListeners();
    } else {
      _departureDate = DateFormat.MMMd().format(x.first).toString() +
          ' - ' +
          DateFormat.MMMd().format(x.last).toString();
      notifyListeners();
    }
  }

  void setReturnDateRange(List<DateTime> x) {
    _returnDateRange = x;
    notifyListeners();

    if (x.first == x.last) {
      _returnDate = DateFormat.MMMd().format(x.first).toString();
      notifyListeners();
    } else {
      _returnDate = DateFormat.MMMd().format(x.first).toString() +
          ' - ' +
          DateFormat.MMMd().format(x.last).toString();
      notifyListeners();
    }
  }

  void setDepartureCityLat(double x) {
    _departureCityLat = x;
    notifyListeners();
  }

  void setDepartureCityLong(double x) {
    _departureCityLong = x;
    notifyListeners();

    // _addPolyLine();

    // _addDepartureAirtportMarkers();
    // _updateGoogleMapCamera(
    //   LatLng(_departureCityLat, _departureCityLong),
    // );
  }

  void setDestinationCityLat(double x) {
    _destinationCityLat = x;
    notifyListeners();
  }

  void setDestinationCityLong(double x) {
    _destinationCityLong = x;
    notifyListeners();
    // _addPolyLine();

    // _addDestinationAirportMarkers();
    // _updateGoogleMapCamera(
    //   LatLng(_destinationCityLat, _destinationCityLong),
    // );
  }

  void setDepartureCityGeohash(String x) {
    _departureCityGeoHash = x;
    notifyListeners();
  }

  void setDestinationCityGeohash(String x) {
    _destinationCityGeohash = x;
    notifyListeners();
  }

  // void _updateGoogleMapCamera(LatLng latLong) {
  //   myMapController.animateCamera(
  //     CameraUpdate.newCameraPosition(
  //       CameraPosition(
  //         bearing: 0.0,
  //         target: latLong,
  //         // tilt: 45.0,
  //         zoom: 9.0,
  //       ),
  //     ),
  //   );
  // }

  // void _addPolyLine() {
  //   if (_polylines.length > 0) {
  //     print('removing ${_polylines.keys.first}');
  //     _polylines.remove(_polylines.keys.first);
  //     notifyListeners();
  //   }
  //   _selectedPolyline =
  //       PolylineId('$_departureCityIata -> $_destinationCityIata ');
  //   notifyListeners();
  //   _polyline = Polyline(
  //     polylineId: _selectedPolyline,
  //     consumeTapEvents: false,
  //     patterns: [
  //       PatternItem.dash(30.0),
  //       PatternItem.gap(30.0),
  //       PatternItem.dot,
  //       PatternItem.gap(30.0),
  //     ],
  //     geodesic: true,
  //     width: 15,
  //     color: Color(0xcFF2ED199),
  //     points: [
  //       LatLng(_departureCityLat, _departureCityLong),
  //       LatLng(
  //           _destinationCityLat == null
  //               ? _departureCityLat
  //               : _destinationCityLat,
  //           _destinationCityLong == null
  //               ? _departureCityLong
  //               : _destinationCityLong),
  //     ],
  //     onTap: () {},
  //   );
  //   notifyListeners();

  //   _polylines[_selectedPolyline] = _polyline;
  //   notifyListeners();
  // }

  // void _addDepartureAirtportMarkers() {
  //   if (_markers.length > 0) {
  //     print('removing ${_markers.keys.first} and ${_circles.keys.first}');
  //     _markers.remove(
  //       _markers.keys.first,
  //     );
  //     notifyListeners();
  //     _circles.remove(_circles.keys.first);
  //     notifyListeners();
  //   }
  //   _selectedMarker = MarkerId(_departureCityIata);
  //   notifyListeners();
  //   _marker = Marker(
  //     markerId: _selectedMarker,
  //     position: LatLng(_departureCityLat, _departureCityLong),
  //     infoWindow: InfoWindow(title: _departureCityIata, snippet: '*'),
  //     onTap: () {
  //       // _onMarkerTapped(markerId);

  //       _updateGoogleMapCamera(
  //         LatLng(_departureCityLat, _departureCityLong),
  //       );
  //     },
  //   );
  //   notifyListeners();

  //   _markers[_selectedMarker] = _marker;
  //   notifyListeners();
  // }

  // void _addDestinationAirportMarkers() {
  //   if (_markers.length > 1) {
  //     print(
  //         'removing ${_markers.keys.elementAt(1)} and ${_circles.keys.elementAt(1)}');
  //     _markers.remove(
  //       _markers.keys.elementAt(1),
  //     );
  //     notifyListeners();
  //     _circles.remove(_circles.keys.elementAt(1));
  //     notifyListeners();
  //   }
  //   _selectedMarker = MarkerId(_destinationCityIata);
  //   notifyListeners();
  //   _marker = Marker(
  //     markerId: _selectedMarker,
  //     position: LatLng(_destinationCityLat, _destinationCityLong),
  //     infoWindow: InfoWindow(title: _destinationCityIata, snippet: '*'),
  //     onTap: () {
  //       _updateGoogleMapCamera(
  //         LatLng(_destinationCityLat, _destinationCityLong),
  //       );
  //       // _onMarkerTapped(markerId);
  //     },
  //   );
  //   notifyListeners();
  //   _markers[_selectedMarker] = _marker;
  //   notifyListeners();
  // }

  // void addOriginRaduisCircle() {
  //   if (_circles.length > 1) {
  //     print('removing ${_circles.keys.first}');
  //     _circles.remove(_circles.keys.first);
  //     notifyListeners();
  //   }
  //   _selectedCircle = CircleId(_departureCityIata);
  //   notifyListeners();
  //   _circle = Circle(
  //     circleId: _selectedCircle,
  //     consumeTapEvents: false,
  //     strokeColor: Colors.orange,
  //     fillColor: Color(0xc222ED199),
  //     strokeWidth: 5,
  //     center: LatLng(_departureCityLat, _departureCityLong),
  //     radius: _originRadius * 1609.344,
  //     onTap: () {
  //       //_onCircleTapped(circleId);
  //     },
  //   );
  //   notifyListeners();
  //   _circles[_selectedCircle] = _circle;
  //   notifyListeners();
  // }

  // void addDestinationRaduisCircle() {
  //   if (_circles.length > 1) {
  //     print('removing ${_circles.keys.elementAt(1)}');
  //     _circles.remove(_circles.keys.elementAt(1));
  //     notifyListeners();
  //   }
  //   _selectedCircle = CircleId(_destinationCityIata);
  //   notifyListeners();
  //   _circle = Circle(
  //     circleId: _selectedCircle,
  //     consumeTapEvents: false,
  //     strokeColor: Colors.orange,
  //     fillColor: Color(0xc222ED199),
  //     strokeWidth: 5,
  //     center: LatLng(_destinationCityLat, _destinationCityLong),
  //     radius: _destinationRadius * 1609.344,
  //     onTap: () {
  //       //_onCircleTapped(circleId);
  //     },
  //   );
  //   notifyListeners();
  //   _circles[_selectedCircle] = _circle;
  //   notifyListeners();
  // }
}
