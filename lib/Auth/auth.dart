import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';

import 'package:flyx/HomePage/home.dart';

String userEmail, userName, userPhoto, fireStoreUid;

class AuthService {
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/userinfo.profile',
      'https://www.googleapis.com/auth/userinfo.email'
    ],
  );
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  Observable<FirebaseUser> user; // firebase user
  Observable<Map<String, dynamic>> profile; // custom user data in Firestore
  PublishSubject loading = PublishSubject();

  bool _successSignInWithEmailPasswordLogin, _successSignUpWithEmailPassword;

  String _userID;

  bool _success;

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
          maintainState: true,
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

  dynamic googleSignIn() async {
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
      // print("Using Google signed in " + user.displayName);
      // updateUserDataGoogleSignIn(user);
      // print("user name: ${user.displayName}");
      updateUserDataGoogleSignIn(user);
      print("Google SIgn IN Email: ${user.email}");

      loading.add(false);
      return user;
    } catch (error) {
      return error;
    }
  }

  dynamic signInWithGoogle() async {
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
    updateUserDataGoogleSignIn(user);
  }

  dynamic updateUserDataGoogleSignIn(FirebaseUser user) async {
    DocumentReference ref = _db.collection('UsersDetails').document(user.uid);

    fireStoreUid = user.uid;
    return ref.setData({
      'uid': user.uid,
      'email': user.email,
      'photoURL': user.photoUrl,
      'displayName': user.displayName,
      'methodSignedIn': 'Using Google Sign In',
      'lastSeen': DateTime.now()
    }, merge: true);
  }

  void updateUserDataEmailReSignIn(FirebaseUser user) async {
    DocumentReference ref = _db.collection('UsersDetails').document(user.uid);

    fireStoreUid = user.uid;
    return ref.setData({
      'uid': user.uid,
      'email': user.email,
      'photoURL': user.photoUrl,
      //'displayName': user.displayName,
      'lastSeen': DateTime.now(),
      'methodSignedIn': 'Using Email Password Sign In'
    }, merge: true);
  }

  void updateUserDataEmailPassword(
    FirebaseUser user,
    TextEditingController _signUpPageUserNameController,
  ) async {
    DocumentReference ref = _db.collection('UsersDetails').document(user.uid);

    fireStoreUid = user.uid;
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
      await _googleSignIn.disconnect();
      return 'SignOut';
    } catch (e) {
      return e.toString();
    }
  }

  void silentGoogleSignIn() {
    _googleSignIn.signInSilently();
  }

  Widget appDrawerUserAccountDrawerHeader() {
    silentGoogleSignIn();
    return StreamBuilder<QuerySnapshot>(
      stream: authService._db
          .collection('UsersDetails')
          .where('uid', isEqualTo: fireStoreUid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Text('Loading...');
        return ListView(
          physics: NeverScrollableScrollPhysics(),
          children: snapshot.data.documents.map(
            (DocumentSnapshot document) {
              return UserAccountsDrawerHeader(
                accountName: Text(document['displayName']),
                accountEmail: Text(document['email']),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(
                    document['photoURL'].toString(),
                  ),
                ),
              );
            },
          ).toList(),
        );
      },
    );
  }

  Widget buildDrawerHeader() {
    silentGoogleSignIn();
    return StreamBuilder<QuerySnapshot>(
      stream: authService._db
          .collection('UsersDetails')
          .where('uid', isEqualTo: fireStoreUid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Text('Loading...');
        return ListView(
          physics: NeverScrollableScrollPhysics(),
          children: snapshot.data.documents.map(
            (DocumentSnapshot document) {
              return UserAccountsDrawerHeader(
                accountName: Text(document['displayName']),
                accountEmail: Text(document['email']),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(
                    document['photoURL'].toString(),
                  ),
                ),
              );
            },
          ).toList(),
        );
      },
    );
  }
}

final AuthService authService = AuthService();
