import 'package:flutter/material.dart';
import 'package:flyx/screens/TicketResultsScreen/TicketResultsScreen.dart';
import 'package:flyx/services/NearBy/NearBy.dart';
import 'package:flyx/services/TicketNetworkCall/Request.dart';
import 'package:flyx/services/UserQuery/UserQuery.dart';
import 'package:provider/provider.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const StadiumBorder(),
      color: Colors.blueGrey,
      child: FlatButton.icon(
        icon: const Icon(
          Icons.search,
        ),
        label: const Text('SEARCH'),
        onPressed: () {
          
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TicketResults(),
            ),
          );Provider.of<FlightSearch>(context).makeRequest(
            context,
            Provider.of<FetchNearBy>(context).originNearByIataCodes,
            Provider.of<FetchNearBy>(context).destinationNearByIataCodes,
            Provider.of<UserQuery>(context).departureDateRange,
            Provider.of<UserQuery>(context).returnDateRange,
            // Provider.of<UserQuery>(context).vehicleType,
            'aircraft',
          );
        },
      ),
    );
  }
}
