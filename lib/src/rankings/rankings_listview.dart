import 'package:flutter/material.dart';

import '../settings/settings_view.dart';
import 'player_details_view.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

/// Displays a list of SampleItems.
class RankingListView extends StatefulWidget {
  static const routeName = '/';

  @override
  _RankingListViewState createState() => _RankingListViewState();
}

class _RankingListViewState extends State<RankingListView> {
  List<dynamic> data = <dynamic>[];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final Uri dataURL = Uri.parse(
      'https://api.ifpapinball.com/v2/rankings/wppr?api_key=',
    );
    final http.Response response = await http.get(dataURL);
    setState(() {
      var jsonObj = jsonDecode(response.body);
      data = jsonObj["rankings"];
    });
  }

  String ordinal(int number) {
    if (!(number >= 1 && number <= 100)) {
      //here you change the range
      throw Exception('Invalid number');
    }

    if (number >= 11 && number <= 13) {
      return 'th';
    }

    switch (number % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rankings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),

      // To work with lists that may contain a large number of items, it’s best
      // to use the ListView.builder constructor.
      //
      // In contrast to the default ListView constructor, which requires
      // building all Widgets up front, the ListView.builder constructor lazily
      // builds Widgets as they’re scrolled into view.
      body: ListView.builder(
        // Providing a restorationId allows the ListView to restore the
        // scroll position when a user leaves and returns to the app after it
        // has been killed while running in the background.
        restorationId: 'rankingItemListView',
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          final item = data[index];

          return ListTile(
              title: Text('${item["first_name"]} ${item["last_name"]}'),
              subtitle: Text(item["country_name"]),
              trailing: Text(
                item["current_rank"] + ordinal(int.parse(item["current_rank"])),
                textScaleFactor: 1.5,
              ),
              leading: CircleAvatar(
                // Display the Flutter Logo image asset.
                foregroundImage: NetworkImage(item["profile_photo"] ??
                    "https://www.ifpapinball.com/images/noplayerpic.png"),
              ),
              onTap: () {
                // Navigate to the details page. If the user leaves and returns to
                // the app after it has been killed while running in the
                // background, the navigation stack is restored.
                Navigator.restorablePushNamed(
                    context, PlayerDetailsView.routeName);
              });
        },
      ),
    );
  }
}
