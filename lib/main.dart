import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_driver/driver_extension.dart';
import 'package:flyxweb/root.dart';
import 'package:flyxweb/services/Auth/Auth.dart';
import 'package:flyxweb/services/AutoComplete/AutoComplete.dart';
import 'package:flyxweb/services/NearBy/NearBy.dart';
import 'package:flyxweb/services/TicketNetworkCall/Request.dart';
import 'package:flyxweb/services/UserQuery/UserQuery.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

void main() {
  // Enable integration testing with the Flutter Driver extension.
  // See https://flutter.dev/testing/ for more info.
  // enableFlutterDriverExtension();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (_) => FetchNearBy(),
        ),
        ChangeNotifierProvider(
          create: (_) => AutoCompleteCall(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserQuery(),
        ),
        ChangeNotifierProvider(
          create: (_) => FlightSearch(),
        )
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  Future _openBoxes() async {
    // print('path is' + dir.path);

    return Future.wait([
      Hive.openBox(
        'User',
        crashRecovery: false,
      ),
      Hive.openBox(
        'FavOriginAirports',
        crashRecovery: false,
      ),
      Hive.openBox(
        'FavDestinationAirports',
        crashRecovery: false,
      ),
      Hive.openBox(
        'Tickets',
        crashRecovery: true,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);

    return MaterialApp(
      home: Scaffold(
        body: FutureBuilder(
          future: _openBoxes(),
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.done
                  ? snapshot.error != null
                      ? Scaffold(
                          body: Center(
                            child: Text('Something went wrong :/'),
                          ),
                        )
                      : const Root()
                  : Scaffold(
                      body: Center(
                        child: const Text('Opening Hive...'),
                      ),
                    ),
        ),
      ),
    );
  }
}
