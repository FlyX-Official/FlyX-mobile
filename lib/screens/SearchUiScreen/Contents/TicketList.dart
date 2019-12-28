import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flyx/models/AutoComplete/AutoComplete.dart';
import 'package:flyx/services/AutoComplete/AutoComplete.dart';
import 'package:flyx/services/UserQuery/UserQuery.dart';
import 'package:provider/provider.dart';

class TicketList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Suggestions> _sugg = Provider.of<AutoCompleteCall>(context).data;
    final UserQuery _query = Provider.of<UserQuery>(context, listen: false);
    return CustomScrollView(
      // physics: const BouncingScrollPhysics(),
      reverse: true,
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, i) {
              return AnimationConfiguration.synchronized(
                child: ScaleAnimation(
                  scale: 2,
                  child: FadeInAnimation(
                    child: Card(
                      color: Colors.white,
                      elevation: 8,
                      child: ListTile(
                        dense: false,
                        enabled: true,
                        isThreeLine: false,
                        onTap: () {
                          if (_query.isOrigin) {
                            _query.setDepartureIata(_sugg[i].source.iata);
                            _query
                                .setDepartureCityLat(_sugg[i].source.latitude);
                            _query.setDepartureCityLong(
                                _sugg[i].source.longitude);
                            _query.setDepartureCityGeohash(
                                _sugg[i].source.geohash);
                          }
                          if (_query.isOrigin == false) {
                            _query.setDestinationIata(_sugg[i].source.iata);
                            _query.setDestinationCityLat(
                                _sugg[i].source.latitude);
                            _query.setDestinationCityLong(
                                _sugg[i].source.longitude);
                            _query.setDestinationCityGeohash(
                                _sugg[i].source.geohash);
                          }
                          Navigator.pop(context);
                        },
                        leading: IconButton(
                          icon: const Icon(
                            Icons.favorite,
                            color: Colors.redAccent,
                          ),
                          onPressed: () {},
                        ),
                        title: Text(
                            '${_sugg[i].source.iata} - ${_sugg[i].source.name}'),
                        subtitle: Text(
                            '${_sugg[i].source.city}, ${_sugg[i].source.country}'),
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
