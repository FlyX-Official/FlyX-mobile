import 'package:flutter/material.dart';
import 'package:groovin_widgets/modal_drawer_handle.dart';

class HeaderLayer extends StatelessWidget {
  const HeaderLayer({
    Key key,
    @required Color color2,
  }) : _color2 = color2, super(key: key);

  final Color _color2;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          color: _color2),
      padding: EdgeInsets.all(8),
      child: ModalDrawerHandle(
        handleColor: Color.fromARGB(255, 10, 203, 171),
        handleBorderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
    );
  }
}