import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:FlyXWebSource/models/AutoComplete/AutoComplete.dart';
import 'package:FlyXWebSource/models/AutoComplete/AutoCompleteRequest.dart' as req;
import 'package:FlyXWebSource/models/AutoComplete/AutoCompleteResponse.dart';
// import 'package:FlyXWebSource/models/AutoComplete/AutoComplete.dart';

class AutoCompleteCall with ChangeNotifier {
  List<Suggestions> _data;
  final _dio = Dio();
  AutoCompleteResponse _response;
  List<Suggestions> get data => _data;

  AutoCompleteResponse get response => _response;

  void makeRequest(String query) async {
    try {
      Future.wait(
        [
          _dio
              .post(
            'https://search-flyx-pjpbplak6txrmnjlcrzwekexy4.us-east-2.es.amazonaws.com/airports/_search',
            data: req.autoCompleteRequestToJson(
              req.AutoCompleteRequest(
                size: 30,
                suggest: req.Suggest(
                  text: query,
                  name: req.City(
                    completion: req.Completion(
                      field: 'Name',
                    ),
                  ),
                  city: req.City(
                    completion: req.Completion(
                      field: 'City',
                    ),
                  ),
                  iata: req.City(
                    completion: req.Completion(
                      field: 'IATA_Completion',
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
              .then(
            (r) {
              _response = AutoCompleteResponse.fromJson(r.data);
              notifyListeners();

              Set<Option> combined = <Option>{}
                ..addAll(response.suggest.city.first.options)
                ..addAll(response.suggest.iata.first.options)
                ..addAll(response.suggest.name.first.options);
              // noDupli(combined);

              var enc = json.encode(
                combined.toList(),
              );
              // print(enc);

              _data = suggestionsFromJson(
                enc,
              );
              notifyListeners();
            },
          )
        ],
      );
    } catch (e) {
      Exception(e);
    }
  }
}
