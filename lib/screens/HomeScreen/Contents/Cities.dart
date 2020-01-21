import 'package:flutter/material.dart';
import 'package:flyxweb/screens/SearchUiScreen/SearchUi.dart';
import 'package:flyxweb/services/AutoComplete/AutoComplete.dart';
// import 'package:flyxweb/screens/SearchUiScreen/SearchUi.dart';
import 'package:flyxweb/services/NearBy/NearBy.dart';
import 'package:flyxweb/services/UserQuery/UserQuery.dart';
import 'package:flyxweb/utils/Responsive.dart';
import 'package:provider/provider.dart';

class Cities extends StatelessWidget {
  const Cities({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserQuery _query = Provider.of<UserQuery>(context, listen: true);
    final FetchNearBy _nearby =
        Provider.of<FetchNearBy>(context, listen: false);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Expanded(
          child: Card(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 10),
                const Text('FROM'),
                FlatButton(
                  child: Text(
                    _query.departureCityIata ?? 'SFO',
                    style: TextStyle(
                      fontSize: 34,
                    ),
                  ),
                  onPressed: () async {
                    Provider.of<UserQuery>(context, listen: false)
                        .setIsOrigin(true);
                    Provider.of<AutoCompleteCall>(context, listen: false)
                        .data
                        ?.clear();

                    if (!isDisplayDesktop(context))
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchUi(),
                          maintainState: false,
                          fullscreenDialog: false,
                        ),
                      );
                  },
                ),
                Slider.adaptive(
                  onChanged: (v) async {
                    Provider.of<UserQuery>(context, listen: false)
                        .setOriginRadius(v);
                    _nearby.populateNearByAirports(
                        true, v, _query.departureCityGeoHash);
                  },
                  value: _query.originRadius,
                  label: _query.originRadius.toString() + ' Mi',
                  divisions: 10,
                  min: 0,
                  max: 250,
                  inactiveColor: Colors.grey,
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: Card(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 10),
                const Text('TO'),
                FlatButton(
                  child: Text(
                    _query.destinationCityIata ?? 'LAX',
                    style: TextStyle(
                      fontSize: 34,
                    ),
                  ),
                  onPressed: () async {
                    Provider.of<UserQuery>(context, listen: false)
                        .setIsOrigin(false);
                    Provider.of<AutoCompleteCall>(context, listen: false)
                        .data
                        .clear();
                    if (!isDisplayDesktop(context))
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchUi(), //AirportSearch(),
                          maintainState: false,
                          fullscreenDialog: false,
                        ),
                      );
                  },
                ),
                Slider.adaptive(
                  onChanged: (v) async {
                    Provider.of<UserQuery>(context, listen: false)
                        .setDestinationRadius(v);
                    _nearby.populateNearByAirports(
                        false, v, _query.destinationCityGeoHash);
                  },
                  value: _query.destinationRadius,
                  min: 0,
                  divisions: 10,
                  max: 250,
                  label: _query.destinationRadius.toString() + ' Mi',
                  inactiveColor: Colors.grey,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
