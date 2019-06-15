import 'package:flutter/material.dart';
import '../../Map/Map.dart';

class LowerLayerBody extends StatefulWidget {
  const LowerLayerBody({
    Key key,
  }) : super(key: key);

  @override
  _LowerLayerBodyState createState() => _LowerLayerBodyState();
}

class _LowerLayerBodyState extends State<LowerLayerBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: PageView(
        children: <Widget>[
          Container(
            child: Map(),
          )
        ],
      ),
    );
  }
}
