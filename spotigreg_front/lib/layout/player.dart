import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:spotigreg_front/components/home/track_card.dart';
import 'package:spotigreg_front/provider/music_provider.dart';
import 'package:spotigreg_front/provider/player_provider.dart';

class Player extends StatefulWidget {
  const Player({Key? key}) : super(key: key);

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  @override
  Widget build(BuildContext context) {
    final playerProvider = Provider.of<PlayerProvider>(context, listen: false);
    final musicProvider = Provider.of<MusicProvider>(context, listen: false);
    double mHeight = MediaQuery.of(context).size.height;

    musicProvider.audioPlayer.positionStream.listen((position) {
      final oldState = musicProvider.progressNotifier.value;
      musicProvider.progressNotifier.value = DurationState(
        progress: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });

    musicProvider.audioPlayer.bufferedPositionStream.listen((bufferedPosition) {
      final oldState = musicProvider.progressNotifier.value;
      musicProvider.progressNotifier.value = DurationState(
        progress: oldState.progress,
        buffered: bufferedPosition,
        total: oldState.total,
      );
    });

    musicProvider.audioPlayer.durationStream.listen((totalDuration) {
      final oldState = musicProvider.progressNotifier.value;
      musicProvider.progressNotifier.value = DurationState(
        progress: oldState.progress,
        buffered: oldState.buffered,
        total: totalDuration ?? Duration.zero,
      );
    });

    return Container(
        color: Colors.blueGrey,
        height: mHeight * 0.1,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 30, 0),
          child: Column(
            children: [
              ValueListenableBuilder<DurationState>(
                valueListenable: musicProvider.progressNotifier,
                builder: (_, value, __) {
                  return ProgressBar(
                    thumbColor: Colors.black,
                    progressBarColor: Colors.blue,
                    progress: value.progress,
                    buffered: value.buffered,
                    total: value.total,
                    onSeek: musicProvider.seek,
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TrackCard(
                      cover: playerProvider.currentCover,
                      artiste: playerProvider.currentArtiste,
                      title: playerProvider.currentTitle),
                  const SizedBox(width: 5),
                  StreamBuilder<PlayerState>(
                    stream: musicProvider.audioPlayer.playerStateStream,
                    builder: (context, snapshot) {
                      print(musicProvider.audioPlayer.loopMode.toString());
                      print(musicProvider.audioPlayer.playing.toString());
                      return Row(
                        children: [
                          // Repeat
                          IconButton(
                              onPressed: (() {
                                musicProvider.musicRepeat();
                                setState(() {});
                              }),
                              icon: musicProvider.audioPlayer.loopMode ==
                                      LoopMode.one
                                  ? const Icon(Icons.repeat_one)
                                  : const Icon(Icons.repeat)),
                          // Previous Track
                          IconButton(
                              onPressed: (() {
                                musicProvider.previousTrack();
                                setState(() {});
                              }),
                              icon: const Icon(Icons.arrow_left_rounded)),
                          // Play pause
                          IconButton(
                              onPressed: (() {
                                if (musicProvider.audioPlayer.playing) {
                                  musicProvider.musicPause();
                                } else {
                                  musicProvider.musicPlay();
                                }
                                setState(() {});
                              }),
                              icon: musicProvider.audioPlayer.playing
                                  ? const Icon(Icons.pause)
                                  : const Icon(Icons.play_arrow)),
                          // Next Track
                          IconButton(
                              onPressed: (() {
                                musicProvider.nextTrack();
                                setState(() {});
                              }),
                              icon: const Icon(Icons.arrow_right_rounded)),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
