import 'package:flutter/material.dart';
import 'package:spotigreg_front/utils/tracks_utils.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Settings'),
            InkWell(
              child: const Text("Delete All Tracks"),
              onDoubleTap: () {
                setState(() {
                  TracksUtils.deleteAllTracks();
                });
              },
            )
          ],
        ),
      ),
    ));
  }
}
