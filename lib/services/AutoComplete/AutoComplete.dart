import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flyxweb/models/AutoComplete/AutoComplete.dart';
import 'package:flyxweb/models/AutoComplete/AutoCompleteRequest.dart' as req;
import 'package:flyxweb/models/AutoComplete/AutoCompleteResponse.dart';
// import 'package:flyxweb/models/AutoComplete/AutoComplete.dart';

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

//  .map(e => e[comp])

//        // store the keys of the unique objects
//       .map((e, i, final) => final.indexOf(e) === i && i)

//       // eliminate the dead keys & store unique objects
//       .filter(e => arr[e]).map(e => arr[e]);
