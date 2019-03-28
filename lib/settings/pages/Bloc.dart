
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class Bloc{
  final _themeController =StreamController<bool>();
  get changeTheme => _themeController.sink.add;
  get darkThemeEnabled => _themeController.stream;
}
final bloc =Bloc();