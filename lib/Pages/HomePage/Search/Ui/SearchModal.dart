import 'package:flutter/material.dart';
import 'package:flyx/Pages/HomePage/Search/Functions/AutoComplete.dart';

import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

String originQuery, destinationQuery, oneWayDateRange, returnWayDateRange;

List<DateTime> originDate, destinationDate;
bool isOrigin;
double fromSlider, toSlider;

class SearchModal extends StatefulWidget {
  const SearchModal({
    Key key,
  }) : super(key: key);

  @override
  _SearchModalState createState() => _SearchModalState();
}

class _SearchModalState extends State<SearchModal> {
  final AutoComplete _delegate = AutoComplete();

  @override
  void initState() {
    isOrigin = false;
    originQuery = 'SFO';
    destinationQuery = 'LAX';
    fromSlider = 1;
    toSlider = 1;

    oneWayDateRange = 'DD / MM \nDD / MM';
    returnWayDateRange = 'DD / MM \nDD / MM';
    super.initState();
  }

  String getOriginQuery() {
    String originIataCode = originQuery;
    return originIataCode;
  }

  String getDestinationQuery() {
    String destinationIataCode = destinationQuery;
    return destinationIataCode;
  }

  Container _leftSide() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Text(
            'FROM',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          FlatButton(
            onPressed: () async {
              setState(() {
                isOrigin = true;
              });
              dynamic origin = await showSearch(
                context: context,
                delegate: _delegate,
              );
              if (origin != null) {
                setState(() {
                  originQuery = origin;
                });
              }
            },
            child: Text(
              getOriginQuery(),
              textScaleFactor: 3,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Slider(
            value: fromSlider,
            min: 1,
            max: 100,
            divisions: 5,
            label: '$fromSlider Mi',
            onChanged: (double value) {
              setState(() {
                fromSlider = value;
              });
            },
          ),
          Container(
            width: MediaQuery.of(context).size.width * .42,
            height: 1,
            color: Colors.red,
            margin: EdgeInsets.all(
              8.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'DEPARTURE DATE',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          FlatButton(
            onPressed: () async {
              final List<DateTime> originPicked =
                  await DateRangePicker.showDatePicker(
                context: context,
                initialFirstDate: DateTime.now(),
                initialLastDate: DateTime.now().add(
                  Duration(days: 7),
                ),
                firstDate: DateTime(2019),
                lastDate: DateTime(2020),
              );
              if (originPicked != null && originPicked.length == 2) {
                print(originPicked);
                originDate = originPicked.toList();
              }

              setState(() {
                if (originPicked != null && originPicked.length == 2) {
                  print(originPicked);
                  originDate = originPicked.toList();
                }
                oneWayDateRange =
                    '${originDate.first.day.toString()} / ${originDate.first.month.toString()}' +
                        ' -' +
                        '\n${originDate.last.day.toString()} / ${originDate.last.month.toString()}';
              });
            },
            child: Text(
              ('$oneWayDateRange'),
              textScaleFactor: 2.5,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Container _rightSide() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Text(
            'To',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          FlatButton(
            child: Text(
              getDestinationQuery(),
              textScaleFactor: 3,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            onPressed: () async {
              setState(() {
                isOrigin = false;
              });
              dynamic destination = await showSearch(
                context: context,
                delegate: _delegate,
              );
              if (destination != null) {
                setState(() {
                  destinationQuery = destination;
                });
              }
            },
          ),
          Slider(
            value: toSlider,
            min: 1,
            max: 100,
            divisions: 5,
            label: '$toSlider Mi',
            onChanged: (double value) {
              setState(() {
                toSlider = value;
              });
            },
          ),
          Container(
            width: MediaQuery.of(context).size.width * .42,
            height: 1,
            color: Colors.red,
            margin: EdgeInsets.all(
              8.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'RETURN DATE',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          FlatButton(
            child: Text(
              '$returnWayDateRange',
              textScaleFactor: 2.5,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              final List<DateTime> returnDatePicked =
                  await DateRangePicker.showDatePicker(
                context: context,
                initialFirstDate: DateTime.now().add(
                  Duration(days: 7),
                ),
                initialLastDate: DateTime.now().add(
                  Duration(days: 14),
                ),
                firstDate: DateTime(2019),
                lastDate: DateTime(2020),
              );
              if (returnDatePicked != null && returnDatePicked.length == 2) {
                print(returnDatePicked);
                destinationDate = returnDatePicked.toList();
              }

              setState(() {
                if (returnDatePicked != null && returnDatePicked.length == 2) {
                  print(returnDatePicked);
                  destinationDate = returnDatePicked.toList();
                }
                returnWayDateRange =
                    '${destinationDate.first.day.toString()} / ${destinationDate.first.month.toString()}' +
                        ' -' +
                        '\n${destinationDate.last.day.toString()} / ${destinationDate.last.month.toString()}';
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _leftSide(),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              Container(
                child: Icon(FontAwesomeIcons.exchangeAlt),
              ),
              SizedBox(
                height: 125,
              ),
              Container(
                child: Icon(FontAwesomeIcons.calendarWeek),
              )
            ],
          ),
          _rightSide(),
        ],
      ),
    );
  }
}
