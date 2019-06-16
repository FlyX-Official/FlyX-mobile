import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

GoogleMapController myMapController;
String _mapStyle;

class Map extends StatefulWidget {
  Map({Key key}) : super(key: key);

  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
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
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
          Factory<OneSequenceGestureRecognizer>(
            () => EagerGestureRecognizer(),
          ),
        ].toSet(),
      ),
    );
  }
}
