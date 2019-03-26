import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            return TileItem(num: index);
          },
        ),
      ),
    );
  }
}

Color colorFromNum(int num) {
  var random = Random(num);
  var r = random.nextInt(256);
  var g = random.nextInt(256);
  var b = random.nextInt(256);
  return Color.fromARGB(255, r, g, b);
}

class TileItem extends StatelessWidget {
  final int num;

  const TileItem({Key key, this.num}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "card$num",
      child: Card(
        color: colorFromNum(num),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 485.0 / 384.0,
                  child: Image.network("https://picsum.photos/485/384?image=$num"),
                ),
                Material(
                  type: MaterialType.transparency,
                  child: ListTile(
                    title: Text("Item $num"),
                    subtitle: Text("This is item #$num"),
                  ),
                )
              ],
            ),
            Positioned(
              left: 0.0,
              top: 0.0,
              bottom: 0.0,
              right: 0.0,
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  onTap: () async {
                    await Future.delayed(Duration(milliseconds: 200));
                    Navigator.push(
                      context,
                      SlowMaterialPageRoute(
                        builder: (context) {
                          return new PageItem(num: num);
                        },
                        fullscreenDialog: true,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PageItem extends StatelessWidget {
  final int num;

  const PageItem({Key key, this.num}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "card$num",
      child: Scaffold(
        backgroundColor: colorFromNum(num),
        appBar: AppBar(
          backgroundColor: Colors.white.withOpacity(0.2),
        ),
      ),
    );
  }
}

class SlowMaterialPageRoute<T> extends MaterialPageRoute<T> {
  SlowMaterialPageRoute({
    WidgetBuilder builder,
    RouteSettings settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(builder: builder, settings: settings, fullscreenDialog: fullscreenDialog);

  @override
  Duration get transitionDuration => const Duration(seconds: 1);
}