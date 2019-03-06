import 'dart:ui';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:local_auth/local_auth.dart';
import 'package:flyx/Biometrics/bioAuth.dart';

import 'package:transparent_image/transparent_image.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flyx/InputPage/inputForm.dart';
import 'package:flyx/style/theme.dart' as Theme;

final FirebaseAuth _auth = FirebaseAuth.instance;

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  final Widget child;

  LoginPage({Key key, this.child}) : super(key: key);

  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LocalAuthentication auth = LocalAuthentication();
  //start SignUp Controllers
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _signUpEmailController = TextEditingController();
  final TextEditingController _signUpPasswordController =
      TextEditingController();
  final TextEditingController _signUpNameController = TextEditingController();
  final TextEditingController _signUpPasswordConfirmController =
      TextEditingController();
  bool _success;
  String _userEmail;
  //end SignUp Controllers
  //SignIn Controllers
  final TextEditingController _signInEmailController = TextEditingController();
  final TextEditingController _signInPasswordController =
      TextEditingController();
  //end SignIn controllers
  PageController _pageController;
  //_pageController =PageController();
  String _authorized = 'Not Authorized';
  @override
  Widget build(BuildContext context) {
    dynamic _height = MediaQuery.of(context).size.height;
    dynamic _width = MediaQuery.of(context).size.width;
    dynamic _fourFifths = _width * .80;
    return Scaffold(
      body: Container(
        color: Color.fromARGB(225, 73, 144, 226),
        child: PageView(
          controller: _pageController,
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            Center(child: buildSignIn(_height, _width, _fourFifths)),
            Center(child: buildSignUp(_height, _width, _fourFifths)),
          ],
        ),
      ),
    );
  }
//Start SignUpPage

  SingleChildScrollView buildSignUp(_height, _width, _fourFifths) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      controller: _pageController,
      //height: _height * .5,
      //color: Color.fromARGB(0, 73, 144, 226), //Colors.white,
      child: Form(
        key: _formKey,
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
                  width: _fourFifths,
                  child: signUpName("Name", Icons.mail_outline),
                ),
                Container(
                  width: _fourFifths,
                  child: signUpEmail("Email", Icons.mail_outline),
                ),
                Container(
                  width: _fourFifths,
                  child: signUpPassword("Password", Icons.lock_outline),
                ),
                Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  overflow: Overflow.visible,
                  children: <Widget>[
                    Container(
                      width: _fourFifths,
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
          if (_formKey.currentState.validate()) {
            _register();
            //_authenticate;
          }
        },
        /*() {
                     //Navigator.of(context).pushNamed(FloatActBttn.tag);
                      Navigator.of(context).pushNamed(InputForm.tag);
                    }*/
      ),
    );
  }

//End SignUpPage

  SingleChildScrollView buildSignIn(_height, _width, _fourFifths) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      controller: _pageController,
      //height: _height * .5,
      //color: Color.fromARGB(0, 73, 144, 226),//Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        /* alignment: AlignmentDirectional.center,
        overflow: Overflow.clip,
        fit: StackFit.loose,*/
        children: <Widget>[
          Container(
            // height: _height * .4,
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
                width: _fourFifths,
                child: signInEmail("Email", Icons.mail_outline),
              ),
              Stack(
                alignment: AlignmentDirectional.bottomCenter,
                overflow: Overflow.visible,
                children: <Widget>[
                  Container(
                    width: _fourFifths,
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
            width: 200.0,
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
            width: 180.0,
            height: 1.0,
          ),
        ],
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
        onPressed:
            _authenticate, /*() {
                     //Navigator.of(context).pushNamed(FloatActBttn.tag);
                      Navigator.of(context).pushNamed(InputForm.tag);
                    }*/
      ),
    );
  }

  Row buildThirdPartySignIn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Card(
          elevation: 8,
          child: buildFlatButton("Google", FontAwesomeIcons.google),
        ),
        Card(
          elevation: 8,
          child: buildFlatButton("Facebook", FontAwesomeIcons.facebookF),
        ),
        Card(
          elevation: 8,
          child: buildFlatButton("Twitter", FontAwesomeIcons.twitter),
        ),
      ],
    );
  }

  FlatButton buildFlatButton(String text, dynamic fieldIcon) {
    return FlatButton(
      color: Colors.white,
      //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: new Icon(
        fieldIcon,
      ),
      onPressed: () => print("$text button pressed"),
    );
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
                return 'Please enter some text';
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
                return 'Please enter some text';
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
                return 'Please enter some text';
              }
            },
          ),
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

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticateWithBiometrics(
          localizedReason: 'Scan your fingerprint to authenticate',
          useErrorDialogs: true,
          stickyAuth: false);
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;
    if (authenticated) {
      Navigator.of(context).pushNamed(InputForm.tag);
    }
    setState(() {
      _authorized = authenticated ? 'Authorized' : 'Not Authorized';
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _signUpEmailController.dispose();
    _signUpPasswordController.dispose();
    super.dispose();
  }

  // Example code for registration.
  void _register() async {
    final FirebaseUser user = await _auth.createUserWithEmailAndPassword(
      email: _signUpEmailController.text,
      password: _signUpPasswordController.text,
    );
    if (user != null) {
      setState(() {
        _success = true;
        _userEmail = user.email;
      });
    } else {
      _success = false;
    }
  }
}
