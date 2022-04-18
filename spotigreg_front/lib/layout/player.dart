import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:spotigreg_front/provider/music_provider.dart';
import 'package:spotigreg_front/themes/colors.dart';

class Player extends StatefulWidget {
  const Player({Key? key}) : super(key: key);

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final musicProvider = Provider.of<MusicProvider>(context, listen: false);
    double mWidth = MediaQuery.of(context).size.width;
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

    return SizedBox(
        height: mHeight * 0.1,
        child: Column(
          children: [
            ValueListenableBuilder<DurationState>(
              valueListenable: musicProvider.progressNotifier,
              builder: (_, value, __) {
                return ProgressBar(
                  thumbRadius: 6.0,
                  thumbGlowRadius: 20.0,
                  thumbColor: Colors.white,
                  progressBarColor: Colors.white,
                  bufferedBarColor: primaryColor.withOpacity(0.5),
                  baseBarColor: secondaryText,
                  progress: value.progress,
                  buffered: value.buffered,
                  total: value.total,
                  onSeek: musicProvider.seek,
                );
              },
            ),
            StreamBuilder<PlayerState>(
              stream: musicProvider.audioPlayer.playerStateStream,
              builder: (context, snapshot) {
                final playerState = snapshot.data;
                final processingState = playerState?.processingState;
                // if (processingState == ProcessingState.completed) {
                //   wait2sec();
                //   setState(() {});
                // }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: (() {}),
                        icon: Icon(
                          Icons.favorite_border_rounded,
                          color: secondaryText,
                        )),
                    // Previous Track
                    IconButton(
                        onPressed: (() {
                          musicProvider.sortByMoreRecent
                              ? musicProvider.nextTrack()
                              : musicProvider.previousTrack();
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
                        }),
                        icon: !musicProvider.audioPlayer.playing ||
                                processingState == ProcessingState.completed
                            ? const Icon(
                                Icons.play_circle_outline_rounded,
                                size: 40,
                              )
                            : const Icon(Icons.pause_circle_outline_rounded,
                                size: 40)),
                    // Next Track
                    IconButton(
                        onPressed: (() {
                          musicProvider.sortByMoreRecent
                              ? musicProvider.previousTrack()
                              : musicProvider.nextTrack();
                          setState(() {});
                        }),
                        icon: const Icon(Icons.arrow_right_rounded)),
                    // Repeat
                    IconButton(
                        onPressed: (() {
                          musicProvider.musicRepeat();
                          setState(() {});
                        }),
                        icon: musicProvider.audioPlayer.loopMode == LoopMode.one
                            ? Icon(
                                Icons.repeat_one_rounded,
                                color: primaryColor,
                              )
                            : const Icon(Icons.repeat_rounded)),
                  ],
                );
              },
            ),
          ],
        ));
  }
}
