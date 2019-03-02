import 'dart:ui';
import 'dart:async';

import 'package:local_auth/local_auth.dart';
import 'package:wefly/Biometrics/bioAuth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wefly/InputPage/inputForm.dart';
import 'package:wefly/style/theme.dart' as Theme;
//import 'package:wefly_flutter/utils/bubble_indication_painter.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final FocusNode myFocusNodeEmailLogin = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();

  final FocusNode myFocusNodePassword = FocusNode();
  final FocusNode myFocusNodeEmail = FocusNode();
  final FocusNode myFocusNodeName = FocusNode();

  TextEditingController loginEmailController = new TextEditingController();
  TextEditingController loginPasswordController = new TextEditingController();

  bool _obscureTextLogin = true;
  bool _obscureTextSignup = true;
  bool _obscureTextSignupConfirm = true;

  TextEditingController signupEmailController = new TextEditingController();
  TextEditingController signupNameController = new TextEditingController();
  TextEditingController signupPasswordController = new TextEditingController();
  TextEditingController signupConfirmPasswordController =
      new TextEditingController();

  PageController _pageController;

  Color left = Colors.black;
  Color right = Colors.white;
  final LocalAuthentication auth = LocalAuthentication();
  String _authorized = 'Not Authorized';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: new Scaffold(
        key: _scaffoldKey,
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowGlow();
          },
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height >= 675.0
                  ? MediaQuery.of(context).size.height
                  : 675.0,
              decoration: new BoxDecoration(
                gradient: new LinearGradient(
                    colors: [
                      Theme.Colors.loginGradientStart,
                      Theme.Colors.loginGradientEnd
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    tileMode: TileMode.clamp),
                color: Colors.grey,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 75.0),
                    child: new Image(
                        width: 256.0,
                        height: MediaQuery.of(context).size.height * .2,
                        color: Color.fromARGB(0, 0, 0, 0),
                        fit: BoxFit.fill,
                        image: new AssetImage('assets/img/login_logo.png')),
                  ),
                  /* Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: _buildMenuBar(context),
                  ),*/
                  Expanded(
                    flex: 2,
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (i) {
                        if (i == 0) {
                          setState(() {
                            right = Colors.white;
                            left = Colors.black;
                          });
                        } else if (i == 1) {
                          setState(() {
                            right = Colors.black;
                            left = Colors.white;
                          });
                        }
                      },
                      children: <Widget>[
                        new ConstrainedBox(
                          constraints: const BoxConstraints.expand(),
                          child: _buildSignIn(context),
                        ),
                        new ConstrainedBox(
                          constraints: const BoxConstraints.expand(),
                          child: _buildSignUp(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    myFocusNodePassword.dispose();
    myFocusNodeEmail.dispose();
    myFocusNodeName.dispose();
    _pageController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _pageController = PageController();
  }

  void showInSnackBar(String value) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white, fontSize: 16.0, fontFamily: "Nunito"),
      ),
      backgroundColor: Colors.blue,
      duration: Duration(seconds: 3),
    ));
  }

  Widget _buildSignIn(BuildContext context) {
    var children2 = <Widget>[
      RaisedButton(
        color: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: new Icon(
          FontAwesomeIcons.google,
        ),
        onPressed: () => showInSnackBar("Google button pressed"),
      ),
      RaisedButton(
        color: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: new Icon(
          FontAwesomeIcons.facebookF,
        ),
        onPressed: () => showInSnackBar("Facebook button pressed"),
      ),
      RaisedButton(
        color: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: new Icon(
          FontAwesomeIcons.twitter,
        ),
        onPressed: () => showInSnackBar("Twitter button pressed"),
      ),
    ];
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: new BoxDecoration(
        color: Color.fromARGB(255, 73, 144, 226),
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.horizontal(
          left: Radius.circular(16.0),
        ),
      ),
      margin: new EdgeInsets.only(
        left: 20,
        bottom: 40,
        top: 40,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              Card(
                elevation: 8.0,
                color: Color.fromARGB(255, 255, 255, 255),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  width: 300.0,
                  height: 190.0,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: 25.0, bottom: 25.0, left: 25.0, right: 25.0),
                        child: TextFormField(
                          autofocus: false,
                          focusNode: myFocusNodeEmailLogin,
                          controller: loginEmailController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                              fontFamily: "Nunito",
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.solidEnvelope,
                              color: Colors.black,
                              size: 22.0,
                            ),
                            hintText: "Email Address",
                            hintStyle:
                                TextStyle(fontFamily: "Nunito", fontSize: 17.0),
                          ),
                        ),
                      ),
                      /*Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.black45,
                      ),*/
                      Padding(
                        padding: EdgeInsets.only(
                            top: 15.0, bottom: 25.0, left: 25.0, right: 25.0),
                        child: TextFormField(
                          focusNode: myFocusNodePasswordLogin,
                          controller: loginPasswordController,
                          obscureText: _obscureTextLogin,
                          style: TextStyle(
                              fontFamily: "Nunito",
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.lock,
                              size: 22.0,
                              color: Colors.black,
                            ),
                            hintText: "Password",
                            hintStyle:
                                TextStyle(fontFamily: "Nunito", fontSize: 17.0),
                            suffixIcon: GestureDetector(
                              onTap: _toggleLogin,
                              child: Icon(
                                FontAwesomeIcons.eye,
                                size: 15.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 175.0),
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  color: Color.fromARGB(255, 83, 214, 204),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.black45,
                        blurRadius: 20.0,
                        offset: Offset(1.0, 10.0))
                  ],
                ),
                child: MaterialButton(
                  highlightColor: Colors.transparent,
                  splashColor: Theme.Colors.loginGradientEnd,
                  //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 42.0),
                    child: Text("LOGIN",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25.0,
                          fontFamily: "Nunito",
                        )),
                  ),
                  onPressed:
                      _authenticate, /*() {
                     //Navigator.of(context).pushNamed(FloatActBttn.tag);
                      Navigator.of(context).pushNamed(InputForm.tag);
                    }*/
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: children2,
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
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
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: FlatButton(
                onPressed: () => showInSnackBar("Forgot Password Pressed"),
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(
                      //decoration: TextDecoration.underline,
                      color: Colors.white,
                      fontSize: 16.0,
                      fontFamily: "Nunito"),
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUp(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: new BoxDecoration(
        color: Color.fromARGB(255, 73, 144, 226),
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.horizontal(
          right: Radius.circular(16.0),
        ),
      ),
      margin: new EdgeInsets.only(
        right: 20,
        bottom: 40,
        top: 40,
      ),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              alignment: Alignment.topCenter,
              overflow: Overflow.visible,
              children: <Widget>[
                Card(
                  elevation: 2.0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Container(
                    width: 300.0,
                    height: 360.0,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: TextField(
                            focusNode: myFocusNodeName,
                            controller: signupNameController,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.words,
                            style: TextStyle(
                                fontFamily: "Nunito",
                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.user,
                                color: Colors.black,
                              ),
                              hintText: "Name",
                              hintStyle: TextStyle(
                                  fontFamily: "Nunito", fontSize: 16.0),
                            ),
                          ),
                        ),
                        Container(
                          width: 250.0,
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: TextField(
                            focusNode: myFocusNodeEmail,
                            controller: signupEmailController,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(
                                fontFamily: "Nunito",
                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.envelope,
                                color: Colors.black,
                              ),
                              hintText: "Email Address",
                              hintStyle: TextStyle(
                                  fontFamily: "Nunito", fontSize: 16.0),
                            ),
                          ),
                        ),
                        Container(
                          width: 250.0,
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: TextField(
                            focusNode: myFocusNodePassword,
                            controller: signupPasswordController,
                            obscureText: _obscureTextSignup,
                            style: TextStyle(
                                fontFamily: "Nunito",
                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.lock,
                                color: Colors.black,
                              ),
                              hintText: "Password",
                              hintStyle: TextStyle(
                                  fontFamily: "Nunito", fontSize: 16.0),
                              suffixIcon: GestureDetector(
                                onTap: _toggleSignup,
                                child: Icon(
                                  FontAwesomeIcons.eye,
                                  size: 15.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 250.0,
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: TextField(
                            controller: signupConfirmPasswordController,
                            obscureText: _obscureTextSignupConfirm,
                            style: TextStyle(
                                fontFamily: "Nunito",
                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.lock,
                                color: Colors.black,
                              ),
                              hintText: "Confirmation",
                              hintStyle: TextStyle(
                                  fontFamily: "Nunito", fontSize: 16.0),
                              suffixIcon: GestureDetector(
                                onTap: _toggleSignupConfirm,
                                child: Icon(
                                  FontAwesomeIcons.eye,
                                  size: 15.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 340.0),
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    color: Color.fromARGB(255, 83, 214, 204),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.black45,
                          blurRadius: 20.0,
                          offset: Offset(1.0, 10.0))
                    ],
                  ),
                  child: MaterialButton(
                      highlightColor: Colors.transparent,
                      splashColor: Theme.Colors.loginGradientEnd,
                      //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 42.0),
                        child: Text(
                          "SIGN UP",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.0,
                              fontFamily: "Nunito"),
                        ),
                      ),
                      onPressed: () => showInSnackBar("SignUp button pressed")),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onSignInButtonPress() {
    _pageController.animateToPage(0,
        duration: Duration(milliseconds: 200), curve: Curves.bounceInOut);
  }

  void _onSignUpButtonPress() {
    _pageController?.animateToPage(1,
        duration: Duration(milliseconds: 200), curve: Curves.elasticInOut);
  }

  void _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }

  void _toggleSignup() {
    setState(() {
      _obscureTextSignup = !_obscureTextSignup;
    });
  }

  void _toggleSignupConfirm() {
    setState(() {
      _obscureTextSignupConfirm = !_obscureTextSignupConfirm;
    });
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
}
