import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flyxweb/models/NearByAirports/NearByResponse.dart';
import 'package:flyxweb/models/NearByAirports/NearbyRequest.dart';

// GET /airports/_search?pretty
// {
//   "query": {
//     "bool": {
//       "must": {
//         "match_all": {}
//       },
//       "filter": {
//         "geo_distance": {
//           "distance": "50mi",
//           "Geohash": "dr5x1n7b5008"
//         }
//       }
//     }
//   }
// }

class FetchNearBy with ChangeNotifier {
  NearbyResponse _data;
  List<String> _destinationNearByIataCodes = [];
  final _dio = Dio();
  List<String> _originNearByIataCodes = [];

  NearbyResponse get data => _data;

  List<String> get originNearByIataCodes => _originNearByIataCodes;

  List<String> get destinationNearByIataCodes => _destinationNearByIataCodes;

  void populateIataCodes(bool isOrigin) async {
    isOrigin
        ? _originNearByIataCodes.clear()
        : _destinationNearByIataCodes.clear();
    for (var i = 0; i < _data?.hits?.hits?.length; i++) {
      isOrigin
          ? _originNearByIataCodes.add(_data.hits.hits[i].source.iata)
          : _destinationNearByIataCodes.add(_data.hits.hits[i].source.iata);
    }

    isOrigin
        ? _originNearByIataCodes = _originNearByIataCodes.toSet().toList()
        : _destinationNearByIataCodes =
            _destinationNearByIataCodes.toSet().toList();
    print('Origin Nearby Airtports -> $_originNearByIataCodes' +
        '\n' +
        'Destination NearByAirports - > $_destinationNearByIataCodes');
  }

  void populateNearByAirports(
      bool isOrigin, double distance, String geohash) async {
    try {
      Future.wait(
        [
          _dio
              .post(
            'https://search-flyx-pjpbplak6txrmnjlcrzwekexy4.us-east-2.es.amazonaws.com/airports/_search?size=150',
            data: nearbyRequestToJson(
              NearbyRequest(
                query: Query(
                  queryBool: Bool(
                    must: Must(
                      matchAll: MatchAll(),
                    ),
                    filter: Filter(
                      geoDistance: GeoDistance(
                        distance: '${distance.toString()} mi',
                        geohash: geohash,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            options: Options(
              headers: {
                'Content-Type': 'application/json',
              },
              responseType: ResponseType.json,
            ),
          )
              .then((r) {
            _data = NearbyResponse.fromJson(r.data);
            notifyListeners();
          }).whenComplete(() {
            populateIataCodes(isOrigin);
          }),
        ],
      );
    } catch (e) {
      Exception(e);
    }
  }
}
