import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:FlyXWebSource/services/Auth/Auth.dart';

Auth _auth = Auth();
final List<Widget> signInButtons = <Widget>[
  Container(
    child: AppleSignInButton(
      onPressed: () {},
      style: AppleButtonStyle.whiteOutline,
      borderRadius: 40,
    ),
  ),
  Container(
    child: GoogleSignInButton(
      onPressed: () => _auth.signInWithGoogle(),
      darkMode: true,
      text: 'Sign In With Google',
      borderRadius: 40,
    ),
  ),
];

final List<Widget> loginPageContents = <Widget>[
  Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(16),
      ),
    ),
    elevation: 8,
    color: Colors.lightBlueAccent,
    child: Container(
      width: double.maxFinite,
      height: 300,
    ),
  ),
  ListView.builder(
    reverse: false,
    padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
    shrinkWrap: true,
    itemCount: signInButtons.length,
    itemBuilder: (_, i) => AnimationLimiter(
      child: AnimationConfiguration.staggeredList(
        position: i,
        child: FadeInAnimation(
          child: signInButtons.elementAt(i),
        ),
      ),
    ),
  ),
];
