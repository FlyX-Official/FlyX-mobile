import 'dart:async';
import 'dart:convert';

import 'package:FlyXWebSource/models/AutoCompleteV2/AutoCompleteResponse.dart';
import 'package:database/database.dart';
import 'package:database/filter.dart';
import 'package:database_adapter_algolia/database_adapter_algolia.dart';
import 'package:flutter/foundation.dart';

class AutoCompleteCall with ChangeNotifier {
  final Database _algoliaDb = Algolia(
    apiKey: '392b738314345e58af28cd72ef399e99',
    appId: 'ULNY1X7FOY',
  ).database();

  List<Hit> _data;
  List<Hit> get data => _data;

  makeRequest(String query) async {
    List<Hit> _tmpData = List<Hit>();
    Stream<QueryResult> tmp =
        _algoliaDb.collection('airportData').searchIncrementally(
              reach: Reach.server,
              query: Query.parse(query),
            );
    tmp.listen(
      (event) {
        for (var item in event.items) {
          final _tmp = json.encode(Hit.fromJson(item.data));
          _tmpData.add(
            Hit.fromJson(
              json.decode(_tmp),
            ),
          );
        }
      },
    ).onDone(
      () {
        _data = _tmpData;
        notifyListeners();
        print(_tmpData.length);
        print(_data.length);
      },
    );
  }
}
