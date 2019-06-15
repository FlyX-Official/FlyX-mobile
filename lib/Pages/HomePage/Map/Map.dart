import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Map extends StatefulWidget {
  Map({Key key}) : super(key: key);

  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(37, -95),
        ),
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
          Factory<OneSequenceGestureRecognizer>(
            () => EagerGestureRecognizer(),
          ),
        ].toSet(),
      ),
    );
  }
}
