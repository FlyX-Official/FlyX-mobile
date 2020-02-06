import 'package:flutter/material.dart';
// import 'package:flutter_driver/driver_extension.dart';
import 'package:flyxweb/root.dart';
import 'package:flyxweb/services/Auth/Auth.dart';
import 'package:flyxweb/services/AutoComplete/AutoComplete.dart';
import 'package:flyxweb/services/NearBy/NearBy.dart';
import 'package:flyxweb/services/TicketNetworkCall/Request.dart';
import 'package:flyxweb/services/UserQuery/UserQuery.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  // Enable integration testing with the Flutter Driver extension.
  // See https://flutter.dev/testing/ for more info.
  // enableFlutterDriverExtension();
  await Hive.initFlutter().whenComplete(
    () async => await Future.wait(
      [
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
      ],
    ),
  );
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
      child: MaterialApp(
        home: const Root(),
      ),
    ),
  );
}
