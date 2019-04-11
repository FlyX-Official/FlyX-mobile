import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';

import 'home.dart';

String userEmail, userName, userPhoto, _googleUserId;
String _githubAccessToken = 'd7b96d4da97bbfbb0a58068507d82a9bc9ef42b3';
bool _successSignInWithEmailPasswordLogin,
    _successSignUpWithEmailPassword,
    _successGoogleSignIn;

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/userinfo.profile',
      'https://www.googleapis.com/auth/userinfo.email',
    ],
  );
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  Observable<FirebaseUser> user; // firebase user
  Observable<Map<String, dynamic>> profile; // custom user data in Firestore
  PublishSubject loading = PublishSubject();

  // constructor
  AuthService() {
    user = Observable(_auth.onAuthStateChanged);

    profile = user.switchMap((FirebaseUser u) {
      if (u != null) {
        return _db
            .collection('UsersDetails')
            .document(u.uid)
            .snapshots()
            .map((snap) => snap.data);
      } else {
        return Observable.just({});
      }
    });
  }

  void signInWithEmailAndPassword(
      TextEditingController _loginPageEmailController,
      TextEditingController _loginPagePasswordController) async {
    final FirebaseUser user = await _auth.signInWithEmailAndPassword(
      email: _loginPageEmailController.text,
      password: _loginPagePasswordController.text,
    );
    updateUserDataEmailReSignIn(user);
    if (user != null) {
    } else {
      _successSignInWithEmailPasswordLogin = false;
    }
  }

  void signUpWithEmailAndPassword(
      context,
      TextEditingController _signUpPageUserNameController,
      TextEditingController _signUpPageEmailController,
      TextEditingController _signUpPagePasswordController) async {
    final FirebaseUser user = await _auth.createUserWithEmailAndPassword(
      email: _signUpPageEmailController.text,
      password: _signUpPagePasswordController.text,
    );
    updateUserDataEmailPassword(user, _signUpPageUserNameController);
    if (user != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          maintainState: false,
          builder: (context) => HomePage(),
        ),
      );
    } else {
      _successSignUpWithEmailPassword = false;
      CupertinoAlertDialog(
        title: Text('Error'),
        actions: <Widget>[Text('Error Siging Up')],
      );
    }
  }

  Future<FirebaseUser> googleSignIn() async {
    try {
      loading.add(true);
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final FirebaseUser user = await _auth.signInWithCredential(credential);
      print("Using Google signed in " + user.displayName);
      updateUserDataGoogleSignIn(user);
      print("user name: ${user.displayName}");

      loading.add(false);
      return user;
    } catch (error) {
      return error;
    }
  }

  void updateUserDataGoogleSignIn(FirebaseUser user) async {
    DocumentReference ref = _db.collection('UsersDetails').document(user.uid);
    userEmail = user.email;
    userName = user.displayName;
    userPhoto = user.photoUrl;
    return ref.setData({
      'uid': user.uid,
      'email': user.email,
      'photoURL': user.photoUrl,
      'displayName': user.displayName,
      'methodSignedIn': 'Using Google Sign In',
      'lastSeen': DateTime.now()
    },merge: true);
  }
  void updateUserDataEmailReSignIn(FirebaseUser user) async {
    DocumentReference ref = _db.collection('UsersDetails').document(user.uid);

    return ref.setData({
      'uid': user.uid,
      'email': user.email,
      'photoURL': user.photoUrl,
      //'displayName': user.displayName,
      'lastSeen': DateTime.now(),
      'methodSignedIn': 'Using Email Password Sign In'
    },merge: true);
  }

    void updateUserDataEmailPassword(FirebaseUser user, TextEditingController _signUpPageUserNameController,
    ) async {
    DocumentReference ref = _db.collection('UsersDetails').document(user.uid);

    return ref.setData({
      'uid': user.uid,
      'email': user.email,
      'photoURL': user.photoUrl,
      'displayName': _signUpPageUserNameController.text,
      'methodSignedIn': 'Using Email Password Sign In',
      'lastSeen': DateTime.now()
    }, merge: true);
  }

  Future<String> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      return 'SignOut';
    } catch (e) {
      return e.toString();
    }
  }
}

// TODO refactor global to InheritedWidget
final AuthService authService = AuthService();
