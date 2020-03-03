import 'package:flutter/material.dart';
// import 'package:flutter_driver/driver_extension.dart';
import 'package:flyx/root.dart';
import 'package:flyx/services/Auth/Auth.dart';
import 'package:flyx/services/AutoComplete/AutoComplete.dart';
import 'package:flyx/services/NearBy/NearBy.dart';
import 'package:flyx/services/TicketNetworkCall/Request.dart';
import 'package:flyx/services/UserQuery/UserQuery.dart';
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
          lazy: true,
        ),
        ChangeNotifierProvider(
          create: (_) => FetchNearBy(),
          lazy: true,
        ),
        ChangeNotifierProvider(
          create: (_) => AutoCompleteCall(),
          lazy: true,
        ),
        ChangeNotifierProvider(
          create: (_) => UserQuery(),
          lazy: true,
        ),
        ChangeNotifierProvider(
          create: (_) => FlightSearch(),
          lazy: true,
        )
      ],
      child: MaterialApp(
        home: const Root(),
      ),
    ),
  );
}
