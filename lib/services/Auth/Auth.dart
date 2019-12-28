import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';

class Auth with ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/userinfo.profile',
      'https://www.googleapis.com/auth/userinfo.email'
    ],
  );

  FirebaseUser _user;
  FirebaseUser get user => _user;

  void signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final FirebaseUser user =
          (await _auth.signInWithCredential(credential)).user;
      saveUser(user);
    } catch (e) {
      print(e);
    }
  }

  void saveUser(FirebaseUser user) {
    _user = user;
    notifyListeners();
    Hive.box('User').put(
      Hive.box('User').values.length,
      [
        user.displayName,
        user.photoUrl,
        user.email,
        user.phoneNumber,
      ],
    );
  }

  //Sign Out
  void signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    await Hive.box('User').clear();
  }
}
