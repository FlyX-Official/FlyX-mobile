import 'package:flutter/material.dart';
import 'package:flyx/profile/profile.dart';
import 'package:flyx/settings/settings.dart';
//SignIn 
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flyx/LoginPage/login_page.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

class AppDrawer extends StatefulWidget {
  static String tag = 'AppDrawer';
  @override
  _AppDrawerState createState() => new _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController =
      TextEditingController();
  dynamic _userEmail ;
  dynamic _userName;
  
Future<FirebaseUser> _getNameEmail() async {
    
      FirebaseUser user = await _auth.currentUser();
        /*accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,*/
        
      print("userNAme: ${user.displayName}");
       _userName = user.displayName;
      _userEmail = user.email;
      
    }
Future<void> displayName() async {
      FirebaseUser mCurrentUser = await FirebaseAuth.instance.currentUser();
      _userName = mCurrentUser.displayName;
  }

 

  @override
  Widget build(BuildContext context) {
    return new Drawer(
        child: new ListView(children: <Widget>[
      UserAccountsDrawerHeader(
        accountName: Text("Name: "+_userEmail.toString()),
        accountEmail:   FutureBuilder(
          future: FirebaseAuth.instance.currentUser(),
          builder: (context, AsyncSnapshot<FirebaseUser> snapshot){
            if(snapshot.hasData){
              return Text(snapshot.data.email);
            }else{
              return Text('Loading..');
            }
          },
        ),
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
              ),
              ListTile(
                title: Text(
                  "Sign Out",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () async {
                final FirebaseUser user = await _auth.currentUser();
                if (user == null) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: const Text('No one has signed in.'),
                  ));
                  return;
                }
                _signOut();
                final String uid = user.uid;
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(uid + ' has successfully signed out.'),
                ));
              },
                leading: Icon(Icons.exit_to_app),
              ),
            ],
          ),
        ],
      )
    ]));
  }
  void _signOut() async {
    await _auth.signOut();
  }
 
}
  