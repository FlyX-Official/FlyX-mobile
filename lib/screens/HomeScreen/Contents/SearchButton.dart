import 'package:flutter/material.dart';
import 'package:flyxweb/screens/TicketResultsScreen/TicketResultsScreen.dart';
// import 'package:flyxweb/screens/TicketResultsScreen/TicketResultsScreen.dart';
import 'package:flyxweb/services/NearBy/NearBy.dart';
import 'package:flyxweb/services/TicketNetworkCall/Request.dart';
import 'package:flyxweb/services/UserQuery/UserQuery.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> _departureCityIata = [
      Provider.of<UserQuery>(context).departureCityIata
    ];

    final List<String> _destinationCityIata = [
      Provider.of<UserQuery>(context).destinationCityIata
    ];
    final List<String> departureSurrAirports =
        Provider.of<FetchNearBy>(context).originNearByIataCodes;
    final List<String> destinationSurrAirports =
        Provider.of<FetchNearBy>(context).destinationNearByIataCodes;
    final List<DateTime> depDates =
        Provider.of<UserQuery>(context).departureDateRange;
    final List<DateTime> destDates =
        Provider.of<UserQuery>(context).returnDateRange;
    final String sortFilter = Provider.of<UserQuery>(context).sortFilter;
    return Card(
      shape: const StadiumBorder(),
      color: Colors.blueGrey,
      child: FlatButton.icon(
        icon: const Icon(
          Icons.search,
        ),
        label: const Text('SEARCH'),
        onPressed: () async {
          MediaQuery.of(context).size.shortestSide < 768
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Tickets(),
                  ),
                )
              : print('isDesktop');
          Hive.box('Tickets').clear();
          Provider.of<FlightSearch>(context, listen: false).makeRequest(
            context,
            departureSurrAirports.isEmpty
                ? _departureCityIata
                : departureSurrAirports,
            destinationSurrAirports.isEmpty
                ? _destinationCityIata
                : destinationSurrAirports,
            depDates,
            destDates,
            sortFilter,
            // Provider.of<UserQuery>(context).vehicleType,
            'aircraft',
          );
          // Provider.of<FlightSearch>(context, listen: false).makeRequest(
          //   context,
          //   ['FAT','LAX','SFO'], ['HYD'], depDates, destDates,
          //   // Provider.of<UserQuery>(context).vehicleType,
          //   'aircraft',
          // );
        },
      ),
    );
  }
}
