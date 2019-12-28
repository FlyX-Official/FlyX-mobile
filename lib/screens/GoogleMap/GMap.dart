import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flyx/services/UserQuery/UserQuery.dart';
// import 'package:flyx/services/UserQuery/Users.Query.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class GMap extends StatefulWidget {
  GMap({Key key}) : super(key: key);

  _GMapState createState() => _GMapState();
}

typedef Marker MarkerUpdateAction(Marker marker);

class _GMapState extends State<GMap> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _mapProps = Provider.of<UserQuery>(context);
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(0, 0),
      ),
      onMapCreated: (GoogleMapController mapcontroller) async {
        _mapProps.myMapController = mapcontroller;
        // _mapProps.myMapController.setMapStyle(_mapStyle);
      },

      // onCameraIdle: () {
      //   _mapProps.calculateMidPoint();

      // },
      // compassEnabled: true,
      markers: Set<Marker>.of(_mapProps.markers.values),
      circles: Set<Circle>.of(_mapProps.circles.values),
      polylines: Set<Polyline>.of(_mapProps.polylines.values),
      mapToolbarEnabled: false,
      indoorViewEnabled: true,
      compassEnabled: true,

      myLocationButtonEnabled: true,
      cameraTargetBounds: CameraTargetBounds.unbounded,
      // gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
      //   Factory<OneSequenceGestureRecognizer>(
      //     () => EagerGestureRecognizer(),
      //   ),
      // ].toSet(),
    );
  }
}
