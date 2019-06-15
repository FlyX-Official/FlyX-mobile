import 'package:flutter/material.dart';
import 'package:rubber/rubber.dart';

import 'Ui/HeaderLayer.dart';
import 'Ui/LowerLayer.dart';
import 'Ui/SearchModal.dart';

RubberAnimationController _controller;
bool isExpanded = false;

class RubberSearch extends StatefulWidget {
  const RubberSearch({
    Key key,
  }) : super(key: key);

  @override
  _RubberSearchState createState() => _RubberSearchState();
}

class _RubberSearchState extends State<RubberSearch>
    with SingleTickerProviderStateMixin {
  GlobalKey _rubberBottomSheetKey = GlobalKey();
  void initState() {
    _controller = RubberAnimationController(
      vsync: this,
      dismissable: true,
      lowerBoundValue: AnimationControllerValue(pixel: 25),
      upperBoundValue: AnimationControllerValue(pixel: 370),
      duration: Duration(milliseconds: 200),
      animationBehavior: AnimationBehavior.preserve,
      //initialValue: AnimationControllerValue(pixel: 200),
    );
    _controller.addStatusListener(_statusListener);
    _controller.animationState.addListener(_stateListener);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _stateListener() {
    print("state changed ${_controller.animationState.value}");
  }

  void _statusListener(AnimationStatus status) {
    print("changed status ${_controller.status}");
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData _mediaQuery = MediaQuery.of(context);

    final _lowerLayerPageViewController = PageController();
    final _searchPageController = PageController();

    var _color2 = Color.fromARGB(255, 100, 135, 165);

    var _upperLayerColor2 = Color.fromARGB(75, 46, 209, 153);
    var _rubberBottomSheetKey;

    return Container(
      child: RubberBottomSheet(
        animationController: _controller,
        key: _rubberBottomSheetKey,
        lowerLayer: LowerLayerBody(),
        upperLayer: SearchModal(upperLayerColor2: _upperLayerColor2),
        header: HeaderLayer(color2: _color2),
        headerHeight: 25,
      ),
    );
  }
}

void collapse() {
  _controller.collapse();
  isExpanded = false;
}

void expand() {
  _controller.expand();
  isExpanded = true;
}
