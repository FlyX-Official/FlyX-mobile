/*
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomGoogleMap extends StatefulWidget {
  final Widget child;

  CustomGoogleMap({Key key, this.child}) : super(key: key);

  _CustomGoogleMapState createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> {
  GoogleMapController mapController;

   _onMapCreated(GoogleMapController controller) {
    //mapController = controller;
    controller.addListener(
      Marker(
        position: LatLng(35.7378, -119.7871),
        markerId: MarkerId('1'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      //margin: EdgeInsets.all(8),
      child: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: _buildCameraPosition(),
        //mapType: MapType.hybrid,
        myLocationEnabled: true,
        //compassEnabled: true,
      ),
    );
  }
}

CameraPosition _buildCameraPosition() {
  final LatLng _center = const LatLng(36.7378, -119.7871);
  return CameraPosition(
    target: _center,
    //tilt: 45.0,
    zoom: 5.0,
    //bearing: 55,import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomGoogleMap extends StatefulWidget {
  final Widget child;

  CustomGoogleMap({Key key, this.child}) : super(key: key);

  _CustomGoogleMapState createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> {
  GoogleMapController mapController;

   _onMapCreated(GoogleMapController controller) {
    //mapController = controller;
    controller.addListener(
      Marker(
        position: LatLng(35.7378, -119.7871),
        markerId: MarkerId('1'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      //margin: EdgeInsets.all(8),
      child: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: _buildCameraPosition(),
        //mapType: MapType.hybrid,
        myLocationEnabled: true,
        //compassEnabled: true,
      ),
    );
  }
}

CameraPosition _buildCameraPosition() {
  final LatLng _center = const LatLng(36.7378, -119.7871);
  return CameraPosition(
    target: _center,
    //tilt: 45.0,
    zoom: 5.0,
    //bearing: 55,
  );
}

  );
}
*/
// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomGoogleMap extends StatefulWidget {
  const CustomGoogleMap();

  @override
  State<StatefulWidget> createState() => CustomGoogleMapState();
}

typedef Marker MarkerUpdateAction(Marker marker);

class CustomGoogleMapState extends State<CustomGoogleMap> {
  CustomGoogleMapState();

  static final LatLng center = const LatLng(36.7378, -119.7871);

  GoogleMapController controller;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId selectedMarker;
  int _markerIdCounter = 1;

  void _onMapCreated(GoogleMapController controller) {
    this.controller = controller;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onMarkerTapped(MarkerId markerId) {
    final Marker tappedMarker = markers[markerId];
    if (tappedMarker != null) {
      setState(() {
        if (markers.containsKey(selectedMarker)) {
          final Marker resetOld = markers[selectedMarker]
              .copyWith(iconParam: BitmapDescriptor.defaultMarker);
          markers[selectedMarker] = resetOld;
        }
        selectedMarker = markerId;
        final Marker newMarker = tappedMarker.copyWith(
          iconParam: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        );
        markers[markerId] = newMarker;
      });
    }
  }

  void _add() {
    final int markerCount = markers.length;

    if (markerCount == 12) {
      return;
    }

    final String markerIdVal = 'marker_id_$_markerIdCounter';
    _markerIdCounter++;
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(
        center.latitude + sin(_markerIdCounter * pi / 6.0) / 20.0,
        center.longitude + cos(_markerIdCounter * pi / 6.0) / 20.0,
      ),
      infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
      onTap: () {
        _onMarkerTapped(markerId);
      },
    );

    setState(() {
      markers[markerId] = marker;
    });
  }

  void _remove() {
    setState(() {
      if (markers.containsKey(selectedMarker)) {
        markers.remove(selectedMarker);
      }
    });
  }

  void _changePosition() {
    final Marker marker = markers[selectedMarker];
    final LatLng current = marker.position;
    final Offset offset = Offset(
      center.latitude - current.latitude,
      center.longitude - current.longitude,
    );
    setState(() {
      markers[selectedMarker] = marker.copyWith(
        positionParam: LatLng(
          center.latitude + offset.dy,
          center.longitude + offset.dx,
        ),
      );
    });
  }

  void _changeAnchor() {
    final Marker marker = markers[selectedMarker];
    final Offset currentAnchor = marker.anchor;
    final Offset newAnchor = Offset(1.0 - currentAnchor.dy, currentAnchor.dx);
    setState(() {
      markers[selectedMarker] = marker.copyWith(
        anchorParam: newAnchor,
      );
    });
  }

  Future<void> _changeInfoAnchor() async {
    final Marker marker = markers[selectedMarker];
    final Offset currentAnchor = marker.infoWindow.anchor;
    final Offset newAnchor = Offset(1.0 - currentAnchor.dy, currentAnchor.dx);
    setState(() {
      markers[selectedMarker] = marker.copyWith(
        infoWindowParam: marker.infoWindow.copyWith(
          anchorParam: newAnchor,
        ),
      );
    });
  }

  Future<void> _toggleDraggable() async {
    final Marker marker = markers[selectedMarker];
    setState(() {
      markers[selectedMarker] = marker.copyWith(
        draggableParam: !marker.draggable,
      );
    });
  }

  Future<void> _toggleFlat() async {
    final Marker marker = markers[selectedMarker];
    setState(() {
      markers[selectedMarker] = marker.copyWith(
        flatParam: !marker.flat,
      );
    });
  }

  Future<void> _changeInfo() async {
    final Marker marker = markers[selectedMarker];
    final String newSnippet = marker.infoWindow.snippet + '*';
    setState(() {
      markers[selectedMarker] = marker.copyWith(
        infoWindowParam: marker.infoWindow.copyWith(
          snippetParam: newSnippet,
        ),
      );
    });
  }

  Future<void> _changeAlpha() async {
    final Marker marker = markers[selectedMarker];
    final double current = marker.alpha;
    setState(() {
      markers[selectedMarker] = marker.copyWith(
        alphaParam: current < 0.1 ? 1.0 : current * 0.75,
      );
    });
  }

  Future<void> _changeRotation() async {
    final Marker marker = markers[selectedMarker];
    final double current = marker.rotation;
    setState(() {
      markers[selectedMarker] = marker.copyWith(
        rotationParam: current == 330.0 ? 0.0 : current + 30.0,
      );
    });
  }

  Future<void> _toggleVisible() async {
    final Marker marker = markers[selectedMarker];
    setState(() {
      markers[selectedMarker] = marker.copyWith(
        visibleParam: !marker.visible,
      );
    });
  }

  Future<void> _changeZIndex() async {
    final Marker marker = markers[selectedMarker];
    final double current = marker.zIndex;
    setState(() {
      markers[selectedMarker] = marker.copyWith(
        zIndexParam: current == 12.0 ? 0.0 : current + 1.0,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Center(
          child: Container(
            height: MediaQuery.of(context).size.height * .85,
            width: MediaQuery.of(context).size.width,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: const CameraPosition(
                target: LatLng(36.7378, -119.7871),
                zoom: 11.0,
              ),
              // TODO(iskakaushik): Remove this when collection literals makes it to stable.
              // https://github.com/flutter/flutter/issues/28312
              // ignore: prefer_collection_literals
              markers: Set<Marker>.of(markers.values),
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        FlatButton(
                          color: Colors.white,
                          child: const Text('add'),
                          onPressed: _add,
                        ),
                        FlatButton(
                          color: Colors.white,
                          child: const Text('remove'),
                          onPressed: _remove,
                        ),
                        FlatButton(
                          color: Colors.white,
                          child: const Text('change info'),
                          onPressed: _changeInfo,
                        ),
                        FlatButton(
                          color: Colors.white,
                          child: const Text('change info anchor'),
                          onPressed: _changeInfoAnchor,
                        ),
                        FlatButton(
                          color: Colors.white,
                          child: const Text('change alpha'),
                          onPressed: _changeAlpha,
                        ),
                        FlatButton(
                          color: Colors.white,
                          child: const Text('change anchor'),
                          onPressed: _changeAnchor,
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        FlatButton(
                          color: Colors.white,
                          child: const Text('toggle draggable'),
                          onPressed: _toggleDraggable,
                        ),
                        FlatButton(
                          color: Colors.white,
                          child: const Text('toggle flat'),
                          onPressed: _toggleFlat,
                        ),
                        FlatButton(
                          color: Colors.white,
                          child: const Text('change position'),
                          onPressed: _changePosition,
                        ),
                        FlatButton(
                          color: Colors.white,
                          child: const Text('change rotation'),
                          onPressed: _changeRotation,
                        ),
                        FlatButton(
                          color: Colors.white,
                          child: const Text('toggle visible'),
                          onPressed: _toggleVisible,
                        ),
                        FlatButton(
                          color: Colors.white,
                          child: const Text('change zIndex'),
                          onPressed: _changeZIndex,
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
