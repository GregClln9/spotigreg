import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spotigreg_front/components/player/next_song_button.dart';
import 'package:spotigreg_front/components/player/orientation_button.dart';
import 'package:spotigreg_front/components/player/play_button.dart';
import 'package:spotigreg_front/components/player/previous_song_button.dart';
import 'package:spotigreg_front/components/player/progress_bar.dart';
import 'package:spotigreg_front/components/player/repeat_button.dart';
import 'package:spotigreg_front/components/player/shuffle_button.dart';
import 'package:spotigreg_front/components/player/speed_button.dart';

class PlayerTrackScreen extends ConsumerWidget {
  const PlayerTrackScreen({Key? key, required this.title, required this.artist})
      : super(key: key);
  final String title;
  final String artist;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: IconButton(
          iconSize: 40,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          onPressed: () {},
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: const [Padding(padding: EdgeInsets.only(right: 30))],
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60),
          child: Text(title,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.headline5),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headline4,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 25),
              child: Text(
                artist,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headline6,
                maxLines: 1,
              ),
            ),
            const MyProgressBar(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  ShuffleButton(),
                  PreviousSongButton(),
                  PlayButton(),
                  NextSongButton(),
                  RepeatButton()
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "SpotiGreg.",
                  style: GoogleFonts.raleway(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: const [
                    SpeedButton(),
                    SizedBox(width: 25),
                    OrientationButton(),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
