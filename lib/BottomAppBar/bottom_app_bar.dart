import 'package:flutter/material.dart';
import 'package:flyx/SideBar/AppDrawer.dart';
import 'package:flyx/TicketDisplayer/ticketViewer.dart';
import 'package:flyx/FloatingActionButton/floating_action_button_homepage.dart';
import 'package:flyx/InputPage/inputForm.dart';
class BttmAppBar extends StatefulWidget {
  static String tag = 'bottom-app-bar';

  _BttmAppBarState createState() => _BttmAppBarState();
}

class _BttmAppBarState extends State<BttmAppBar> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color.fromARGB(255, 251, 108, 112),
      key: _scaffoldKey,
      drawer: new AppDrawer(),
      body: TicketView(),
      floatingActionButton: _buildFab(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomAppBar(),
    );
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
            },
          ),
          IconButton(
            icon: Icon(Icons.edit_location),
            color: Colors.blue,
            highlightColor: Colors.redAccent,
            onPressed: () { Navigator.of(context).pushNamed(InputForm.tag);},
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
            onPressed: () {
              Navigator.of(context).pushNamed(FloatActBttn.tag);
            },
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
    child: Icon(Icons.search),
    
  );
}
