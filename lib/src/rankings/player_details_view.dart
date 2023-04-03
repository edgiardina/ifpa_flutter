import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ifpa_flutter/src/rankings/player.dart';
import 'package:http/http.dart' as http;
import '../app_settings.dart';

/// Displays detailed information about a SampleItem.
class PlayerDetailsView extends StatefulWidget {
  const PlayerDetailsView({super.key});

  static const routeName = '/player';

  @override
  State<PlayerDetailsView> createState() => _PlayerDetailsViewState();
}

class _PlayerDetailsViewState extends State<PlayerDetailsView> {
  dynamic data = {};
  String appBarTitleText = "";
  String playerImage = "";

  Future<void> loadData(int playerId) async {
    final Uri dataURL = Uri(
      scheme: 'https',
      host: 'api.ifpapinball.com',
      path: 'v2/player/' + playerId.toString(),
      queryParameters: {'api_key': ifpaApiKey},
    );
    final http.Response response = await http.get(dataURL);
    setState(() {
      var jsonObj = jsonDecode(response.body);
      data = jsonObj["player"][0];
      appBarTitleText = "${data["first_name"]} ${data["last_name"]}";
      playerImage = data["profile_photo"] ??
          "https://www.ifpapinball.com/images/noplayerpic.png";
    });
  }

  @override
  Widget build(BuildContext context) {
    Player player = ModalRoute.of(context)!.settings.arguments as Player;
    loadData(player.playerId);
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitleText),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CircleAvatar(
                // Display the Flutter Logo image asset.
                foregroundImage: NetworkImage(playerImage),
              ),
              Text(appBarTitleText),
              Text(data["player_id"])
            ],
          ),
          ButtonBar(
            mainAxisSize: MainAxisSize
                .min, // this will take space as minimum as posible(to center)
            children: <Widget>[
              ElevatedButton(
                onPressed: () {},
                child: Text('Tournament Results'),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text('Player Vs Player'),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text('Championship Series'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
