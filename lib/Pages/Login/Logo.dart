import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CircleAvatar(
        backgroundColor: Color.fromARGB(255, 46, 209, 153),
        radius: 100,
        child: Text(
          'FlyX',
          style: TextStyle(
            fontFamily: 'Fredoka',
            //fontStyle: FontStyle.normal,
            color: Colors.white,
            fontSize: 48,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
