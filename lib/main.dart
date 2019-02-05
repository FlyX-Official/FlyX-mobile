import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'Tickets';

    return MaterialApp(
      title: title,
      showPerformanceOverlay: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.blueAccent,
      ),
      home: new HomePage(),
      routes: <String, WidgetBuilder>{
        "/SecondPage": (BuildContext context) => new SecondPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Hero(tag: 'dash', child: new FAB()),
      //appBar: AppBar(),

      body: SafeArea(
        child: Container(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverPadding(
                  padding: const EdgeInsets.all(8),
                  sliver: SliverGrid.count(
                    // Create a grid with 2 columns. If you change the scrollDirection to horizontal, this would produce 2 rows.
                    crossAxisCount: 2,
                    // Generate 100 Widgets that display their index in the List
                    crossAxisSpacing: 0,
                    children: List.generate(10, (index) {
                      return ConstrainedBox(
                        constraints: BoxConstraints.expand(height: 300),
                        child: Card(
                          elevation: 8,
                          child: Container(
                            margin: EdgeInsets.all(8),
                            child: custButtonScaffold(index, context),
                          ),
                        ),
                      );
                    }),
                  )),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blueAccent,
        elevation: 2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            new DepartureButton(),
            new ArrivalButton(),
          ],
        ),
      ),
    );
  }

  RaisedButton custButtonScaffold(int index, BuildContext context) {
    return RaisedButton(
      color: Colors.deepOrangeAccent,
      onPressed: () {
        showDialog(
          context: context,
          builder:(_)=> new AlertDialog(
            title: Text('AlertDialog'),
            content: Text('Ticket $index Pressed'),
          ),
        );
      },
      child: Text('Ticket $index'),
    );
  }
}

//Second Page
class SecondPage extends StatelessWidget {
  const SecondPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      //floatingActionButton: new FAB(),
      //appBar: AppBar(),

      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Center(
            child: Text('Payment Page'),
          ),
          /*child: CustomScrollView(
            slivers: <Widget>[
              SliverPadding(
                  padding: const EdgeInsets.all(8),
                  sliver: SliverGrid.count(
                    // Create a grid with 2 columns. If you change the scrollDirection to horizontal, this would produce 2 rows.
                    crossAxisCount: 2,
                    // Generate 100 Widgets that display their index in the List
                    crossAxisSpacing: 0,
                    children: List.generate(10, (index) {
                      return ConstrainedBox(
                        constraints: BoxConstraints.expand(height: 300),
                        child: Card(
                          elevation: 8,
                          child: Container(
                            margin: EdgeInsets.all(8),
                            color: Colors.deepPurpleAccent,
                            child: Center(
                              child: Text(
                                'Ticket \n$index',
                                style: Theme.of(context).textTheme.headline,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  )),
            ],
          ),*/
        ),
      ),
      /*bottomNavigationBar: BottomAppBar(
        color: Colors.blueAccent,
        elevation: 2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            new DepartureButton(),
            new ArrivalButton(),
          ],
        ),
      ),*/
    );
  }
}

class ArrivalButton extends StatelessWidget {
  const ArrivalButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.flight_land),
      color: Colors.white,
      tooltip: 'Destination',
      onPressed: () {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Arrival button Pressed'),
          duration: Duration(),
        ));
        print('Arrival button pressed'); //logs to console
      },
    );
  }
}

class DepartureButton extends StatelessWidget {
  const DepartureButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.flight_takeoff),
      color: Colors.white,
      tooltip: 'Origin',
      onPressed: () {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Departure button Pressed'),
          duration: Duration(),
        ));
        print('Departure button pressed'); //logs to console
      },
    );
  }
}

class FAB extends StatelessWidget {
  const FAB({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -math.pi / 4,
      child: FloatingActionButton(
        foregroundColor: Colors.black,
        backgroundColor: Colors.greenAccent[400],
        tooltip: 'Pay',
        onPressed: () {
          Navigator.of(context).pushNamed("/SecondPage");
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('Pay button Pressed'),
            duration: Duration(),
          ));
          print('Floating Action Button Pressed');
        },
        shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Transform.rotate(
            angle: -math.pi / -4, child: Icon(Icons.monetization_on)),
      ),
    );
  }
}

/*

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tickets"),
      ),
      body: Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 8,
              child: Container(
                width: 500,
                height: 500,
                child: Text('card 1'),
              ),
              color: Colors.blueAccent,
              shape:  RoundedRectangleBorder(
                side: BorderSide(color: Colors.black12),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hi there',
      home: HomePage(),
      theme: ThemeData(primarySwatch: Colors.lightBlue),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('testing'),backgroundColor: Colors.deepOrangeAccent,),
      body: Center(
        child: Card(
          elevation: 16,
          
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              BackButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class BackButton extends StatelessWidget {
  const BackButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      elevation: 8,
      child: Text('Back'),
      color: Colors.redAccent,
      onPressed: () {
        SnackBar(
          content: Text('red button pressed'),
          duration: Duration(milliseconds: 500),
        );
      },
      shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
    );
  }
}
*/
