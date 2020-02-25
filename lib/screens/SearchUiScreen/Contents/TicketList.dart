import 'package:FlyXWebSource/models/AutoCompleteV2/AutoCompleteResponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:FlyXWebSource/services/AutoComplete/AutoComplete.dart';
import 'package:FlyXWebSource/services/UserQuery/UserQuery.dart';
import 'package:provider/provider.dart';

class TicketList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Hit> _sugg =
        Provider.of<AutoCompleteCall>(context, listen: true).data;

    final UserQuery _query = Provider.of<UserQuery>(context, listen: false);

    return CustomScrollView(
      // physics: const BouncingScrollPhysics(),
      reverse: true,
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return AnimationConfiguration.synchronized(
                child: ScaleAnimation(
                  scale: 2,
                  child: FadeInAnimation(
                    child: Card(
                      color: Colors.white,
                      elevation: 4,
                      child: ListTile(
                        dense: false,
                        enabled: true,
                        isThreeLine: false,
                        onTap: () {
                          if (_query.isOrigin) {
                            _query
                                .setDepartureIata(_sugg.elementAt(index).iata);
                            _query.setDepartureCityLat(
                                _sugg.elementAt(index).location.latitude);
                            _query.setDepartureCityLong(
                                _sugg.elementAt(index).location.longitude);
                            _query.setDepartureCityGeohash(
                                _sugg.elementAt(index).location.geohash);
                          } else {
                            _query.setDestinationIata(
                                _sugg.elementAt(index).iata);
                            _query.setDestinationCityLat(
                                _sugg.elementAt(index).location.latitude);
                            _query.setDestinationCityLong(
                                _sugg.elementAt(index).location.longitude);
                            _query.setDestinationCityGeohash(
                                _sugg.elementAt(index).location.geohash);
                          }
                          // if (!isDisplayDesktop(context))
                          Navigator.pop(context);
                          Provider.of<UserQuery>(context, listen: false)
                              .setIsOrigin(null);
                        },
                        leading: IconButton(
                          icon: const Icon(
                            Icons.favorite,
                            color: Colors.redAccent,
                          ),
                          onPressed: () {},
                        ),
                        // title: Text(_sugg.elementAt(index).name),
                        // subtitle:
                        title: Text(_sugg.elementAt(index).iata),
                        //'${_sugg.elementAt(index).iata} - ${_sugg.elementAt(index).name}'),
                        subtitle: Text(
                            '${_sugg.elementAt(index).location.city}, ${_sugg.elementAt(index).location.country}'),
                      ),
                    ),
                  ),
                ),
              );
            },
            childCount: _sugg.length,
            addAutomaticKeepAlives: false,
          ),
        ),
      ],
    );
  }
}
