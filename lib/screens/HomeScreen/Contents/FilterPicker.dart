import 'package:flutter/material.dart';
import 'package:flyx/services/UserQuery/UserQuery.dart';
import 'package:provider/provider.dart';

class FliterWidget extends StatefulWidget {
  FliterWidget({Key key}) : super(key: key);

  @override
  _FliterWidgetState createState() => _FliterWidgetState();
}

class _FliterWidgetState extends State<FliterWidget> {
  List<bool> _isSelected;
  List<String> _sortTypes;
  @override
  void initState() {
    _isSelected = [false, false, false];
    _sortTypes = ['price', 'duration', 'quality'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ToggleButtons(
        constraints: BoxConstraints.expand(
            width: MediaQuery.of(context).size.shortestSide < 768
                ? MediaQuery.of(context).size.shortestSide / 3.25
                : 130,
            height: 48),
        children: <Widget>[
          const Text(
            'Price',
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          const Text(
            'Duration',
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          const Text(
            'Quality',
            style: TextStyle(
              fontSize: 24,
            ),
          ),
        ],
        isSelected: _isSelected,
        onPressed: (b) {
          setState(() {
            for (num i = 0; i < _isSelected.length; i++) {
              _isSelected[i] = false;
            }
            _isSelected[b] = !_isSelected[b];
            Provider.of<UserQuery>(context, listen: false)
                .setSortFilter(_sortTypes[b]);
          });
        },
      ),
    );
  }
}
