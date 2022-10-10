import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotigreg_front/components/player/next_song_button.dart';
import 'package:spotigreg_front/components/player/play_button.dart';
import 'package:spotigreg_front/components/player/previous_song_button.dart';
import 'package:spotigreg_front/components/player/progress_bar.dart';
import 'package:spotigreg_front/components/player/repeat_button.dart';
import 'package:spotigreg_front/components/player/shuffle_button.dart';
import 'package:spotigreg_front/themes/colors.dart';

class PlayerTrackView extends ConsumerWidget {
  const PlayerTrackView({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double mHeight = MediaQuery.of(context).size.height;

    return Container(
        height: mHeight * 0.5,
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(title),
              Text("Album",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: secondaryText)),
              const MyProgressBar(),
              Row(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  ShuffleButton(),
                  ShuffleButton(),
                  ShuffleButton(),
                ],
              )
            ],
          ),
        ));
  }
}
