import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flyxweb/models/TicketResponse/ResponseModal.dart';
// import 'package:flyxweb/pages/TicketsView/TicketView.dart';
import 'package:hive/hive.dart';

class FlightSearch with ChangeNotifier {
  Trip _data;
  final _dio = Dio();
  double _receiveProgress;

  Trip get data => _data;

  void setData(Trip trip) {
    _data = trip;
    notifyListeners();
  }

  double get receiveProgress => _receiveProgress;

  void makeRequest(
    BuildContext context,
    List<String> originAirports,
    List<String> destinationAirports,
    List<DateTime> onewayDateRange,
    List<DateTime> returnDateRange,
    String sort,
    String vehicleType,
  ) async {
    try {
      String _flyFrom = originAirports
          .toString()
          .substring(1, originAirports.toString().length - 1)
          .replaceAll(RegExp(r"\s+\b|\b\s"), "");
      String _flyTo = destinationAirports
          .toString()
          .substring(1, destinationAirports.toString().length - 1)
          .replaceAll(RegExp(r"\s+\b|\b\s"), "");
      String _dateFrom = onewayDateRange.first.day.toString() +
          '/' +
          onewayDateRange.first.month.toString() +
          '/' +
          onewayDateRange.first.year.toString();
      String _dateTo = onewayDateRange.last.day.toString() +
          '/' +
          onewayDateRange.last.month.toString() +
          '/' +
          onewayDateRange.last.year.toString();
      String _returnFrom = returnDateRange == null
          ? ''
          : returnDateRange.first.day.toString() +
              '/' +
              returnDateRange.first.month.toString() +
              '/' +
              returnDateRange.first.year.toString();
      String _returnTo = returnDateRange == null
          ? ''
          : returnDateRange.last.day.toString() +
              '/' +
              returnDateRange.last.month.toString() +
              '/' +
              returnDateRange.last.year.toString();
      String _vehicleType = vehicleType ?? 'aircraft';
      String _sortFilter = sort.toLowerCase() ?? 'price';

      String _url = 'https://api.skypicker.com/flights?' +
          'fly_from=$_flyFrom' +
          '&fly_to=$_flyTo' +
          '&date_from=$_dateFrom' +
          '&date_to=$_dateTo' +
          '&return_from=$_returnFrom' +
          '&return_to=$_returnTo' +
          '&one_per_city=1' +
          '&vehicle_type=$_vehicleType' +
          '&curr=USD' +
          '&sort=$_sortFilter' +
          '&partner=picky';
      print(_url);
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => TicketView(),
      //   ),
      // );
      await Future.wait(
        [
          _dio.get(_url,
              options: Options(
                responseType: ResponseType.json,
              ), onReceiveProgress: (start, end) {
            // var increase = start / end;
            // var divide = increase;
            // print('Progress ->>> $start end $end');
            // _receiveProgress = divide;
            // notifyListeners();
          }).then(
            (r) {
              //print(r);

              Hive.box('Tickets').put(0, r.statusCode);
              setData(Trip.fromJson(r.data));

              print(data.data.length);
            },
            // .whenComplete(
            //   () {
            //     print(Hive.box('Tickets').getAt(0).runtimeType);

            //     setData(
            //       Trip.fromJson(
            //         Hive.box('Tickets').getAt(0),
            //       ),
            //     );
            //   },
          ),
        ],
      );
    } catch (e) {
      Exception(e);
    }
  }
}
