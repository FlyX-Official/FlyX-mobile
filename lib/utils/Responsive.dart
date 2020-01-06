import 'package:flutter/widgets.dart';

class Responsive extends StatelessWidget {
  const Responsive({Key key, this.desktop, this.tablet, this.mobile})
      : super(key: key);

  final Widget desktop, tablet, mobile;

  @override
  Widget build(BuildContext context) =>
      MediaQuery.of(context).size.shortestSide < 768
          ? mobile
          : MediaQuery.of(context).size.shortestSide > 768 &&
                  MediaQuery.of(context).size.shortestSide < 1200
              ? tablet ?? desktop
              : desktop;
}
