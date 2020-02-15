import 'package:flutter/material.dart';
import 'package:flyx/screens/GoogleMap/GMap.dart';
import 'package:flyx/screens/HomeScreen/Contents/Cities.dart';
import 'package:flyx/screens/HomeScreen/Contents/DateEntries.dart';
import 'package:flyx/screens/HomeScreen/Contents/FilterPicker.dart';
import 'package:flyx/screens/HomeScreen/Contents/SearchButton.dart';
import 'package:flyx/screens/HomeScreen/Contents/TripType.dart';
import 'package:flyx/screens/ProfileScreen/ProfileScreen.dart';
import 'package:flyx/services/UserQuery/UserQuery.dart';
import 'package:groovin_widgets/modal_drawer_handle.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProfileScreen(),
              ),
            ),
          )
        ],
      ),
      body: SizedBox.expand(
        child: Stack(
          children: <Widget>[
            GMap(),
            SizedBox.expand(
              child: DraggableScrollableSheet(
                expand: true,
                maxChildSize: .6,
                minChildSize: .1,
                initialChildSize: .6,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    child: ListView(
                      controller: scrollController,
                      children: <Widget>[
                        const Divider(
                          color: Colors.white,
                        ),
                        ModalDrawerHandle(
                          handleColor: Colors.lightGreenAccent,
                        ),
                        const Divider(),
                        TripType(),
                        const Divider(),
                        Cities(),
                        const Divider(),
                        DepartureDate(),
                        const Divider(),
                        !Provider.of<UserQuery>(context).isOneWay
                            ? ReturnDate()
                            : Container(),
                        !Provider.of<UserQuery>(context).isOneWay
                            ? const Divider()
                            : Container(),
                        FliterWidget(),
                        Divider(),
                        SearchButton(),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ), //GMap(),
    );
  }
}
