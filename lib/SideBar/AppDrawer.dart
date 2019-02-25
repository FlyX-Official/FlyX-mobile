import 'package:flutter/material.dart';
import 'package:wefly/profile/profile.dart';

class AppDrawer extends StatefulWidget{
  static String tag = 'AppDrawer';
  @override
  _AppDrawerState createState() => new _AppDrawerState();

}
class _AppDrawerState extends State<AppDrawer>{
  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: new ListView(       
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: new Text("John Doe"),
            accountEmail: new Text("JohnDoe@sample.com"),
            currentAccountPicture: new CircleAvatar(
              backgroundColor: Colors.orange,
              child:new Text("J",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ListBody(children: <Widget>[
                DrawerHeader(child: Text(""),),

                SizedBox(
                  height: 20.0,
                ),

                Divider(),
                Container(
                  decoration: BoxDecoration(
                    // border
                  ),
                  child: ListTile(
                    title: Text("Data 1",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                    ),
                    onTap: (){
                      Navigator.pop(context);
                    },
                    leading: Icon(Icons.open_in_new),
                    
                  ),
                ),
                ListTile(
                  title: Text("Data 2",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                    ),
                  onTap: (){
                    Navigator.of(context).pushNamed(Profile.tag);
                  },
                  leading: Icon(Icons.person_add),
                ),
                ListTile(
                  title: Text("Data 3",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                    ),
                  onTap: (){
                    Navigator.pop(context);
                  },
                  leading: Icon(Icons.pin_drop),
                ),
                ListTile(
                  title: Text("Data 4",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                    ),
                  onTap: (){
                    Navigator.pop(context);
                  },
                  leading: Icon(Icons.save),
                ),
                ListTile(
                  title: Text("Data 5",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                    ),
                  onTap: (){
                    Navigator.pop(context);
                  },
                  leading: Icon(Icons.settings),
                )
                ],   
              ),
            ],
          )
        ]
      ) 
    );
  }

}
