import 'package:flutter/material.dart';
import 'package:flyx/widgets/LoginScreen/LoginScreenContents.dart';

class LoginSceen extends StatelessWidget {
  const LoginSceen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.lightBlueAccent.shade100,
              Colors.lightBlueAccent.shade400,
              Colors.lightBlueAccent.shade700,
            ],
          ),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: const Text(
                'FlyX',
                style: TextStyle(color: Colors.white, fontSize: 48),
              ),
            ),
            Expanded(
              child: Card(
                margin: const EdgeInsets.all(0),
                elevation: 48,
                shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.only(
                    topLeft: const Radius.circular(40),
                    topRight: const Radius.circular(40),
                  ),
                ),
                child: SingleChildScrollView(
                  reverse: true,
                  physics: const BouncingScrollPhysics(),
                  child: Container(
                    margin: const EdgeInsets.all(32),
                    child: Column(
                      children: loginPageContents,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
