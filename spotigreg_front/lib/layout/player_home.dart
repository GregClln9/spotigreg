import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotigreg_front/components/player/elevate_button.dart';
import 'package:spotigreg_front/components/player/next_song_button.dart';
import 'package:spotigreg_front/components/player/play_button.dart';
import 'package:spotigreg_front/components/player/previous_song_button.dart';
import 'package:spotigreg_front/components/player/progress_bar.dart';
import 'package:spotigreg_front/components/player/repeat_button.dart';

class PlayerHome extends ConsumerWidget {
  const PlayerHome({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double mHeight = MediaQuery.of(context).size.height;

    return Container(
        color: Colors.transparent,
        height: mHeight * 0.15,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const MyProgressBar(),
            GestureDetector(
              onTap: () {
                navigateToLyrics(context);
              },
              onVerticalDragStart: (e) {
                navigateToLyrics(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  // ShuffleButton(),
                  ElevateButton(),
                  PreviousSongButton(),
                  PlayButton(),
                  NextSongButton(),
                  RepeatButton()
                ],
              ),
            )
          ],
        ));
  }
}
