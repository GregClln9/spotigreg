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
        appBar: AppBar(title: const Text('Préférences')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: InkWell(
                    child: const Text(
                      "Double tap for delete all Tracks",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      setState(() {
                        TracksUtils.deleteAllTracks();
                      });
                    },
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
