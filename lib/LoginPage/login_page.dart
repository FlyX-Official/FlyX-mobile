import 'dart:ui';
import 'dart:async';

import 'package:flutter/services.dart';

import 'package:local_auth/local_auth.dart';
import 'package:flyx/Biometrics/bioAuth.dart';

import 'package:transparent_image/transparent_image.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flyx/InputPage/inputForm.dart';
import 'package:flyx/style/theme.dart' as Theme;

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  final Widget child;

  LoginPage({Key key, this.child}) : super(key: key);

  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  PageController _pageController;
  //SignIn Controllers
  final TextEditingController _signInEmailController = TextEditingController();
  final TextEditingController _signInPasswordController =
      TextEditingController();

  final TextEditingController _signUpNameController = TextEditingController();
  final TextEditingController _signUpEmailController = TextEditingController();
  final TextEditingController _signUpPasswordController =
      TextEditingController();
  final TextEditingController _signUpPasswordConfirmController =
      TextEditingController();

  final GlobalKey<FormState> _signInFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _signupFormKey = GlobalKey<FormState>();

  String userEmailStore = "";
  bool _successSignUp;
  bool _successLogin;
  String _userEmail = "";
  String _errorMessage = "";
  GoogleSignInAccount _currentUser;
  bool _success;
  String _userID;
  String _uName;
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
        if (_googleSignIn.isSignedIn == true) {
          Navigator.of(context).pushNamed(InputForm.tag);
        }
      });
    });
    _googleSignIn.signInSilently();
  }

  Widget build(BuildContext context) {
    dynamic _height = MediaQuery.of(context).size.height;
    dynamic _width = MediaQuery.of(context).size.width;
    dynamic _fourFifthsWidth= _width * .85;
    
    return Scaffold(
      body: Container(
        color: Color.fromARGB(225, 73, 144, 226),
        child: PageView(
          controller: _pageController,
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            Center(child: buildSignIn(_height, _width, _fourFifthsWidth)),
            Center(child: buildSignUp(_height, _width, _fourFifthsWidth)),
          ],
        ),
      ),
    );
  }

//Login Code Begin
  SingleChildScrollView buildSignIn(_height, _width, _fourFifthsWidth) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      controller: _pageController,
      child: Form(
        key: _signInFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
               height: _height * .5,
              width: _width,
              //color: Color.fromARGB(0, 73, 144, 226),//Colors.white,
              child: FadeInImage.memoryNetwork(
                image:
                    'https://avatars0.githubusercontent.com/u/43255530?s=200&v=4',
                //height: _height * .33,
                fadeOutDuration: const Duration(milliseconds: 500),
                placeholder: kTransparentImage,
                // filterQuality: FilterQuality.high,
              ),
            ),
            //Logo PlaceHolder
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: _fourFifthsWidth,
                  child: signInEmail("Email", Icons.mail_outline),
                ),
                Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  overflow: Overflow.visible,
                  children: <Widget>[
                    Container(
                      width: _fourFifthsWidth,
                      child: signInPassword("Password", Icons.lock_outline),
                      margin: EdgeInsets.only(bottom: 25),
                    ),
                    Container(
                      //rmargin: EdgeInsets.only(top:125),
                      child: buildLoginCard(),
                    ),
                  ],
                ),
                Container(
                  child: buildSeparator(),
                ),
                Container(
                  child:
                      buildThirdPartySignIn(), //google,facebook,twitter signin buttons
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container signInEmail(String text, dynamic fieldIcon) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 8,
        child: Padding(
          padding: EdgeInsets.all(25.0),
          child: TextFormField(
            autofocus: false,
            //focusNode: myFocusNodeEmailLogin,
            controller: _signInEmailController,
            textInputAction: TextInputAction.newline,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
                fontFamily: "Nunito", fontSize: 16.0, color: Colors.black),
            decoration: InputDecoration(
              border: InputBorder.none,
              icon: Icon(
                fieldIcon,
                color: Colors.redAccent,
                size: 22.0,
              ),
              hintText: text,
              hintStyle: TextStyle(fontFamily: "Nunito", fontSize: 17.0),
            ),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
            },
          ),
        ),
      ),
    );
  }

  Container signInPassword(String text, dynamic fieldIcon) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 8,
        child: Padding(
          padding: EdgeInsets.all(25.0),
          child: TextFormField(
            autofocus: false,
            obscureText: true,
            //focusNode: myFocusNodeEmailLogin,
            controller: _signInPasswordController,
            textInputAction: TextInputAction.newline,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
                fontFamily: "Nunito", fontSize: 16.0, color: Colors.black),
            decoration: InputDecoration(
              border: InputBorder.none,
              icon: Icon(
                fieldIcon,
                color: Colors.redAccent,
                size: 22.0,
              ),
              hintText: text,
              hintStyle: TextStyle(fontFamily: "Nunito", fontSize: 17.0),
            ),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
            },
          ),
        ),
      ),
    );
  }

  Card buildLoginCard() {
    return Card(
      elevation: 8,
      color: Colors.lightGreenAccent,
      child: FlatButton.icon(
        highlightColor: Colors.transparent,
        splashColor: Theme.Colors.loginGradientEnd,
        color: Colors.lightGreenAccent,
        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
        icon: Icon(Icons.fingerprint),
        label: Text(
          "LOGIN",
          style: TextStyle(
            color: Colors.black,
            fontSize: 25.0,
            fontFamily: "Nunito",
          ),
        ),
        onPressed: _emailPasswordSignIn,
      ),
    );
  }

  Padding buildSeparator() {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: new LinearGradient(
                  colors: [
                    Colors.white10,
                    Colors.white,
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 1.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
            width: MediaQuery.of(context).size.width * .33,
            height: 1.0,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: new LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.white10,
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 1.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
            width: MediaQuery.of(context).size.width * .33,
            height: 1.0,
          ),
        ],
      ),
    );
  }

  Future<void> _emailPasswordSignIn() async {
    final formState = _signInFormKey.currentState;
    bool alertError = false;
    if (_signInFormKey.currentState.validate()) {
      formState.save();
      try {
        FirebaseUser userLoginEmailPassword;
        userLoginEmailPassword = await _auth.signInWithEmailAndPassword(
          email: _signInEmailController.text,
          password: _signInPasswordController.text,
        );
        print("UserName: ${userLoginEmailPassword.displayName}");
        userEmailStore = userLoginEmailPassword.displayName;
        Navigator.of(context).pushNamed(InputForm.tag);
      } catch (e) {
        print(e.message);
        alertError = true;
      }
    }
    if (alertError == true) {
      return AlertDialog(
        title: Text('Error loggin in'),
        content: Text('Re-enter ID/Passowrd'),
      );
    }
  }

  ButtonBar buildThirdPartySignIn() {
    return ButtonBar(
      
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        FlatButton.icon(
          color: Colors.white,
          icon: Icon(FontAwesomeIcons.google),
          label: Text("Google"),
          onPressed: () async {
            _signIn();
            Navigator.of(context).pushNamed(InputForm.tag);
          },
        ),
        //FlatButton(),
        //FlatButton(),
      ],
    );
  }

  Future<void> _signIn() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final FirebaseUser user = await _auth.signInWithCredential(credential);
      print("signed in " + user.displayName);
    } catch (error) {
      print(error);
    }
  }
//Login Code End

//SignUp Code Begin

  SingleChildScrollView buildSignUp(_height, _width, _fourFifthsWidth) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      controller: _pageController,
      //height: _height * .5,
      //color: Color.fromARGB(0, 73, 144, 226), //Colors.white,
      child: Form(
        key: _signupFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          //mainAxisSize: MainAxisSize.min,
          /* alignment: AlignmentDirectional.center,
          overflow: Overflow.clip,
          fit: StackFit.loose,*/
          children: <Widget>[
            /*Container(
              height: _height * .33,
              width: _width,
              color: Color.fromARGB(255, 73, 144, 226),//Colors.black,
              child: Image.network(
                  'https://avatars0.githubusercontent.com/u/43255530?s=200&v=4'),
            ),*/
            //Logo PlaceHolder
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              //mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  child: _showErrorMessage(),
                ),
                Container(
                  width: _fourFifthsWidth,
                  child: signUpName("Name", Icons.mail_outline),
                ),
                Container(
                  width: _fourFifthsWidth,
                  child: signUpEmail("Email", Icons.mail_outline),
                ),
                Container(
                  width: _fourFifthsWidth,
                  child: signUpPassword("Password", Icons.lock_outline),
                ),
                Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  overflow: Overflow.visible,
                  children: <Widget>[
                    Container(
                      width: _fourFifthsWidth,
                      margin: EdgeInsets.only(bottom: 25),
                      child: signUpPasswordConfirmation(
                          "Confirmation", Icons.lock_outline),
                    ),
                    Container(
                      child: buildSignUpCard(),
                    ),
                  ],
                ),
                Container(
                  child: buildSeparator(),
                ),
                Container(
                  child:
                      buildThirdPartySignIn(), //google,facebook,twitter signin buttons
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Card buildSignUpCard() {
    return Card(
      elevation: 8,
      color: Colors.lightGreenAccent,
      child: FlatButton.icon(
        color: Colors.lightGreenAccent,
        highlightColor: Colors.transparent,
        splashColor: Theme.Colors.loginGradientEnd,
        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
        icon: Icon(Icons.security),
        label: Text(
          "SIGN UP",
          style: TextStyle(
            color: Colors.black,
            fontSize: 25.0,
            fontFamily: "Nunito",
          ),
        ),
        onPressed: () async {
          if (_signupFormKey.currentState.validate()) {
            _register();
            //_authenticate;
          }
          Navigator.of(context).pushNamed(InputForm.tag);
        },
        /*() {
                     //Navigator.of(context).pushNamed(FloatActBttn.tag);
                      Navigator.of(context).pushNamed(InputForm.tag);
                    }*/
      ),
    );
  }

  void _register() async {
    final FirebaseUser user = await _auth.createUserWithEmailAndPassword(
      email: _signUpEmailController.text,
      password: _signUpPasswordController.text,
    );

    if (user != null) {
      //Navigator.of(context).pushNamed(InputForm.tag);
      setState(() {
        _successSignUp = true;
        _userEmail = user.email;
      });
    } else {
      _successSignUp = false;
    }
  }

  Widget _showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Container signUpName(String text, dynamic fieldIcon) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 8,
        child: Padding(
          padding: EdgeInsets.all(25.0),
          child: TextFormField(
            autofocus: false,
            //focusNode: myFocusNodeEmailLogin,
            controller: _signUpNameController,
            textInputAction: TextInputAction.newline,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
                fontFamily: "Nunito", fontSize: 16.0, color: Colors.black),
            decoration: InputDecoration(
              border: InputBorder.none,
              icon: Icon(
                fieldIcon,
                color: Colors.redAccent,
                size: 22.0,
              ),
              hintText: text,
              hintStyle: TextStyle(fontFamily: "Nunito", fontSize: 17.0),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Name cannot be Empty';
              }
            },
          ),
        ),
      ),
    );
  }

  Container signUpEmail(String text, dynamic fieldIcon) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 8,
        child: Padding(
          padding: EdgeInsets.all(25.0),
          child: TextFormField(
            autofocus: false,
            //focusNode: myFocusNodeEmailLogin,
            controller: _signUpEmailController,
            textInputAction: TextInputAction.newline,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
                fontFamily: "Nunito", fontSize: 16.0, color: Colors.black),
            decoration: InputDecoration(
              border: InputBorder.none,
              icon: Icon(
                fieldIcon,
                color: Colors.redAccent,
                size: 22.0,
              ),
              hintText: text,
              hintStyle: TextStyle(fontFamily: "Nunito", fontSize: 17.0),
            ),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Email field cannot be empty';
              }
            },
          ),
        ),
      ),
    );
  }

  Container signUpPassword(String text, dynamic fieldIcon) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 8,
        child: Padding(
          padding: EdgeInsets.all(25.0),
          child: TextFormField(
            autofocus: false,
            obscureText: true,
            //focusNode: myFocusNodeEmailLogin,
            controller: _signUpPasswordController,
            textInputAction: TextInputAction.newline,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
                fontFamily: "Nunito", fontSize: 16.0, color: Colors.black),
            decoration: InputDecoration(
              border: InputBorder.none,
              icon: Icon(
                fieldIcon,
                color: Colors.redAccent,
                size: 22.0,
              ),
              hintText: text,
              hintStyle: TextStyle(fontFamily: "Nunito", fontSize: 17.0),
            ),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Password Field cannot be empty';
              }
            },
          ),
        ),
      ),
    );
  }

  Container signUpPasswordConfirmation(String text, dynamic fieldIcon) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 8,
        child: Padding(
          padding: EdgeInsets.all(25.0),
          child: TextFormField(
            autofocus: false,
            obscureText: true,
            //focusNode: myFocusNodeEmailLogin,
            controller: _signUpPasswordConfirmController,
            textInputAction: TextInputAction.newline,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
                fontFamily: "Nunito", fontSize: 16.0, color: Colors.black),
            decoration: InputDecoration(
              border: InputBorder.none,
              icon: Icon(
                fieldIcon,
                color: Colors.redAccent,
                size: 22.0,
              ),
              hintText: text,
              hintStyle: TextStyle(fontFamily: "Nunito", fontSize: 17.0),
            ),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Confirmation Field cannot be empty.';
              }
            },
          ),
        ),
      ),
    );
  }
//SignUp Code End
}

/*void _signInWithGoogle() async {
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
}*/
