import 'package:flutter/material.dart';

/// Displays detailed information about a SampleItem.
class PlayerDetailsView extends StatelessWidget {
  const PlayerDetailsView({super.key});

  static const routeName = '/player';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
      ),
      body: const Center(
        child: Text('More Information Here'),
      ),
    );
  }
}
