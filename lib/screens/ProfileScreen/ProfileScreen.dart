import 'package:flutter/material.dart';
import 'package:flyx/services/Auth/Auth.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: CustomScrollView(
          shrinkWrap: true,
          // margin: const EdgeInsets.symmetric(
          //   horizontal: 8,
          // ),
          slivers: <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  // bottomRight: Radius.circular(16),
                ),
              ),
              actions: <Widget>[
                Card(
                  elevation: 4,
                  shape: CircleBorder(),
                  child: IconButton(
                    icon: const Icon(Icons.exit_to_app),
                    color: Colors.red,
                    // label: Text('Sign Out'),
                    //enableFeedback: true,S
                    onPressed: () =>
                        Provider.of<Auth>(context, listen: false).signOut(),
                  ),
                ),
              ],
              title: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                    Hive.box('User').getAt(0)[1],
                  ),
                ),
                title: Text(
                  Hive.box('User').getAt(0)[0],
                  style: TextStyle(color: Colors.white),
                ),
              ),
              centerTitle: true,
              floating: false,
              pinned: true,
              snap: false,
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  ExpansionTile(
                    leading: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                    title: const Text('Favorite Airports'),
                  ),
                ],
              ),
            )
          ],
        ),
      );
}
// WatchBoxBuilder(
//       box: Hive.box('User'),
//       builder: (context, b) => Text(
//         b.values.toList().toString(),
//       ),
//     );
