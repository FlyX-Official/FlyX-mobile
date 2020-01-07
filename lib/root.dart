import 'package:flutter/material.dart';
import 'package:flyx/screens/HomeScreen/HomeScreen.dart';
import 'package:flyx/screens/LoginScreen/LoginScreen.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Root extends StatelessWidget {
  const Root({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
        valueListenable: Hive.box('User').listenable(),
        builder: (_, box, __) =>
            box.values.isNotEmpty ? HomeScreen() : LoginSceen(), 
      );
}
