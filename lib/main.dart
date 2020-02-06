import 'package:flutter/material.dart';
// import 'package:flutter_driver/driver_extension.dart';
import 'package:flyxweb/root.dart';
import 'package:flyxweb/services/Auth/Auth.dart';
import 'package:flyxweb/services/AutoComplete/AutoComplete.dart';
import 'package:flyxweb/services/NearBy/NearBy.dart';
import 'package:flyxweb/services/TicketNetworkCall/Request.dart';
import 'package:flyxweb/services/UserQuery/UserQuery.dart';
import 'package:hive/hive.dart';
<<<<<<< HEAD
import 'package:hive_flutter/hive_flutter.dart';
=======
>>>>>>> 42aa53c25962b24e009aa456f0f3dafd73fc754f
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
<<<<<<< HEAD
=======

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  AppLifecycleState _appLifecycleState;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _appLifecycleState = state;
      print("My App State: $_appLifecycleState");
    });
  }

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
>>>>>>> 42aa53c25962b24e009aa456f0f3dafd73fc754f
