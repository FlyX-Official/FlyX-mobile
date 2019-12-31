import 'package:flutter/material.dart';
import 'package:flyxweb/screens/SearchUiScreen/Contents/TicketList.dart';
import 'package:flyxweb/services/AutoComplete/AutoComplete.dart';
import 'package:flyxweb/services/UserQuery/UserQuery.dart';
import 'package:provider/provider.dart';

class SearchUi extends StatefulWidget {
  const SearchUi({Key key}) : super(key: key);

  @override
  _SearchUiState createState() => _SearchUiState();
}

class _SearchUiState extends State<SearchUi> {
  TextEditingController _inputController;

  @override
  void dispose() {
    _inputController.clear();
    _inputController.clearComposing();
    _inputController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _inputController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final _sugg = Provider.of<AutoCompleteCall>(context);
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      // resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        title: Text(Provider.of<UserQuery>(context).isOrigin
            ? 'Departure Airport'
            : 'Destination Airport'),
        automaticallyImplyLeading: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: Column(
        //alignment: Alignment.bottomCenter,
        children: <Widget>[
          Expanded(
            child: Provider.of<AutoCompleteCall>(context).data != null
                ? TicketList()
                : Container(
                    child: Center(
                      child: Text('It\'s Empty in here...'),
                    ),
                  ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            color: Colors.blueGrey,
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.mic,
                    color: Colors.white,
                  ),
                  onPressed: () {},
                ),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: TextFormField(
                        controller: _inputController,
                        autofocus: true,
                        enableSuggestions: true,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: 'Enter City or Airport code...',
                          border: InputBorder.none,
                        ),
                        onChanged: (val) => Provider.of<AutoCompleteCall>(context,listen: false).makeRequest(val),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Colors.white,
                  ),
                  onPressed: () => _inputController.clear(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
