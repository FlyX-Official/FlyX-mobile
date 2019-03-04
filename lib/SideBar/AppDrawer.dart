import 'package:flutter/material.dart';
import 'package:flyx/profile/profile.dart';
import 'package:flyx/settings/settings.dart';


class AppDrawer extends StatefulWidget {
  static String tag = 'AppDrawer';
  @override
  _AppDrawerState createState() => new _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return new Drawer(
        child: new ListView(children: <Widget>[
      UserAccountsDrawerHeader(
        accountName: new Text("John Doe"),
        accountEmail: new Text("JohnDoe@sample.com"),
        currentAccountPicture: new CircleAvatar(
          backgroundColor: Colors.orange,
          child: new Text(
            "J",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
              color: Colors.black,
            ),
          ),
        ),
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          ListBody(
            children: <Widget>[
              Container(
                alignment: Alignment.bottomCenter,
                child: ListTile(
                  title: Text(
                    "Data 1",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  "Data 2",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
                leading: Icon(Icons.person_add),
              ),
              ListTile(
                title: Text(
                  "Profile",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(Profile.tag);
                },
                leading: Icon(Icons.open_in_new),
              ),
              ListTile(
                title: Text(
                  "Data 3",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
                leading: Icon(Icons.pin_drop),
              ),
              ListTile(
                title: Text(
                  "Data 4",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
                leading: Icon(Icons.save),
              ),
              ListTile(
                title: Text(
                  "Settings",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  //Navigator.pop(context);
                  Navigator.of(context).pushNamed(Settings.tag);
                },
                leading: Icon(Icons.settings),
              )
            ],
          ),
        ],
      )
    ]));
  }
}
