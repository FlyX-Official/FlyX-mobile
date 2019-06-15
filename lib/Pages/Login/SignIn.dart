import 'package:flutter/material.dart';
import 'package:flyx/Pages/HomePage/HomePage.dart';
import 'package:flyx/Pages/Logic/NetworkCalls.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'LoginPageRoot.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({
    Key key,
    @required TextEditingController loginPageEmailController,
    @required TextEditingController loginPagePasswordController,
  })  : _loginPageEmailController = loginPageEmailController,
        _loginPagePasswordController = loginPagePasswordController,
        super(key: key);

  final TextEditingController _loginPageEmailController;
  final TextEditingController _loginPagePasswordController;

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    const iconPadding = EdgeInsets.all(10);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Card(
          color: Colors.white,
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Email',
              icon: Padding(
                padding: iconPadding,
                child: Icon(
                  Icons.mail_outline,
                  color: Colors.black,
                ),
              ),
            ),
            style: TextStyle(color: Colors.black),
            validator: (enteredEmail) =>
                !(enteredEmail.contains('@')) ? "Invalid Email" : null,
            controller: widget._loginPageEmailController,
          ),
        ),
        Card(
          color: Colors.white,
          child: TextFormField(
            obscureText: true,
            validator: (enteredPassword) =>
                enteredPassword.length < 6 ? 'Password too short.' : null,
            controller: widget._loginPagePasswordController,
            decoration: InputDecoration(
                border: InputBorder.none,
                icon: Padding(
                  padding: iconPadding,
                  child: Icon(
                    Icons.lock_outline,
                    color: Colors.black,
                  ),
                ),
                hintText: "Password"),
          ),
        ),
        Card(
          color: Colors.white,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                color: Colors.black,
                icon: Icon(FontAwesomeIcons.google),
                //label: Text("Google"),
                onPressed: () async {
                  signInWithGoogle(context);
                },
              ),
              IconButton(
                color: Colors.black,
                icon: Icon(FontAwesomeIcons.facebookSquare),
                //label: Text("Google"),
                onPressed: () async {
                  //_signIn();
                },
              ),
              IconButton(
                color: Colors.black,
                icon: Icon(FontAwesomeIcons.twitter),
                //label: Text("Google"),
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return;
                      },
                    ),
                  );
                },
              ),
              IconButton(
                  color: Colors.black,
                  icon: Icon(FontAwesomeIcons.github),
                  //label: Text("Google"),
                  onPressed: () async {
                    return;
                  }),
              RaisedButton(
                elevation: 8,
                highlightElevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: EdgeInsets.all(8),
                color: Color.fromARGB(255, 46, 209, 153),
                child: Icon(
                  FontAwesomeIcons.signInAlt,
                  color: Colors.white,
                  size: 23,
                ),
                onPressed: () async {
                  singInWithEmailAndPassword(
                      context,
                      widget._loginPageEmailController,
                      widget._loginPagePasswordController);
                },
              ),
            ],
          ),
        ),
        Container(
          child: FlatButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Need an Account?',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  ' Sign Up',
                  style: TextStyle(
                    color: Color.fromARGB(255, 46, 209, 153),
                  ),
                ),
              ],
            ),
            onPressed: () {
              loginSignUpController.animateToPage(
                1,
                curve: Curves.easeInOutExpo,
                duration: Duration(milliseconds: 1000),
              );
            },
          ),
        ),
      ],
    );
  }
}
