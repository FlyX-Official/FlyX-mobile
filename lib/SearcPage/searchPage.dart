import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SearchCard extends StatefulWidget {
  @override
  _SearchCardState createState() => _SearchCardState();
}

class _SearchCardState extends State<SearchCard>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  PageController _searchPageController =
      PageController(keepPage: true, initialPage: 0);

  int radioValue = 0, _currentPage;
  bool _isOneWay;

  @override
  void initState() {
    super.initState();
    _isOneWay = true;
    _currentPage = 0;
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void handleRadioValueChanged(int value) {
    setState(() {
      radioValue = value;
      if (value == 1) {
        _isOneWay = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData _mediaQuery = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Material(
        type: MaterialType.card,
        color: Colors.black,
        elevation: 8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            (_currentPage > 0)
                ? Container(
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        FlatButton.icon(
                          color: Colors.white,
                          label: Text(
                            'BACK',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadiusDirectional.circular(8)),
                          icon: Icon(FontAwesomeIcons.checkCircle),
                          onPressed: () {
                            _searchPageController.previousPage(
                              curve: Curves.easeInOutExpo,
                              duration: Duration(milliseconds: 1000),
                            );
                            _currentPage = 1;
                          },
                        ),
                        FlatButton.icon(
                          color: Colors.white,
                          label: Text(
                            'NEXT',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadiusDirectional.circular(8)),
                          icon: Icon(FontAwesomeIcons.checkCircle),
                          onPressed: () {
                            _searchPageController.nextPage(
                              curve: Curves.easeInOutExpo,
                              duration: Duration(milliseconds: 1000),
                            );
                            _currentPage = 1;
                          },
                        )
                      ],
                    ),
                  )
                : Container(
                    margin: EdgeInsets.only(right: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        FlatButton.icon(
                          color: Colors.white,
                          label: Text(
                            'NEXT',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadiusDirectional.circular(8)),
                          icon: Icon(FontAwesomeIcons.checkCircle),
                          onPressed: () {
                            _searchPageController.nextPage(
                              curve: Curves.easeInOutExpo,
                              duration: Duration(milliseconds: 1000),
                            );
                            _currentPage = 1;
                          },
                        )
                      ],
                    ),
                  ),
            Container(
              height: 110,
              child: PageView(
                controller: _searchPageController,
                scrollDirection: Axis.horizontal,
                onPageChanged: (i) {
                  if (i == 0) {
                    setState(() {
                      _currentPage = 0;
                    });
                  } else if (i == 1) {
                    setState(() {
                      _currentPage = 1;
                    });
                  }
                },
                children: <Widget>[
                  _pageZero(_mediaQuery),
                  _CardWidget(
                    key: UniqueKey(),
                    mediaQuery: _mediaQuery,
                    labelOne: "FROM",
                    labelTwo: "TO",
                    isOneWay: true,
                    colors: Colors.black,
                  ),
                  _CardWidget(
                    key: UniqueKey(),
                    mediaQuery: _mediaQuery,
                    labelOne: "DEPARTURE DATE",
                    labelTwo: "RETURN DATE",
                    iconOne: FontAwesomeIcons.calendarWeek,
                    iconTwo: FontAwesomeIcons.calendarWeek,
                    isOneWay: (_isOneWay) ? false : true,
                    colors: (_isOneWay) ? Colors.black45 : Colors.black,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Card _pageZero(MediaQueryData _mediaQuery) {
    return Card(
      elevation: 8,
      margin: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            height: 100,
            width: _mediaQuery.size.width * .45,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Card(
              elevation: 0,
              child: Align(
                alignment: FractionalOffset.center,
                child: RadioListTile(
                  value: 0,
                  groupValue: radioValue,
                  title: Text('ONE WAY'),
                  dense: true,
                  onChanged: handleRadioValueChanged,
                ),
              ),
            ),
          ),
          Container(
            height: 75,
            width: 1.0,
            color: Colors.red,
          ),
          Container(
            height: 100,
            width: _mediaQuery.size.width * .45,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Card(
              elevation: 0,
              child: Align(
                alignment: FractionalOffset.centerLeft,
                child: RadioListTile(
                  value: 1,
                  groupValue: radioValue,
                  title: Text('ROUND TRIP'),
                  dense: true,
                  onChanged: handleRadioValueChanged,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardWidget extends StatelessWidget {
  const _CardWidget({
    Key key,
    @required MediaQueryData mediaQuery,
    String labelOne,
    String labelTwo,
    IconData iconOne,
    IconData iconTwo,
    bool isOneWay,
    Color colors,
    int currentPage,
  })  : _mediaQuery = mediaQuery,
        _labelOne = labelOne,
        _labelTwo = labelTwo,
        _iconOne = iconOne,
        _iconTwo = iconTwo,
        _isOneWay = isOneWay,
        _colors = colors,
        _currentPage = currentPage,
        super(key: key);

  final MediaQueryData _mediaQuery;
  final String _labelOne, _labelTwo;
  final IconData _iconOne, _iconTwo;
  final bool _isOneWay;
  final Color _colors;
  final int _currentPage;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      margin: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            height: 100,
            width: _mediaQuery.size.width * .45,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Card(
              elevation: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Align(
                    alignment: FractionalOffset.topCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[Text(_labelOne), Icon(_iconOne)],
                    ),
                  ),
                  Align(
                    alignment: FractionalOffset.center,
                    child: TextFormField(),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 75,
            width: 1.0,
            color: Colors.red,
          ),
          Container(
            height: 100,
            width: _mediaQuery.size.width * .45,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Card(
              elevation: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Align(
                    alignment: FractionalOffset.topCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          _labelTwo,
                          style: TextStyle(color: _colors),
                        ),
                        Icon(_iconTwo, color: _colors),
                      ],
                    ),
                  ),
                  Align(
                    alignment: FractionalOffset.topCenter,
                    child: TextFormField(
                      enabled: _isOneWay,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
