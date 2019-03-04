import 'package:flyx/FloatingActionButton/fab_bottom_app_bar.dart';
import 'package:flyx/FloatingActionButton/layout.dart';
import 'package:flyx/SideBar/AppDrawer.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  // tag to main
  static String tag = 'settings-page';
  Settings({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _Settings createState() => new _Settings();
}

class _Settings extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Center(),
      /* the body goes here */
      body: _Body(context),
    );
  }

  // variables
  bool _mode = true;

  // functions
  // function for day/night mode
  void _onChangedMode(bool value) => setState(() => _mode = value);

  // function to run as soon as app opens
  void initState() {}

  // Widgets
  Widget _Body(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          padding: new EdgeInsets.all(32.0),
          child: new Center(
            child: new Column(
              children: <Widget>[
                new SwitchListTile(
                  value: _mode,
                  onChanged: _onChangedMode,
                  title: new Text('App Mode',
                      style: new TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                ),
                new ListTile(
                  title: const Text(
                    "Terms and Conditions",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                        decoration: TextDecoration.underline),
                  ),
                  onTap: () {/* redirect to terms and conditions page */},
                )
              ],
            ),
          ),
          decoration: BoxDecoration(border: Border(bottom: BorderSide())),
        ),
      ],
    );
  }
}
