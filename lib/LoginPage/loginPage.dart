import 'package:flutter/material.dart';
import 'package:flyx/Auth/auth.dart';
import 'package:flyx/HomePage/home.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final PageController _loginPageController = PageController();
  final GlobalKey<FormState> _loginPageFormKey = GlobalKey<FormState>();

  final TextEditingController _loginPageEmailController =
      TextEditingController();
  final TextEditingController _loginPagePasswordController =
      TextEditingController();

  //final GlobalKey<FormState> _signUpPageFormKey = GlobalKey<FormState>();

  final TextEditingController _signUpPageUserNameController =
      TextEditingController();

  final TextEditingController _signUpPageEmailController =
      TextEditingController();
  final TextEditingController _signUpPagePasswordController =
      TextEditingController();
  final TextEditingController _signUpPagePasswordConfirmController =
      TextEditingController();

  String _userEmail, _userName, _userPhoto, _googleUserId;
  String _githubAccessToken = 'd7b96d4da97bbfbb0a58068507d82a9bc9ef42b3';
  bool _successSignInWithEmailPasswordLogin,
      _successSignUpWithEmailPassword,
      _successGoogleSignIn;

  //double _pageViewContainerHeight ;

//States
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255,46, 209, 153),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Form(
            key: _loginPageFormKey,
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(8),
                  child: Card(
                    elevation: 4,
                    shape: CircleBorder(
                      side: BorderSide(
                          style: BorderStyle.solid, color: Colors.blue),
                    ),
                    color: Colors.blue,
                    child: Container(
                      height: 150,
                      width: 150,
                      //color: Colors.blue,
                      // decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),
                      // color: Colors.blue),
                      child: Center(
                        child: Text(
                          'FlyX',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 480,
                  child: Center(
                    child: PageView(
                      controller: _loginPageController,
                      // onPageChanged: (pageLocation) {
                      //   if (pageLocation == 0) {
                      //    setState(() {
                      //      _pageViewContainerHeight = 300;
                      //    });
                      //   }else if(pageLocation == 1){
                      //       setState(() {
                      //      _pageViewContainerHeight = 400;
                      //    });
                      //   }
                      // },
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 100, horizontal: 0),
                          child: Card(
                            elevation: 8,
                            margin: EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                              side: BorderSide(color: Colors.black),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    child: TextFormField(
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Email',
                                        icon: Icon(
                                          Icons.mail_outline,
                                          color: Colors.black,
                                        ),
                                      ),
                                      style: TextStyle(color: Colors.black),
                                      validator: (enteredEmail) =>
                                          !(enteredEmail.contains('@'))
                                              ? "Invalid Email"
                                              : null,
                                      controller: _loginPageEmailController,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0),
                                    child: Divider(
                                      color: Colors.black,
                                      height: 1,
                                    ),
                                  ),
                                  Container(
                                    child: TextFormField(
                                      obscureText: true,
                                      validator: (enteredPassword) =>
                                          enteredPassword.length < 6
                                              ? 'Password too short.'
                                              : null,
                                      controller: _loginPagePasswordController,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          icon: Icon(
                                            Icons.lock_outline,
                                            color: Colors.black,
                                          ),
                                          hintText: "Password"),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0),
                                    child: Divider(
                                      color: Colors.black,
                                      height: 1,
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        IconButton(
                                          color: Colors.black,
                                          icon: Icon(FontAwesomeIcons.google),
                                          //label: Text("Google"),
                                          onPressed: () async =>
                                              authService.googleSignIn(),
                                        ),
                                        IconButton(
                                          color: Colors.black,
                                          icon: Icon(FontAwesomeIcons.facebook),
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
                                                builder: (context) =>
                                                    HomePage(),
                                              ),
                                            );
                                          },
                                        ),
                                        IconButton(
                                          color: Colors.black,
                                          icon: Icon(FontAwesomeIcons.github),
                                          //label: Text("Google"),
                                          onPressed: () async =>
                                              authService.googleSignIn(),
                                        ),
                                        MaterialButton(
                                          elevation: 8,
                                          highlightElevation: 0,
                                          padding: EdgeInsets.all(8),
                                          color: Colors.lightGreenAccent,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              side: BorderSide(
                                                  color: Colors.black)),
                                          child: Icon(
                                            FontAwesomeIcons.signInAlt,
                                            color: Colors.black,
                                            size: 23,
                                          ),
                                          // Text(
                                          //   'Login',
                                          //   style: TextStyle(
                                          //       fontWeight: FontWeight.w700,
                                          //       fontSize: 22),
                                          // ),
                                          onPressed: () async {
                                            if (_loginPageFormKey.currentState
                                                .validate()) {
                                              authService
                                                  .signInWithEmailAndPassword(
                                                      _loginPageEmailController,
                                                      _loginPagePasswordController);
                                              if (_successSignInWithEmailPasswordLogin) {
                                                print(
                                                  'Welcome ' + _userEmail,
                                                );
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        HomePage(),
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 25, horizontal: 0),
                          child: Card(
                            elevation: 8,
                            margin: EdgeInsets.all(16),
                            //color: Color.fromARGB(255, 247, 247, 247),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                              side: BorderSide(color: Colors.black),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    child: TextFormField(
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Username',
                                        icon: Icon(
                                          FontAwesomeIcons.user,
                                          color: Colors.black,
                                        ),
                                      ),
                                      style: TextStyle(color: Colors.black),
                                      validator: (enteredEmail) =>
                                          (enteredEmail.length > 0)
                                              ? null
                                              : "Invalid Email",
                                      controller: _signUpPageUserNameController,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0),
                                    child: Divider(
                                      color: Colors.black,
                                      height: 1,
                                    ),
                                  ),
                                  Container(
                                    child: TextFormField(
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Email',
                                        icon: Icon(
                                          Icons.mail_outline,
                                          color: Colors.black,
                                        ),
                                      ),
                                      style: TextStyle(color: Colors.black),
                                      validator: (enteredEmail) =>
                                          !(enteredEmail.contains('@'))
                                              ? "Invalid Email"
                                              : null,
                                      controller: _signUpPageEmailController,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0),
                                    child: Divider(
                                      color: Colors.black,
                                      height: 1,
                                    ),
                                  ),
                                  Container(
                                    child: TextFormField(
                                      obscureText: true,
                                      validator: (enteredPassword) =>
                                          enteredPassword.length < 6
                                              ? 'Password too short.'
                                              : null,
                                      controller: _signUpPagePasswordController,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          icon: Icon(
                                            Icons.lock_outline,
                                            color: Colors.black,
                                          ),
                                          hintText: "Password"),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0),
                                    child: Divider(
                                      color: Colors.black,
                                      height: 1,
                                    ),
                                  ),
                                  Container(
                                    child: TextFormField(
                                      obscureText: true,
                                      validator: (enteredPassword) =>
                                          enteredPassword.length < 6
                                              ? 'Password too short.'
                                              : null,
                                      controller:
                                          _signUpPagePasswordConfirmController,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          icon: Icon(
                                            Icons.lock_outline,
                                            color: Colors.black,
                                          ),
                                          hintText: "Confirm Password"),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0),
                                    child: Divider(
                                      color: Colors.black,
                                      height: 1,
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        IconButton(
                                          color: Colors.black,
                                          icon: Icon(FontAwesomeIcons.google),
                                          //label: Text("Google"),
                                          onPressed: () async {},
                                        ),
                                        IconButton(
                                          color: Colors.black,
                                          icon: Icon(
                                              FontAwesomeIcons.facebookSquare),
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
                                                builder: (context) =>
                                                    HomePage(),
                                              ),
                                            );
                                          },
                                        ),
                                        MaterialButton(
                                          elevation: 8,
                                          highlightElevation: 0,
                                          padding: EdgeInsets.all(8),
                                          color: Colors.lightGreenAccent,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              side: BorderSide(
                                                  color: Colors.black)),
                                          child: Icon(
                                            FontAwesomeIcons.signInAlt,
                                            color: Colors.black,
                                            size: 23,
                                          ),
                                          // Text(
                                          //   'Login',
                                          //   style: TextStyle(
                                          //       fontWeight: FontWeight.w700,
                                          //       fontSize: 22),
                                          // ),
                                          onPressed: () async {
                                            if (_loginPageFormKey.currentState
                                                .validate()) {
                                              authService.signUpWithEmailAndPassword(
                                                  context,
                                                  _signUpPageUserNameController,
                                                  _signUpPageEmailController,
                                                  _signUpPagePasswordConfirmController);
                                              if (_successSignInWithEmailPasswordLogin) {
                                                print(
                                                  'Welcome ' + _userEmail,
                                                );
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        HomePage(),
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: FlatButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Need an Account?'),
                        Text(
                          ' Sign Up',
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      _loginPageController.animateToPage(
                        1,
                        curve: Curves.easeInOutExpo,
                        duration: Duration(milliseconds: 1000),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _loginPageEmailController.dispose();
    _loginPagePasswordController.dispose();
    super.dispose();
  }

  // Sign in/up with email and password hooked to FireBase.

}
