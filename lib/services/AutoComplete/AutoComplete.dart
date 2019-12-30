import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flyxweb/models/AutoComplete/AutoComplete.dart';
// import 'package:flyxweb/models/AutoComplete/AutoComplete.dart';

class AutoCompleteCall with ChangeNotifier {
  List<Suggestions> _data;
  final _dio = Dio();

  List<Suggestions> get data => _data;

  void makeRequest(String query) async {
    try {
      Future.wait(
        [
          _dio
              .get(
            'https://flyx-server.herokuapp.com/autocomplete?q=$query',
            options: Options(
              responseType: ResponseType.plain,
            ),
          )
              .then(
            (r) {
              _data = suggestionsFromJson(r.data);
              notifyListeners();
              print(_data);
            },
          ),
        ],
      );
    } catch (e) {
      Exception(e);
    }
  }
}
