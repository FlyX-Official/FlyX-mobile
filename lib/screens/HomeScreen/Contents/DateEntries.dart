import 'package:flutter/material.dart';
import 'package:flyxweb/services/UserQuery/UserQuery.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
import 'package:provider/provider.dart';

class DepartureDate extends StatelessWidget {
  const DepartureDate({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserQuery _query = Provider.of<UserQuery>(context);
    return Card(
      child: Column(
        children: <Widget>[
          _query.departureDate == null
              ? Container()
              : Card(elevation: 0, child: Text('DEPARTURE DATE RANGE')),
          FlatButton(
            child: Text(
              _query.departureDate ?? 'DEPARTURE DATE RANGE',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            onPressed: () async {
              final List<DateTime> deprtureDatesPicked =
                  await DateRangePicker.showDatePicker(
                context: context,
                initialFirstDate: DateTime.now(),
                initialLastDate: DateTime.now().add(
                  Duration(days: 7),
                ),
                firstDate: DateTime(2019),
                lastDate: DateTime(2022),
              );
              Provider.of<UserQuery>(context, listen: false)
                  .setDepartureDateRange(deprtureDatesPicked);
            },
          ),
        ],
      ),
    );
  }
}

class ReturnDate extends StatelessWidget {
  const ReturnDate({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserQuery _query = Provider.of<UserQuery>(context);
    return Card(
      child: Column(
        children: <Widget>[
          _query.returnDate != null
              ? Card(
                  elevation: 0,
                  child: Text(
                    'RETURN DATE RANGE',
                  ),
                )
              : Container(),
          FlatButton(
            child: Text(
              _query.returnDate ?? 'RETURN DATE RANGE',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            onPressed: () async {
              final List<DateTime> deprtureDatesPicked =
                  await DateRangePicker.showDatePicker(
                context: context,
                initialFirstDate: DateTime.now(),
                initialLastDate: DateTime.now().add(
                  Duration(days: 7),
                ),
                firstDate: DateTime(2019),
                lastDate: DateTime(2022),
              );
              Provider.of<UserQuery>(context, listen: false)
                  .setReturnDateRange(deprtureDatesPicked);
            },
          ),
        ],
      ),
    );
  }
}
