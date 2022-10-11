import 'package:flutter/material.dart';
import 'package:spotigreg_front/components/player/next_song_button.dart';
import 'package:spotigreg_front/components/player/play_button.dart';
import 'package:spotigreg_front/components/player/previous_song_button.dart';
import 'package:spotigreg_front/components/player/progress_bar.dart';
import 'package:spotigreg_front/components/player/repeat_button.dart';
import 'package:spotigreg_front/components/player/shuffle_button.dart';

class PlayerHome extends StatelessWidget {
  const PlayerHome({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const MyProgressBar(),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              ShuffleButton(),
              // ElevateButton(),
              PreviousSongButton(),
              PlayButton(),
              NextSongButton(),
              RepeatButton()
            ],
          ),
        )
      ],
    );
  }
}
