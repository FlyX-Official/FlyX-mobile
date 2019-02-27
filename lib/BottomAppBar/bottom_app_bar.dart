import 'package:flutter/material.dart';
import 'package:wefly/SideBar/AppDrawer.dart';
import 'package:wefly/TicketDisplayer/ticketViewer.dart';
import 'package:wefly/FloatingActionButton/floating_action_button_homepage.dart';

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
            icon: Icon(Icons.layers),
            color: Colors.blue,
            highlightColor: Colors.redAccent,
            onPressed: () {},
          ),
          SizedBox(
            height: 60,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ),
          IconButton(
            icon: Icon(Icons.dashboard),
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
