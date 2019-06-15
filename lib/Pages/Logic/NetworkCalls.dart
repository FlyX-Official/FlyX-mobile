import 'dart:convert';
import 'dart:io';

import 'package:alice/alice.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flyx/Pages/HomePage/HomePage.dart';
import 'package:flyx/Pages/HomePage/Search/Ui/SearchModal.dart';
import 'package:flyx/Pages/Schema/OneWaySchema.dart';
import 'package:flyx/Pages/Schema/SearchQuery.dart';
import 'package:flyx/Pages/Schema/TwoWaySchema.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:flyx/Pages/Schema/AutocompleteSchema.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

//Globals

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/userinfo.profile',
    'https://www.googleapis.com/auth/userinfo.email'
  ],
);
final Firestore _db = Firestore.instance;
Dio dio = Dio();
Response response;
Alice alice = Alice(showNotification: false);
//Used for Autocomplete
Future<List<Suggestions>> pingHeroku(
  String query,
) async {
  final response =
      await http.get('https://flyx-server.herokuapp.com/autocomplete?q=$query');
  if (response.statusCode == 200) {
    return suggestionsFromJson(response.body);
  } else {
    throw Exception('Failed to Contact server');
  }
}

dynamic _write(String text) async {
  final directory = await getExternalStorageDirectory();
  final file = File('${directory.path}/my_file.txt');
  print('File Location $file');
  await file.writeAsString(text, mode: FileMode.writeOnly);
}

//Used to Search OneWay Tickets
void oneWay() async {
  response = await dio.post(
    'https://flyx-server.herokuapp.com/search',
    data: postToJson(
      Post(
        oneWay: true,
        from: "$originQuery",
        to: "$destinationQuery",
        radiusFrom: fromSlider,
        radiusTo: toSlider,
        departureWindow: DepartureWindow(
          start: DateTime.parse(
            originDate[0].toString(),
          ),
          end: DateTime.parse(
            originDate[1].toString(),
          ),
        ),
      ),
    ),
  );

  print(response.data);
  dynamic jsonFor = json.encode(response.data);
  //_write(response.data['data'].toString());
  _write(jsonFor);
  dynamic searlize = oneWayFromJson(response.data);
  _write(searlize);
}

//Used to Search RoundTrip Tickets
void twoWay() async {
  response = await dio.post(
    'https://flyx-server.herokuapp.com/search',
    data: postToJson(
      Post(
        oneWay: false,
        from: "$originQuery",
        to: "$destinationQuery",
        radiusFrom: fromSlider,
        radiusTo: toSlider,
        departureWindow: DepartureWindow(
          start: DateTime.parse(
            originDate[0].toString(),
          ),
          end: DateTime.parse(
            originDate[1].toString(),
          ),
        ),
        returnDepartureWindow: ReturnDepartureWindow(
          start: DateTime.parse(
            destinationDate[0].toString(),
          ),
          end: DateTime.parse(
            destinationDate[1].toString(),
          ),
        ),
      ),
    ),
  );

  print(response.data);
  dynamic jsonFor = json.encode(response.data);
  //_write(response.data['data'].toString());
  _write(jsonFor.toString());

  dynamic searlize = roundTripFromJson(jsonFor);
  _write(searlize.toString());
}

//Used for GooogleSignIn
void signInWithGoogle(context) async {
  final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
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
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => HomePage(),
    ),
  );
}

//Used for Email Password SignIn

void singInWithEmailAndPassword(
    context,
    TextEditingController _loginPageEmailController,
    TextEditingController _loginPagePasswordController) async {
  final FirebaseUser user = await _auth.signInWithEmailAndPassword(
    email: _loginPageEmailController.text,
    password: _loginPagePasswordController.text,
  );
  existingUserEmailPassowrd(user);
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => HomePage(),
    ),
  );
}

//Log all SignIn Methods into cloud FireStore

dynamic newUserDataEmailPasswordSignIn(
  FirebaseUser user,
  TextEditingController _signUpPageUserNameController,
) async {
  DocumentReference ref = _db.collection('UsersDetails').document(user.uid);
  //fireStoreUid = user.uid;
  return ref.setData({
    'uid': user.uid,
    'email': user.email,
    'photoURL': user.photoUrl,
    'displayName': _signUpPageUserNameController.text,
    'methodSignedIn': 'Using Email Password Sign In',
    'lastSeen': DateTime.now()
  }, merge: true);
}

dynamic updateUserDataGoogleSignIn(FirebaseUser user) async {
  DocumentReference ref = _db.collection('UsersDetails').document(user.uid);
  //fireStoreUid = user.uid;
  return ref.setData({
    'uid': user.uid,
    'email': user.email,
    'photoURL': user.photoUrl,
    'displayName': user.displayName,
    'methodSignedIn': 'Using Google Sign In',
    'lastSeen': DateTime.now()
  }, merge: true);
}

dynamic existingUserEmailPassowrd(FirebaseUser user) async {
  DocumentReference ref = _db.collection('UsersDetails').document(user.uid);
  return ref.setData({
    'uid': user.uid,
    'email': user.email,
    'photoURL': user.photoUrl,
    //'displayName': user.displayName,
    'lastSeen': DateTime.now(),
    'methodSignedIn': 'Using Email Password Sign In'
  }, merge: true);
}

//Logs Users Searches

dynamic logToFireStore() async {
  Firestore.instance
      .collection("TicketQueries")
      .document()
      .setData(postDataToFireStore());
}

Map<String, dynamic> postDataToFireStore() {
  return {
    'from': "$originQuery",
    'to': '$destinationQuery',
    'radiusFrom': fromSlider,
    'radiusTo': toSlider,
    "departureWindow": originDate.toList(),
    "roundTripDepartureWindow": destinationDate.toList(),
    "TimeStamp": DateTime.now(),
  };
}

//Handles all Sign Out Functionality
Future<String> signOut() async {
  try {
    await _auth.signOut();
    await _googleSignIn.disconnect();
    return 'SignOut';
  } catch (e) {
    return e.toString();
  }
}
