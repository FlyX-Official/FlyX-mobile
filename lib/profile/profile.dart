//import 'package:flyx/FloatingActionButton/fab_with_icons.dart';
import 'package:flyx/FloatingActionButton/fab_bottom_app_bar.dart';
import 'package:flyx/FloatingActionButton/layout.dart';
import 'package:flyx/SideBar/AppDrawer.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  static String tag = 'bottom-nav';
  Profile({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ProfileState createState() => new _ProfileState();
}

class _ProfileState extends State<Profile> with TickerProviderStateMixin {

  // initialize values for dropdonw menu
  String _value = null;
  String _preferredCity = null;


  List<String> _values = new List<String>();
  List<String> _preferredCities = new List<String>();

  
  Widget build(BuildContext context) {
    //_values.addAll(["Dollars","Euros","Pesos (MX)"]);
    //_value = _values.elementAt(0);

    return Scaffold(
      drawer:Center(),

      body: _buildProfilePage(context),

      bottomNavigationBar: buildFabBottomAppBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildFab(
          context), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  @override
  void initState(){
    /* populate all the data for the profile page */


    // initialize the dropdown with values
    _values.addAll(["Dollars","Euros","Pesos (MX)"]);
    // initialize the default value
    /* modify this to save the state if changed*/
    _value = _values.elementAt(0);

    
    _preferredCities.addAll(["LAX","SFO","JFK"]);
    _preferredCity =  _preferredCities.elementAt(0);

  }

  void _onChanged(String value){
    setState(() {
      _value =value;
    });
  }

  void _onChangedPreferredCity(String value){
    setState(() {
      _preferredCity =value;
    });
  }

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

  Widget _buildProfilePage(BuildContext context) {
    return new Scaffold(
      body:new SafeArea(
        child: ListView(
          children:<Widget>[
            SizedBox(height: 80.0,),
            Column(
              children: <Widget>[
                Container(
                  width: 190.0,
                  height: 190.0,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: new NetworkImage(
                            "https://picsum.photos/250?image=9")
                            )
                  )
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 10, 
                      color: Colors.transparent
                      )
                  ),
                  child:
                    Text("John Doe",style: TextStyle(
                    fontSize: 24.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Arial'
                  ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
          new Column(
            children: <Widget>[
              Text("Currency Preferred"),
              new DropdownButton(
                value: _value,
                items: _values.map((String value){
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: new Row(
                      children: <Widget>[
                        new Icon(Icons.monetization_on),
                        new Text('${value}')
                      ],
                    ),
                    //child: Text("data"),
                  );
                }).toList(),
                onChanged: (String value){_onChanged(value);},
                    ),
                  ],
                ),
              ],
            ),
          new Column(
              children: [
          new Column(
            children: <Widget>[
              Text("Local Airport Preferred"),
              new DropdownButton(
                value: _preferredCity,
                items: _preferredCities.map((String value){
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: new Row(
                      children: <Widget>[
                        new Icon(Icons.location_city),
                        new Text('${value}')
                      ],
                    ),
                    //child: Text("data"),
                  );
                }).toList(),
                onChanged: (String value){_onChangedPreferredCity(value);},
                    ),
                  ],
                ),
              ],            
          )

          ]

        ),
      )
    );
  }
}

