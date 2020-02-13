import 'package:flutter/material.dart';
// import 'package:flutter_driver/driver_extension.dart';
import 'package:FlyXWebSource/root.dart';
import 'package:FlyXWebSource/services/Auth/Auth.dart';
import 'package:FlyXWebSource/services/AutoComplete/AutoComplete.dart';
import 'package:FlyXWebSource/services/NearBy/NearBy.dart';
import 'package:FlyXWebSource/services/TicketNetworkCall/Request.dart';
import 'package:FlyXWebSource/services/UserQuery/UserQuery.dart';
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
