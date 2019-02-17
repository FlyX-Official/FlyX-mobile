//import 'package:wefly/FloatingActionButton/fab_with_icons.dart';
import 'package:wefly/FloatingActionButton/fab_bottom_app_bar.dart';
import 'package:wefly/FloatingActionButton/layout.dart';
import 'package:wefly/SideBar/AppDrawer.dart';
import 'package:flutter/material.dart';

class FloatActBttn extends StatefulWidget {
  static String tag = 'bottom-nav';
  FloatActBttn({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _FloatActBttnState createState() => new _FloatActBttnState();
}

class _FloatActBttnState extends State<FloatActBttn>
    with TickerProviderStateMixin {
  String _lastSelected = 'TAB: 0';

  void _selectedTab(int index) {
    setState(() {
      _lastSelected = 'TAB: $index';
    });
  }

  void _selectedFab(int index) {
    setState(() {
      _lastSelected = 'FAB: $index';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: new AppDrawer(),

      body: Center(
        child: Text(
          _lastSelected,
          style: TextStyle(fontSize: 32.0),
        ),
      ),
      bottomNavigationBar: buildFabBottomAppBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildFab(
          context), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  FABBottomAppBar buildFabBottomAppBar() {
    return FABBottomAppBar(
      color: Colors.grey,
      selectedColor: Colors.red,
      notchedShape: CircularNotchedRectangle(),
      onTabSelected: _selectedTab,
      items: [
        FABBottomAppBarItem(iconData: Icons.menu),
        FABBottomAppBarItem(iconData: Icons.layers),
        FABBottomAppBarItem(iconData: Icons.dashboard),
        FABBottomAppBarItem(iconData: Icons.info),
      ],
    );
  }

  Widget _buildFab(BuildContext context) {
    // final icons = [Icons.sms, Icons.mail, Icons.phone];
    return FloatingActionButton(
      onPressed: () {
        AppDrawer();
      },
      tooltip: 'Increment',
      elevation: 4.0,
      //shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Icon(Icons.monetization_on),
    );
  }
}
