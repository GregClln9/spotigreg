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
  // final _audioPlayer = AudioPlayer();

  // @override
  // void dispose() {
  //   _audioPlayer.dispose();
  //   super.dispose();
  // }

  // Widget _playerButton(PlayerState playerState) {
  //   // 1
  //   final processingState = playerState.processingState;
  //   if (processingState == ProcessingState.loading ||
  //       processingState == ProcessingState.buffering) {
  //     // 2
  //     return Container(
  //       margin: const EdgeInsets.all(8.0),
  //       width: 2.0,
  //       height: 2.0,
  //       child: const CircularProgressIndicator(),
  //     );
  //   } else if (_audioPlayer.playing != true) {
  //     return IconButton(
  //       icon: const Icon(Icons.play_arrow),
  //       iconSize: 20.0,
  //       onPressed: _audioPlayer.play,
  //     );
  //   } else if (processingState != ProcessingState.completed) {
  //     // 4
  //     return IconButton(
  //       icon: const Icon(Icons.pause),
  //       iconSize: 20.0,
  //       onPressed: _audioPlayer.pause,
  //     );
  //   } else {
  //     // 5
  //     return IconButton(
  //       icon: const Icon(Icons.replay),
  //       iconSize: 1.0,
  //       onPressed: () => _audioPlayer.seek(Duration.zero,
  //           index: _audioPlayer.effectiveIndices?.first),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final playerProvider = Provider.of<PlayerProvider>(context, listen: false);
    final musicProvider = Provider.of<MusicProvider>(context, listen: false);
    double mHeight = MediaQuery.of(context).size.height;

    return Container(
        color: Colors.blueGrey,
        height: mHeight * 0.1,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 30, 0),
          child: Row(
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
                      IconButton(
                          onPressed: (() {
                            musicProvider.musicRepeat();
                            setState(() {});
                          }),
                          icon:
                              musicProvider.audioPlayer.loopMode == LoopMode.one
                                  ? const Icon(Icons.repeat_one)
                                  : const Icon(Icons.repeat)),
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
                    ],
                  );
                },
              ),
            ],
          ),
        ));
  }
}
