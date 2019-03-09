import 'package:flutter/material.dart';
import 'package:flyx/SideBar/AppDrawer.dart';
import 'package:flyx/TicketDisplayer/ticketViewer.dart';
import 'package:flyx/FloatingActionButton/floating_action_button_homepage.dart';
import 'package:flyx/InputPage/inputForm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flyx/LoginPage/login_page.dart';
import 'package:flyx/settings/settings.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

class BttmAppBar extends StatefulWidget {
  static String tag = 'bottom-app-bar';

  _BttmAppBarState createState() => _BttmAppBarState();
}

class _BttmAppBarState extends State<BttmAppBar> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  GoogleSignInAccount _currentUser;
  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 251, 108, 112),
      key: _scaffoldKey,
      //bottomSheet: showMenu(),
      drawer: AppDrawer(),
      body: TicketView(),
      floatingActionButton: _buildFab(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomAppBar(),
    );
  }

  showModalMenu() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
              color: Color(0xff232f34),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                  height: 36,
                ),
                SizedBox(
                    height: (56 * 6).toDouble(),
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16.0),
                            topRight: Radius.circular(16.0),
                          ),
                          color: Color(0xff344955),
                        ),
                        child: Stack(
                          alignment: Alignment(0, 0),
                          overflow: Overflow.visible,
                          children: <Widget>[
                            Positioned(
                              top: -36,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                    border: Border.all(
                                        color: Color(0xff232f34), width: 10)),
                                child: Center(
                                  child: ClipOval(
                                    child: Image.network(
                                      _currentUser.photoUrl,
                                      fit: BoxFit.cover,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .075,
                                      width:
                                          MediaQuery.of(context).size.height *
                                              .075,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              child: ListView(
                                physics: AlwaysScrollableScrollPhysics(),
                                children: <Widget>[
                                  ListTile(
                                    title: Text(
                                      "Inbox",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    leading: Icon(
                                      Icons.inbox,
                                      color: Colors.white,
                                    ),
                                    onTap: () {},
                                  ),
                                  ListTile(
                                    title: Text(
                                      "Starred",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    leading: Icon(
                                      Icons.star_border,
                                      color: Colors.white,
                                    ),
                                    onTap: () {},
                                  ),
                                  ListTile(
                                    title: Text(
                                      "Sent",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    leading: Icon(
                                      Icons.send,
                                      color: Colors.white,
                                    ),
                                    onTap: () {},
                                  ),
                                  ListTile(
                                    title: Text(
                                      "Trash",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    leading: Icon(
                                      Icons.delete_outline,
                                      color: Colors.white,
                                    ),
                                    onTap: () {},
                                  ),
                                  ListTile(
                                    title: Text(
                                      "Spam",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    leading: Icon(
                                      Icons.error,
                                      color: Colors.white,
                                    ),
                                    onTap: () {},
                                  ),
                                  ListTile(
                                    title: Text(
                                      "Drafts",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    leading: Icon(
                                      Icons.mail_outline,
                                      color: Colors.white,
                                    ),
                                    onTap: () {},
                                  ),
                                ],
                              ),
                            )
                          ],
                        ))),
              ],
            ),
          );
        });
  }

  BottomAppBar _buildBottomAppBar() {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.menu),
            color: Colors.red,
            highlightColor: Colors.redAccent,
            onPressed: () {
              _scaffoldKey.currentState.openDrawer();
            }, //showMenu,
          ),
          IconButton(
            icon: Icon(Icons.edit_location),
            color: Colors.blue,
            highlightColor: Colors.redAccent,
            onPressed: () {
              Navigator.of(context).pushNamed(InputForm.tag);
            },
          ),
          SizedBox(
            height: 60,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ),
          IconButton(
            icon: Icon(Icons.notifications),
            color: Colors.green,
            highlightColor: Colors.redAccent,
            onPressed: () {
              // _scaffoldKey.currentState.openDrawer();
            },
          ),
          IconButton(
              icon: Icon(Icons.account_box),
              color: Colors.orange,
              highlightColor: Colors.redAccent,
              onPressed:
                  showModalMenu /* () {
              Navigator.of(context).pushNamed(FloatActBttn.tag);
            },*/
              )
        ],
      ),
    );
  }
}

Widget _buildFab(BuildContext context) {
  return FloatingActionButton(
    onPressed: () {
      AppDrawer();
    },
    tooltip: 'fab',
    elevation: 4.0,

    //shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(8)),
    child: Icon(Icons.payment),
  );
}

/*
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
            ),
            color: Colors.green,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              
              SizedBox(
                  height: (56 * 6).toDouble(),
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.0),
                          topRight: Radius.circular(16.0),
                        ),
                        color: Colors.greenAccent,
                      ),
                      child: Stack(
                        alignment: Alignment(0, 0),
                        overflow: Overflow.visible,
                        children: <Widget>[
                          Positioned(
                            top: -36,
                            child: Container(
                              child: Center(
                                child: ClipOval(
                                  child: Image.network(
                                    _currentUser.photoUrl,
                                    fit: BoxFit.cover,
                                    height: MediaQuery.of(context).size.height *
                                        .07,
                                    width: MediaQuery.of(context).size.height *
                                        .07,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            child: ListView(
                              physics: NeverScrollableScrollPhysics(),
                              children: <Widget>[
                                ListTile(
                                  title: Text(
                                    "Inbox",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  leading: Icon(
                                    Icons.inbox,
                                    color: Colors.white,
                                  ),
                                  onTap: () {},
                                ),
                                ListTile(
                                  title: Text(
                                    "Starred",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  leading: Icon(
                                    Icons.star_border,
                                    color: Colors.white,
                                  ),
                                  onTap: () {},
                                ),
                                ListTile(
                                  title: Text(
                                    "Sent",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  leading: Icon(
                                    Icons.send,
                                    color: Colors.white,
                                  ),
                                  onTap: () {},
                                ),
                                ListTile(
                                  title: Text(
                                    "Trash",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  leading: Icon(
                                    Icons.delete_outline,
                                    color: Colors.white,
                                  ),
                                  onTap: () {},
                                ),
                                ListTile(
                                  title: Text(
                                    "Spam",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  leading: Icon(
                                    Icons.error,
                                    color: Colors.white,
                                  ),
                                  onTap: () {},
                                ),
                                ListTile(
                                  title: Text(
                                    "Drafts",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  leading: Icon(
                                    Icons.mail_outline,
                                    color: Colors.white,
                                  ),
                                  onTap: () {},
                                ),
                              ],
                            ),
                          )
                        ],
                      ))),
              /*Container(
                  height: 56,
                  color: Color(0xff4a6572),
                )*/
            ],
          ),
        ); */
