import 'package:flutter/material.dart';
import 'package:flyx/Pages/HomePage/Search/Ui/LowerLayer.dart';
import 'package:flyx/Pages/HomePage/Search/Ui/SearchModal.dart';
import 'package:flyx/Pages/Logic/NetworkCalls.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'Search/SearchPageRoot.dart';


void nextPage() {
  homePageController.nextPage(
                    curve: Curves.easeInOutExpo.flipped,
                    duration: Duration(seconds: 1),
                  );
}
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _cIndex = 0;

  void _incrementTab(index) {
    setState(() {
      _cIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 100, 135, 165),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(FontAwesomeIcons.ticketAlt),
                onPressed: () {
                  nextPage();
                },
              );
            },
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: Icon(Icons.account_box),
                onPressed: () {
                  return;
                },
              ),
            )
          ],
        ),
        body: RubberSearch(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        //bottomNavigationBar: //buildBottomNavigationBar(),
      ),
    );
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: Color.fromARGB(255, 100, 135, 165),
      elevation: 8,
      selectedItemColor: Colors.lightGreenAccent,
      currentIndex: _cIndex,
      onTap: (index) {
        _incrementTab(index);
        print('Pressed$index button');
      },
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          title: Text('One-Way'),
          icon: IconButton(
            icon: Icon(
              FontAwesomeIcons.arrowRight,
            ),
            onPressed: () {
              expand();
            },
          ),
        ),
        BottomNavigationBarItem(
          title: Text('Two-Way'),
          icon: IconButton(
            iconSize: 24,
            icon: Icon(
              FontAwesomeIcons.exchangeAlt,
            ),
            onPressed: () {
              expand();
            },
          ),
        ),
      ],
    );
  }
}
