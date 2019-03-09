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
  final TextEditingController _nameController = TextEditingController();
  dynamic _userEmail;
  dynamic _userName;
  GoogleSignInAccount _currentUser;
  Future<void> displayName() async {
    FirebaseUser mCurrentUser = await FirebaseAuth.instance.currentUser();
    _userName = mCurrentUser.displayName;
  }

  bool _success;
  String _userID;
  String _uName  ;
  String _uEmail;
  bool _uVerfied;
  String _uPhoto;
  Type _uRunTimeType;
  String _uPhone;
  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
  }
  Widget build(BuildContext context) {
    return new Drawer(
      child: new ListView(children: <Widget>[
        /*UserAccountsDrawerHeader(
        accountName: Text("Name: " + _uName),
        //accountEmail: Text("Email: " + _uEmail),
        //currentAccountPicture: Image.network(_uPhoto),
        /*FutureBuilder(
          future: FirebaseAuth.instance.currentUser(),
          builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data.email);
            } else {
              return Text('Loading..');
            }
          },
        ),*/
        /*new CircleAvatar(
            backgroundColor: Colors.orange,
             child: Image.network(_uPhoto)
        ),*/
      ),*/
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
                //child: Image.network(_uPhoto),
                ),
            Container(
              child: Text("Name: ${_currentUser.displayName}"),
            ),
            Container(
              child: Text("Email: ${_currentUser.email}"),
            ),
          ],
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
                  leading: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    alignment: Alignment.center,
                    child: RaisedButton(
                      onPressed: () async {
                        _signInWithGoogle();
                      },
                      child: const Text('Sign in with Google'),
                    ),
                  ),
                ),
                ListTile(
                  subtitle: Text(
                    _success == null
                        ? ''
                        : (_success
                            ? 'Successfully signed in,\n ' +
                                'UID: $_userID \n ' +
                                'UserName: $_uName\n ' +
                                'UserEmail: $_uEmail \n' +
                                'IsVerfied: $_uVerfied \n' +
                                'PhotoUrl: $_uPhoto \n ' +
                                'Runtime Type: $_uRunTimeType \n ' +
                                'PhoneNumber: $_uPhone'
                            : 'Sign in failed'),
                    style: TextStyle(
                      color: Colors.red,
                    ),
                    /*"Data 4",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),*/
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
      ]),
    );
  }

  void _signOut() async {
    await _auth.signOut();
  }

  void _signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser user = await _auth.signInWithCredential(credential);
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    setState(() {
      if (user != null) {
        _success = true;
        _userID = user.uid;
        _uName = user.displayName;
        _uEmail = user.email;
        _uVerfied = user.isEmailVerified;
        _uPhoto = user.photoUrl;
        _uPhone = user.phoneNumber;
        _uRunTimeType = user.runtimeType;
      } else {
        _success = false;
      }
    });
  }
}
