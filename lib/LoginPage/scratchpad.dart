 _buildShowRoundedModalBottomSheet(BuildContext context) async {
    showRoundedModalBottomSheet(
        context: context,
        radius: 24,
        autoResize: true,
        dismissOnTap: false,
        color: Color.fromARGB(255, 247, 247, 247),
        builder: (BuildContext context) {
          return Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ModalDrawerHandle(),
                ),
                Container(
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(8),
                    //height: MediaQuery.of(context).size.height * .6,
                    // decoration: BoxDecoration(
                    //   boxShadow: [
                    //     BoxShadow(
                    //       color: Colors.black54,
                    //       blurRadius: 16,
                    //     )
                    //   ],
                    //   color: Colors.blueAccent,
                    //   borderRadius: BorderRadius.only(
                    //     topLeft: Radius.circular(24),
                    //     topRight: Radius.circular(24),
                    //   ),
                    // ),
                    //color: Colors.blue,

                    child: Container(
                      //height: MediaQuery.of(context).size.height * .6,
                      //margin: EdgeInsets.all(8),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            // Container(
                            //   padding: EdgeInsets.only(bottom: 10),
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.center,
                            //     mainAxisSize: MainAxisSize.max,
                            //     children: <Widget>[
                            //       FlatButton(
                            //         child: Text('ONE WAY'),
                            //         color: Colors.white,
                            //         onPressed: (){},
                            //       ),
                            //       FlatButton(
                            //         child: Text(''),
                            //         color: Colors.transparent,
                            //         onPressed: () {},
                            //       ),
                            //       FlatButton(
                            //         child: Text('ROUND TRIP'),
                            //         color: Colors.white,
                            //         onPressed: () {},
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            Container(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.width *
                                                .1),
                                    child: Container(
                                        child:
                                            _isFromOpen //(_isSearching && (!_onTap))
                                                ? getFromWidget()
                                                : null),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 8, right: 8),
                                    child: Card(
                                      elevation: 8,
                                      color: Colors.white,
                                      child: Padding(
                                        child: TextFormField(
                                          controller: _from,
                                          //focusNode: _flyingFromFocusNode,
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return 'Field cannot be empty';
                                            }
                                          },
                                          onFieldSubmitted: (String value) {
                                            print("$value submitted");
                                            setState(() {
                                              _from.text = value;
                                              _onTap = true;
                                            });
                                          },

                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            icon: Icon(
                                              FontAwesomeIcons.planeDeparture,
                                              color: Colors.blue,
                                              //size: 22.0,
                                            ),
                                            hintText: 'Flying From',
                                            hintStyle: TextStyle(
                                                fontFamily: "Nunito",
                                                fontSize: 17.0),
                                          ),
                                        ),
                                        padding: EdgeInsets.only(
                                          left: 16,
                                          bottom: 8,
                                          top: 8,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Container(margin: EdgeInsets.only(top: 160),color: Colors.white,child: ExpansionTile(title: Text('this'),),),
                                  InkWell(
                                    onTap: () {
                                      _addOriginAirportMarkers();
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          .6,
                                      child: Card(
                                        elevation: 4,
                                        color: Colors.white,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              child: Slider(
                                                value: _fromSlider.toDouble(),
                                                min: 1.0,
                                                max: 100.0,
                                                divisions: 5,
                                                label: '$_fromSlider',
                                                onChanged: (double Value) {
                                                  _addOriginAirportMarkers();
                                                  setState(
                                                    () {
                                                      _fromSlider =
                                                          Value.floor();
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                            Text("$_fromSlider Mi"),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.width *
                                                .1),
                                    child: Container(
                                        child:
                                            _isToOpen //(_isSearching && (!_onTap))
                                                ? getToWidget()
                                                : null),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(right: 8, left: 8),
                                    child: Card(
                                      elevation: 8,
                                      child: Padding(
                                        child: TextFormField(
                                          controller: _to,
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return 'Field cannot be empty';
                                            }
                                          },
                                          onFieldSubmitted: (String value) {
                                            print("$value submitted");
                                            setState(() {
                                              _to.text = value;
                                              _onTap = true;
                                            });
                                          },
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            icon: Icon(
                                              FontAwesomeIcons.planeDeparture,
                                              color: Colors.blue,
                                              //size: 22.0,
                                            ),
                                            hintText: 'Flying To',
                                            hintStyle: TextStyle(
                                                fontFamily: "Nunito",
                                                fontSize: 17.0),
                                          ),
                                        ),
                                        padding: EdgeInsets.only(
                                            left: 16, top: 8, bottom: 8),
                                      ),
                                    ),
                                  ),
                                  // Container(margin: EdgeInsets.only(top: 160),color: Colors.white,child: ExpansionTile(title: Text('this'),),),
                                  InkWell(
                                    onTap: () {
                                      _addDestinationAirportMarkers();
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          .6,
                                      child: Card(
                                        elevation: 8,
                                        color: Colors.white,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              child: Slider(
                                                value: _toSlider.ceilToDouble(),
                                                min: 1.0,
                                                max: 100.0,
                                                divisions: 5,
                                                label:
                                                    '$_toSlider', //var _toSlider = 1;,
                                                onChanged: (double Value) {
                                                  _addDestinationAirportMarkers();
                                                  setState(() {
                                                    _toSlider = Value.round();
                                                  });
                                                },
                                              ),
                                            ),
                                            Text("$_toSlider Mi"),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Card(
                                      margin: EdgeInsets.only(
                                          top: 8, left: 16, right: 16),
                                      elevation: 8,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      child: FlatButton(
                                        color: Colors.white,
                                        onPressed: () async {
                                          final List<DateTime> originPicked =
                                              await DateRangePicker
                                                  .showDatePicker(
                                                      context: context,
                                                      initialFirstDate:
                                                          DateTime.now(),
                                                      initialLastDate:
                                                          (DateTime.now()).add(
                                                              Duration(
                                                                  days: 7)),
                                                      firstDate: DateTime(2019),
                                                      lastDate: DateTime(2020));
                                          if (originPicked != null &&
                                              originPicked.length == 2) {
                                            print(originPicked);
                                            _originDate = originPicked.toList();
                                          }
                                        },
                                        child: Icon(Icons.date_range),
                                        /*child: Text(
                                      '${DateTime.now().month}-${DateTime.now().day}-${DateTime.now().year} <-> ' +
                                          '${DateTime.now().month}-${DateTime.now().day + 7}-${DateTime.now().year}' +
                                          '$_originDate'
                                          'yyyy-mm-dd <---> yyyy-mm-dd'
                                      ),*/
                                        //'Departure Date Picker'),
                                      ),
                                    ),
                                  ),

                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Card(
                                      margin: EdgeInsets.only(
                                          top: 8, left: 16, right: 16),
                                      elevation: 8,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      child: FlatButton(
                                        color: Colors.white,
                                        onPressed: () async {
                                          final List<DateTime>
                                              returnDatePicked =
                                              await DateRangePicker
                                                  .showDatePicker(
                                                      context: context,
                                                      initialFirstDate:
                                                          DateTime.now()
                                                              .add(
                                                                  Duration(
                                                                      days: 7)),
                                                      initialLastDate:
                                                          (DateTime.now()).add(
                                                              Duration(
                                                                  days: 14)),
                                                      firstDate: DateTime(2019),
                                                      lastDate: DateTime(2020));
                                          if (returnDatePicked != null &&
                                              returnDatePicked.length == 2) {
                                            print(returnDatePicked);
                                            _destinationDate =
                                                returnDatePicked.toList();
                                          }
                                        },
                                        child: Icon(Icons.date_range),
                                        /*child: Text(
                                      '${DateTime.now().month}-${DateTime.now().day}-${DateTime.now().year} <-> ' +
                                          '${DateTime.now().month}-${DateTime.now().day + 7}-${DateTime.now().year}' +
                                          '$_originDate'
                                          'yyyy-mm-dd <---> yyyy-mm-dd'
                                      ),*/
                                        //'Departure Date Picker'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }