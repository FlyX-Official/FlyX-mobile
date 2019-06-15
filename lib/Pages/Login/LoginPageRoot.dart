import 'package:flutter/material.dart';

import 'Logo.dart';
import 'SignIn.dart';
import 'SignUp.dart';

final PageController loginSignUpController = PageController();

class Loginpage extends StatefulWidget {
  @override
  _LoginpageState createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  @override
  Widget build(BuildContext context) {
    //Sign In Page Text Controllers
    final TextEditingController _loginPagePasswordController =
        TextEditingController();
    final TextEditingController _loginPageEmailController =
        TextEditingController();

    //SignUp Page Text Controllers

    final TextEditingController _signUpPageUserNameController =
        TextEditingController();

    final TextEditingController _signUpPageEmailController =
        TextEditingController();
    final TextEditingController _signUpPagePasswordController =
        TextEditingController();
    final TextEditingController _signUpPagePasswordConfirmController =
        TextEditingController();

    final List<Widget> loginPageContent = [
      Container(
        height: MediaQuery.of(context).size.height * .42,
        child: Logo(),
      ),
      Container(
        height: MediaQuery.of(context).size.height * .6,
        child: Center(
          child: PageView(
            controller: loginSignUpController,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(25),
                child: SignInPage(
                    loginPageEmailController: _loginPageEmailController,
                    loginPagePasswordController: _loginPagePasswordController),
              ),
              Container(
                padding: EdgeInsets.all(25),
                child: SignUpPage(
                    signUpPageUserNameController: _signUpPageUserNameController,
                    signUpPageEmailController: _signUpPageEmailController,
                    signUpPagePasswordController: _signUpPagePasswordController,
                    signUpPagePasswordConfirmController:
                        _signUpPagePasswordConfirmController),
              ),
            ],
          ),
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 100, 135, 165),
      body: Center(
        child: Container(
          child: Form(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: loginPageContent,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
