import 'package:flutter/material.dart';
import 'package:flyx/Pages/HomePage/Search/Ui/SearchModal.dart';
import 'package:flyx/Pages/Logic/NetworkCalls.dart';
import 'package:flyx/Pages/Schema/AutocompleteSchema.dart';

class AutoComplete extends SearchDelegate<List<Suggestions>> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      query.isEmpty
          ? IconButton(
              tooltip: 'Voice Search',
              icon: const Icon(Icons.mic),
              onPressed: () {
                query = 'TODO: implement voice input';
              },
            )
          : IconButton(
              tooltip: 'Clear',
              icon: const Icon(Icons.clear),
              onPressed: () {
                query = '';
                showSuggestions(context);
              },
            ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    dynamic _closeSearchPage() {
      close(context, null);
    }

    return _closeSearchPage();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    bool isSelected = false;

    return FutureBuilder<List<Suggestions>>(
      future: pingHeroku(query),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            child: ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Icon(Icons.local_airport),
                  isThreeLine: true,
                  title: Text(
                      '${snapshot.data[index].source.iata} - ${snapshot.data[index].source.name}'),
                  subtitle: Text(
                      '${snapshot.data[index].source.city}, ${snapshot.data[index].source.country}'),
                  dense: false,
                  enabled: true,
                  selected: isSelected,
                  onTap: () {
                    if (isOrigin == true) {
                      originQuery = snapshot.data[index].source.iata;

                      originLat = snapshot.data[index].source.latitude;

                      originLong = snapshot.data[index].source.longitude;
                    }
                    if (isOrigin == false) {
                      destinationQuery = snapshot.data[index].source.iata;
                      destinationLat = snapshot.data[index].source.latitude;
                      destinationLong = snapshot.data[index].source.longitude;
                    }

                    Navigator.pop(context);
                  },
                  trailing: Icon(Icons.location_on),
                );
              },
            ),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return LinearProgressIndicator();
      },
    );
  }
}
