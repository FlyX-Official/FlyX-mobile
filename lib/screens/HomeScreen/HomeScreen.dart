import 'package:flutter/material.dart';
import 'package:flyxweb/screens/HomeScreen/Contents/Cities.dart';
import 'package:flyxweb/screens/HomeScreen/Contents/DateEntries.dart';
import 'package:flyxweb/screens/HomeScreen/Contents/SearchButton.dart';
import 'package:flyxweb/screens/HomeScreen/Contents/TripType.dart';
import 'package:flyxweb/screens/SearchUiScreen/SearchUi.dart';
import 'package:flyxweb/screens/TicketResultsScreen/TicketResultsScreen.dart';
import 'package:flyxweb/services/UserQuery/UserQuery.dart';
import 'package:flyxweb/utils/Responsive.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _mq = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        desktop: Row(
          children: <Widget>[
            Card(
              elevation: 8,
              child: SizedBox(
                height: _mq.height,
                width: 400,
                child: ListView(
                  // physics: const BouncingScrollPhysics(),
                  children: <Widget>[
                    //  const Divider(
                    //       color: Colors.white,
                    //     ),
                    // ModalDrawerHandle(
                    //   handleColor: Colors.lightGreenAccent,
                    // ),
                    const Divider(),
                    TripType(),
                    const Divider(),
                    Provider.of<UserQuery>(context, listen: true).isOrigin !=
                                null &&
                            true
                        ? Container(
                            height: _mq.height / 2,
                            child: SearchUi(),
                          )
                        : Container(),
                    const Divider(),
                    Provider.of<UserQuery>(context, listen: true).isOrigin !=
                                null &&
                            false
                        ? Container(
                            height: _mq.height / 2,
                            child: SearchUi(),
                          )
                        : Container(),
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
                    SearchButton(),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Tickets(),
              ),
              // constraints: BoxConstraints.expand(),
            ),
          ],
        ),
      ),
    );
  }
}
