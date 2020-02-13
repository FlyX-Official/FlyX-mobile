import 'package:flutter/material.dart';
import 'package:FlyXWebSource/screens/HomeScreen/HomeScreen.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Root extends StatelessWidget {
  const Root({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
        valueListenable: Hive.box('User').listenable(),
        builder: (context, box, widget) =>
            box.values.isNotEmpty ? HomeScreen() : HomeScreen(),
      );
}
