import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flyxweb/models/TicketResponse/ResponseModal.dart';
import 'package:flyxweb/services/TicketNetworkCall/Request.dart';
import 'package:flyxweb/services/UserQuery/UserQuery.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:url_launcher/url_launcher.dart';

final scrollController = ScrollController(keepScrollOffset: true);

class Tickets extends StatefulWidget {
  const Tickets({Key key}) : super(key: key);

  @override
  _TicketsState createState() => _TicketsState();
}

class _TicketsState extends State<Tickets> {
  @override
  void dispose() {
    Hive.box('Tickets').clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final Box _tickets = Hive.box('Tickets');
    final _snapshot = Provider.of<FlightSearch>(context).data;
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: Hive.box('Tickets').listenable(),
        builder: (context, box, widget) => Center(
          child: box.values.length == 1 && _snapshot != null
              ? const TicketResults()
              : const Center(
                  child: const CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }
}

class TicketResults extends StatefulWidget {
  const TicketResults({Key key}) : super(key: key);

  @override
  _TicketResultsState createState() => _TicketResultsState();
}

class _TicketResultsState extends State<TicketResults> {
  @override
  void dispose() {
    Hive.box('Tickets').clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final Box _tickets = Hive.box('Tickets');

    final UserQuery _query = Provider.of<UserQuery>(context);
    final Trip _snapshot = Provider.of<FlightSearch>(context).data;

    return CustomScrollView(
      // controller: _scrollController,
      semanticChildCount: _snapshot.data.length ?? 1,
      slivers: <Widget>[
        SliverAppBar(
          backgroundColor: Colors.blueGrey,
          automaticallyImplyLeading: true,
          elevation: 8,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                _query.departureCityIata,
              ),
              Icon(
                _query.isOneWay
                    ? Icons.arrow_forward
                    : Icons.swap_horizontal_circle,
              ),
              Text(
                _query.destinationCityIata,
              ),
            ],
          ),
          centerTitle: true,
          pinned: true,
          floating: false,
          snap: false,
        ),
        SliverFillRemaining(
          child: ValueListenableBuilder(
            valueListenable: Hive.box('Tickets').listenable(),
            builder: (context, box, widget) => Center(
              child: box.values.length == 1 && _snapshot != null
                  ? const TicketSliverList()
                  : const Center(
                      child: const CircularProgressIndicator(),
                    ),
            ),
          ),
        )
      ],
    );
  }
}

class TicketSliverList extends StatelessWidget {
  const TicketSliverList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _isOneWay = Provider.of<UserQuery>(context);
    final Trip _snapshot = Provider.of<FlightSearch>(context).data;
    final Size _width = MediaQuery.of(context).size;
    print(_width.width);
    return CustomScrollView(
      controller: scrollController,
      // cacheExtent: 25,
      reverse: true,
      physics: BouncingScrollPhysics(),
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return AnimationConfiguration.synchronized(
                //position: index,
                child: ScaleAnimation(
                  // scale: 2,
                  child: FadeInAnimation(
                    child: InkWell(
                      onTap: () async {
                        final String url = _snapshot.data[index].deepLink;
                        await canLaunch(url)
                            ? await launch(url)
                            : throw 'Could not launch $url';
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            // topLeft: const Radius.circular(16),
                            // topRight:
                            const Radius.circular(16),
                          ),
                          color: index == 0
                              ? Colors.lightGreenAccent
                              : Colors.blueGrey,
                        ),
                        child: Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(16),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              MidLayer(
                                index: index,
                              ),
                              _isOneWay.isOneWay == true
                                  ? Container()
                                  : Divider(
                                      color: Colors.black,
                                      endIndent: 16,
                                      indent: 16,
                                    ),
                              _isOneWay.isOneWay == true
                                  ? Container()
                                  : BottomLayer(
                                      index: index,
                                    ),
                              TopLayer(
                                index: index,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // position: index,
              );
            },
            childCount: _snapshot.data.length ?? 1,
            // _snapshot.data.length,
          ),
        )
      ],
    );
  }
}

class TopLayer extends StatelessWidget {
  const TopLayer({Key key, @required int index})
      : index = index,
        super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    final _snapshot = Provider.of<FlightSearch>(context).data;

    return Container(
      decoration: const BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: const Radius.circular(16),
          bottomRight: const Radius.circular(16),
        ),
        color: Colors.blueGrey, //Color.fromARGB(255, 100, 135, 165),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(16),
                ),
              ),
              margin: const EdgeInsets.only(left: 4.0),
              height: 40,
              // width: MediaQuery.of(context).size.width * .66,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _snapshot.data[index].airlines.length,
                itemBuilder: (context, i) => Container(
                  padding: const EdgeInsets.only(right: 2),
                  child: Image.network(
                    'https://images.kiwi.com/airlines/64/${_snapshot.data[index].airlines[i]}.png',
                  ),
                ),
              ),
            ),
          ),
          // For AirlineLogos

          Container(
            width: 120,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    bottomRight: const Radius.circular(16)),
              ),
              color: const Color(0xcFF2ed199),
              elevation: 2,
              child: Container(
                padding: const EdgeInsets.all(4),
                // width: MediaQuery.of(context).size.width * .25,
                child: Center(
                  child: Text(
                    '\$' + _snapshot.data[index].price.toString(),
                    textScaleFactor: 2,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MidLayer extends StatelessWidget {
  const MidLayer({
    Key key,
    @required int index,
  })  : index = index,
        super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    final _snapshot = Provider.of<FlightSearch>(context).data;

    String originDepartureTime() =>
        '${DateFormat.MMMd().add_jm().format(DateTime.fromMillisecondsSinceEpoch(_snapshot.data[index].route.first.dTimeUtc * 1000))}';

    String destinationArrivalTime() {
      String dtime;

      for (int n = 0; n < _snapshot.data[index].route.length; n++) {
        if (_snapshot.data[index].route[n].flyTo ==
            _snapshot.data[index].routes[0][1]) {
          dtime =
              '${DateFormat.MMMd().add_jm().format(DateTime.fromMillisecondsSinceEpoch(_snapshot.data[index].route[n].aTime * 1000, isUtc: true))}';
        }
      }
      return dtime.toString();
    }

    return Container(
      padding: EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Column(
            children: <Widget>[
              Chip(
                label: Text(
                  _snapshot.data[index].cityFrom,
                  textScaleFactor: 1,
                ),
              ),
              Text(
                _snapshot.data[index].routes[0][0],
                textScaleFactor: 3,
              ),
              Chip(
                label: Text(
                  originDepartureTime(),
                  textScaleFactor: 1,
                ),
              ),
            ],
          ),
          Chip(
            label: Text(_snapshot.data[index].flyDuration),
          ),
          Column(
            children: <Widget>[
              Chip(
                label: Text(
                  _snapshot.data[index].cityTo,
                  textScaleFactor: 1,
                ),
              ),
              Text(
                _snapshot.data[index].routes[0][1],
                textScaleFactor: 3,
              ),
              Chip(
                label: Text(
                  destinationArrivalTime(),
                  textScaleFactor: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BottomLayer extends StatelessWidget {
  const BottomLayer({
    Key key,
    @required int index,
  })  : index = index,
        super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    final _snapshot = Provider.of<FlightSearch>(context).data;

    String returnDepartureTime() {
      String dtime;

      for (int n = 0; n < _snapshot.data[index].route.length; n++) {
        if (_snapshot.data[index].route[n].routeReturn == 1 &&
            (_snapshot.data[index].route[n].flyFrom ==
                _snapshot.data[index].routes[1][0])) {
          dtime =
              '${DateFormat.MMMd().add_jm().format(DateTime.fromMillisecondsSinceEpoch(_snapshot.data[index].route[n].dTime * 1000, isUtc: true))}';
        }
      }
      return dtime.toString();
    }

    String returnArrivalTime() =>
        '${DateFormat.MMMd().add_jm().format(DateTime.fromMillisecondsSinceEpoch(_snapshot.data[index].route.last.aTime * 1000, isUtc: true))}';

    String returnDepartureAirport() {
      String city;
      for (int n = 0; n < _snapshot.data[index].route.length; n++) {
        if (_snapshot.data[index].route[n].routeReturn == 1 &&
            (_snapshot.data[index].route[n].flyFrom ==
                _snapshot.data[index].routes[1][0])) {
          city = _snapshot.data[index].route[n].cityFrom;
        }
      }
      return city.toString();
    }

    String returnArrivalAirport() {
      String city;
      for (int n = 0; n < _snapshot.data[index].route.length; n++) {
        if (_snapshot.data[index].route[n].routeReturn == 1 &&
            (_snapshot.data[index].route[n].flyTo ==
                _snapshot.data[index].routes[1][1])) {
          city = _snapshot.data[index].route[n].cityTo;
        }
      }
      return city;
    }

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Column(
            children: <Widget>[
              Chip(
                label: Text(
                  returnDepartureAirport(),
                  textScaleFactor: 1,
                ),
              ),
              Text(
                _snapshot.data[index].routes[1][0],
                textScaleFactor: 3,
              ),
              Chip(
                label: Text(
                  returnDepartureTime(),
                  textScaleFactor: 1,
                ),
              ),
            ],
          ),
          Chip(
            label: Text(_snapshot.data[index].returnDuration),
          ),
          Column(
            children: <Widget>[
              Chip(
                label: Text(
                  returnArrivalAirport(),
                  textScaleFactor: 1,
                ),
              ),
              Text(
                _snapshot.data[index].routes[1][1],
                textScaleFactor: 3,
              ),
              Chip(
                label: Text(
                  returnArrivalTime(),
                  textScaleFactor: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
