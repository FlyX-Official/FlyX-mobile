import 'package:flutter/material.dart';
import 'package:wefly/InputPage/gMap.dart';
class InputForm extends StatefulWidget {
  static String tag = 'Input-Page';

  final Widget child;

  InputForm({Key key, this.child}) : super(key: key);

  _InputFormState createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
       child: SafeArea(
         child: Container(
           child: Stack(
             children: <Widget>[
               Container(
                 child: CustomGoogleMap(),
               )
             ],
           ),
         ),
       ),
    );
  }
}