import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotigreg_front/audio_service/page_manager.dart';
import 'package:spotigreg_front/audio_service/video_handler.dart';
import 'package:spotigreg_front/components/player/next_song_button.dart';
import 'package:spotigreg_front/components/player/play_button.dart';
import 'package:spotigreg_front/components/player/previous_song_button.dart';
import 'package:spotigreg_front/components/player/progress_bar.dart';
import 'package:spotigreg_front/components/player/repeat_button.dart';
import 'package:spotigreg_front/components/player/shuffle_button.dart';
import 'package:spotigreg_front/models/track_model.dart';
import 'package:video_player/video_player.dart';

class PlayerHome extends StatelessWidget {
  const PlayerHome({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Stack(
      fit: StackFit.expand,
      children: [
        VideoPlayerHome(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyProgressBar(),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
        )
      ],
    );
  }
}

String currentTitle = "";

class VideoPlayerHome extends ConsumerStatefulWidget {
  const VideoPlayerHome({Key? key}) : super(key: key);

  @override
  _VideoPlayerHomeState createState() => _VideoPlayerHomeState();
}

class _VideoPlayerHomeState extends ConsumerState<VideoPlayerHome> {
  @override
  Widget build(BuildContext context) {
    final pageManager = ref.read(pageManagerProvider);
    return FutureBuilder(
        future: initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if ((snapshot.connectionState == ConnectionState.none)) {
            return const CircularProgressIndicator.adaptive();
          } else {
            return ValueListenableBuilder<TrackModel>(
                valueListenable: pageManager.currentSongNotifier,
                builder: (_, currentTrack, __) {
                  if (currentTitle != currentTrack.title) {
                    currentTitle = currentTrack.title;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {});
                    });
                  }
                  return ValueListenableBuilder(
                      valueListenable: videoController,
                      builder: (__, VideoPlayerValue value, _) {
                        return (value.isBuffering)
                            ? const SizedBox()
                            : (value.isInitialized)
                                ? Opacity(
                                    opacity: 0.08,
                                    child: Container(
                                      color: Colors.black,
                                      child: AspectRatio(
                                          aspectRatio: value.aspectRatio,
                                          child: VideoPlayer(videoController)),
                                    ),
                                  )
                                : const SizedBox();
                      });
                });
          }
        });
  }
}
