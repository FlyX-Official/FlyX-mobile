import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flyx/Pages/HomePage/TicketPage/TicketDart.dart';
import 'package:flyx/Pages/Logic/NetworkCalls.dart';
import 'package:flyx/Pages/Schema/TwoWaySchema.dart';
import '../../Map/Map.dart';

final homePageController = PageController();

class LowerLayerBody extends StatefulWidget {
  const LowerLayerBody({
    Key key,
  }) : super(key: key);

  @override
  _LowerLayerBodyState createState() => _LowerLayerBodyState();
}

// class _LowerLayerBodyState extends State<LowerLayerBody> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: PageView(
//         children: <Widget>[
//           Container(
//             child: Map(),
//           )
//         ],
//       ),
//     );
//   }
// }
class _LowerLayerBodyState extends State<LowerLayerBody> {
  int currentPage;
  @override
  void initState() {
    super.initState();
    currentPage = 0;
  }

  Future<RoundTrip> tmp;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: PageView(
        controller: homePageController,
        onPageChanged: (index) {
          if (index == 1) {
            tmp = twoWay();
            setState(() {
              index = 1;
            });
          }
        },
        children: <Widget>[
          MyMap(),
          TicketPage(),
        ],
      ),
    );
  }

}