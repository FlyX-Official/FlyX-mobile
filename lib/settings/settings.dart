import 'package:flyx/FloatingActionButton/fab_bottom_app_bar.dart';
import 'package:flyx/FloatingActionButton/layout.dart';
import 'package:flyx/SideBar/AppDrawer.dart';
import 'package:flutter/material.dart';
// pages
import 'package:flyx/settings/pages/TermsNConditions.dart';
import 'package:flyx/settings/pages/Notifications.dart';
import 'package:flyx/settings/pages/About.dart';
import 'package:flyx/settings/pages/Privacy.dart';

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
          margin: const EdgeInsets.only(top: 10.0),
          width: 90.0,
          height: 190.0,
          decoration: new BoxDecoration(
              border: Border(bottom: BorderSide()),
              shape: BoxShape.circle,
              image: new DecorationImage(
                  //fit: BoxFit.fill,

                  image: AssetImage('lib/assets/images/Logo.png'))),
        ),
        Container(
          padding: new EdgeInsets.all(32.0),
          child: new Center(
            child: new Column(
              children: <Widget>[
                ListTile(
                  title: Text('USER SETTINGS'),
                ),
                ListTile(
                  title: const Text(
                    "My Account",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                        decoration: TextDecoration.underline),
                  ),
                  onTap: () {/* redirect to terms and conditions page */},
                  leading: Icon(Icons.account_box),
                ),
                ListTile(
                  title: const Text(
                    "Privacy & Safety",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                        decoration: TextDecoration.underline),
                  ),
                  onTap: () {/* redirect to terms and conditions page */
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Privacy()));
                  },
                  leading: Icon(Icons.security),
                ),
              ],
            ),
          ),
          decoration: BoxDecoration(border: Border(bottom: BorderSide())),
        ),
        Container(
          padding: new EdgeInsets.all(32.0),
          child: new Center(
            child: new Column(
              children: <Widget>[
                ListTile(
                  title: Text('APP SETTINGS'),
                ),
                new SwitchListTile(
                  
                  value: _mode,
                  onChanged: _onChangedMode,
                  title: new Text('App Mode',
                      style: new TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                          
                ),
                ListTile(
                  title: const Text(
                    "Notifications",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                        decoration: TextDecoration.underline),
                  ),
                  onTap: () {/* redirect to terms and conditions page */
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Notifications()));
                  },
                  leading: Icon(Icons.notifications),
                ),
              ],
            ),
          ),
          decoration: BoxDecoration(border: Border(bottom: BorderSide())),
        ),
        Container(
          padding: new EdgeInsets.all(32.0),
          child: new Center(
            child: new Column(children: <Widget>[
              ListTile(
                title: Text('APP INFORMATION'),
              ),
              ListTile(
                title: const Text(
                  'About ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                      decoration: TextDecoration.underline),
                  
                ),
                onTap: () {/* redirect to terms and conditions page */
                  Navigator.push(context, MaterialPageRoute(builder:(context)=>About()));
                },
                leading: Icon(Icons.airplanemode_active),
              ),
              ListTile(
                title: const Text(
                  "Terms and Conditions",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                      decoration: TextDecoration.underline),
                ),
                onTap: () {/* redirect to terms and conditions page */
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>TermsNConditions()));
                },
                leading: Icon(Icons.info),
              ),

            ]),
          ),
        ),
      ],
    );
  }
}
