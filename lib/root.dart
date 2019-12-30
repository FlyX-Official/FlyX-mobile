import 'package:flutter/material.dart';
import 'package:flyxweb/screens/HomeScreen/HomeScreen.dart';
import 'package:flyxweb/screens/LandingPageScreen/LandingPageScreen.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Root extends StatelessWidget {
  const Root({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => WatchBoxBuilder(
        box: Hive.box('User'),
        builder: (context, box) =>
            box.values.isNotEmpty ? HomeScreen() : HomeScreen(),
      );
}
