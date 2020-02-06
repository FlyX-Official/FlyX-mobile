import 'package:flutter/material.dart';
import 'package:flyxweb/screens/HomeScreen/Contents/Cities.dart';
import 'package:flyxweb/screens/HomeScreen/Contents/DateEntries.dart';
import 'package:flyxweb/screens/HomeScreen/Contents/FilterPicker.dart';
import 'package:flyxweb/screens/HomeScreen/Contents/SearchButton.dart';
import 'package:flyxweb/screens/HomeScreen/Contents/TripType.dart';
<<<<<<< HEAD
=======
import 'package:flyxweb/screens/SearchUiScreen/SearchUi.dart';
>>>>>>> 42aa53c25962b24e009aa456f0f3dafd73fc754f
import 'package:flyxweb/screens/TicketResultsScreen/TicketResultsScreen.dart';
import 'package:flyxweb/services/UserQuery/UserQuery.dart';
import 'package:flyxweb/utils/Responsive.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    // final Size _mq = MediaQuery.of(context).size;
=======
    final Size _mq = MediaQuery.of(context).size;
>>>>>>> 42aa53c25962b24e009aa456f0f3dafd73fc754f
    var _searchScreen = <Widget>[
      //  const Divider(
      //       color: Colors.white,
      //     ),
      // ModalDrawerHandle(
      //   handleColor: Colors.lightGreenAccent,
      // ),
      const Divider(),
      TripType(),
      const Divider(),
      // if (isDisplayDesktop(context) &&
      //     Provider.of<UserQuery>(context, listen: true).isOrigin != null &&
      //     true)
      //   Container(
      //     height: _mq.height / 2,
      //     child: SearchUi(),
      //   ),

      const Divider(),
      // if (isDisplayDesktop(context) &&
      //     Provider.of<UserQuery>(context, listen: true).isOrigin != null &&
      //     false)
      //   Container(
      //     height: _mq.height / 2,
      //     child: SearchUi(),
      //   ),
      Cities(),
      const Divider(),
      DepartureDate(),
      const Divider(),
      !Provider.of<UserQuery>(context).isOneWay ? ReturnDate() : Container(),
      !Provider.of<UserQuery>(context).isOneWay ? const Divider() : Container(),
      FliterWidget(),
      Divider(),
      SearchButton(),
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        centerTitle: true,
        title: const ListTile(
          leading: const Icon(
            Icons.warning,
            color: Colors.yellow,
          ),
          title: const Text(
            'This is a Pre-Alpha Version. Filled with Bugs. Be patient and proceed with CAUTION. ',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: isDisplayDesktop(context)
          ? Row(
              children: <Widget>[
                Drawer(
                  child: SafeArea(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, index) =>
                          _searchScreen.elementAt(index),
                      itemCount: _searchScreen.length,
                    ),
                  ),
                ),
                Expanded(
                  child: Scaffold(
                    body: Tickets(),
                  ),
                ),
              ],
            )
          // ? Row(
          //     children: <Widget>[
          //       Card(
          //         elevation: 8,
          //         child: SizedBox(
          //           height: _mq.height,
          //           width: 400,
          //           child: ListView(
          //             // physics: const BouncingScrollPhysics(),

          //             children: _searchScreen,
          //           ),
          //         ),
          //       ),
          //       Expanded(
          //         child: Padding(
          //           padding: const EdgeInsets.symmetric(horizontal: 16.0),
          //           child: const Tickets(),
          //         ),
          //         // constraints: BoxConstraints.expand(),
          //       ),
          //     ],
          //   )
          : ListView(
              children: _searchScreen,
            ),
    );
  }
}
