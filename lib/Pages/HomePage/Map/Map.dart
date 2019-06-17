import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

GoogleMapController myMapController;
String _mapStyle;
Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};

class MyMap extends StatefulWidget {
  MyMap({Key key}) : super(key: key);

  _MyMapState createState() => _MyMapState();
}

typedef Marker MarkerUpdateAction(Marker marker);

class _MyMapState extends State<MyMap> {
  @override
  void initState() {
    rootBundle.loadString('assets/Style/map_style_day.txt').then((string) {
      _mapStyle = string;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(37, -95),
        ),
        onMapCreated: (GoogleMapController mapcontroller) async {
          myMapController = mapcontroller;
          myMapController.setMapStyle(_mapStyle);
        },
        compassEnabled: true,
        markers: Set<Marker>.of(markers.values),
        polylines: Set<Polyline>.of(polylines.values),
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
          Factory<OneSequenceGestureRecognizer>(
            () => EagerGestureRecognizer(),
          ),
        ].toSet(),
      ),
    );
  }
}
