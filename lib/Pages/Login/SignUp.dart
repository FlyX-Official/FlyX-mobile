
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({
    Key key,
    @required TextEditingController signUpPageUserNameController,
    @required TextEditingController signUpPageEmailController,
    @required TextEditingController signUpPagePasswordController,
    @required TextEditingController signUpPagePasswordConfirmController,
  })  : _signUpPageUserNameController = signUpPageUserNameController,
        _signUpPageEmailController = signUpPageEmailController,
        _signUpPagePasswordController = signUpPagePasswordController,
        _signUpPagePasswordConfirmController =
            signUpPagePasswordConfirmController,
        super(key: key);

  final TextEditingController _signUpPageUserNameController;
  final TextEditingController _signUpPageEmailController;
  final TextEditingController _signUpPagePasswordController;
  final TextEditingController _signUpPagePasswordConfirmController;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    const iconPadding = EdgeInsets.all(10);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Card(
          color: Colors.white,
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Username',
              icon: Padding(
                padding: iconPadding,
                child: Icon(
                  FontAwesomeIcons.user,
                  color: Colors.black,
                ),
              ),
            ),
            style: TextStyle(color: Colors.black),
            validator: (enteredEmail) =>
                (enteredEmail.length > 0) ? null : "Invalid Email",
            controller: widget._signUpPageUserNameController,
          ),
        ),
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
            controller: widget._signUpPageEmailController,
          ),
        ),
        Card(
          color: Colors.white,
          child: TextFormField(
            obscureText: true,
            validator: (enteredPassword) =>
                enteredPassword.length < 6 ? 'Password too short.' : null,
            controller: widget._signUpPagePasswordController,
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
          child: TextFormField(
            obscureText: true,
            validator: (enteredPassword) =>
                enteredPassword.length < 6 ? 'Password too short.' : null,
            controller: widget._signUpPagePasswordConfirmController,
            decoration: InputDecoration(
                border: InputBorder.none,
                icon: Padding(
                  padding: iconPadding,
                  child: Icon(
                    Icons.lock_outline,
                    color: Colors.black,
                  ),
                ),
                hintText: "Confirm Password"),
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
                onPressed: () async {},
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
                },
              ),
              MaterialButton(
                elevation: 8,
                highlightElevation: 0,
                padding: EdgeInsets.all(8),
                color: Color.fromARGB(255, 46, 209, 153),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  //side:BorderSide(color: Colors.black),
                ),
                child: Icon(
                  FontAwesomeIcons.signInAlt,
                  color: Colors.white,
                  size: 23,
                ),
                // Text(
                //   'Login',
                //   style: TextStyle(
                //       fontWeight: FontWeight.w700,
                //       fontSize: 22),
                // ),
                onPressed: () async {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
