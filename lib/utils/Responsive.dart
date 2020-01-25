// import 'package:flutter/widgets.dart';

// class Responsive extends StatelessWidget {
//   const Responsive({Key key, this.desktop, this.tablet, this.mobile})
//       : super(key: key);

//   final Widget desktop, tablet, mobile;

//   @override
//   Widget build(BuildContext context) =>
//       MediaQuery.of(context).size.shortestSide < 768
//           ? mobile
//           : MediaQuery.of(context).size.shortestSide > 768 &&
//                   MediaQuery.of(context).size.shortestSide < 1200
//               ? tablet ?? desktop
//               : desktop;
// }

// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

enum DisplayType {
  desktop,
  mobile,
}

const _desktopBreakpoint = 700.0;

/// Returns the [DisplayType] for the current screen. This app only supports
/// mobile and desktop layouts, and as such we only have one breakpoint.
DisplayType displayTypeOf(BuildContext context) =>
    MediaQuery.of(context).size.shortestSide > _desktopBreakpoint
        ? DisplayType.desktop
        : DisplayType.mobile;

/// Returns a boolean if we are in a display of [DisplayType.desktop]. Used to
/// build adaptive and responsive layouts.
bool isDisplayDesktop(BuildContext context) =>
    displayTypeOf(context) == DisplayType.desktop;
