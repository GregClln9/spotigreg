import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotigreg_front/audio_service/page_manager.dart';
import 'package:spotigreg_front/audio_service/video_handler.dart';
import 'package:spotigreg_front/layout/player_track_screen.dart';
import 'package:spotigreg_front/models/track_model.dart';
import 'package:video_player/video_player.dart';

final GlobalKey<ScaffoldState> _navigatorKey3 = GlobalKey<ScaffoldState>();

class TrackScreen extends ConsumerStatefulWidget {
  const TrackScreen({Key? key, this.animation}) : super(key: key);
  final Animation<double>? animation;

  @override
  _TrackScreenState createState() => _TrackScreenState();
}

String currentTitle = "";
String currentArtist = "";

class _TrackScreenState extends ConsumerState<TrackScreen> {
  @override
  Widget build(BuildContext context) {
    final pageManager = ref.read(pageManagerProvider);
    return Scaffold(
      key: _navigatorKey3,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: FutureBuilder(
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
                      currentArtist = currentTrack.artist;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() {});
                      });
                    }
                    return ValueListenableBuilder(
                        valueListenable: videoController,
                        builder: (__, VideoPlayerValue value, _) {
                          return (value.isBuffering)
                              ? const StackTrackScreen(
                                  childVideo:
                                      CircularProgressIndicator.adaptive(),
                                  childVideoBackground:
                                      CircularProgressIndicator.adaptive(),
                                )
                              : (value.isInitialized)
                                  ? StackTrackScreen(
                                      childVideo: AspectRatio(
                                          aspectRatio: value.aspectRatio,
                                          child: VideoPlayer(videoController)),
                                      childVideoBackground:
                                          VideoPlayer(videoController))
                                  : const StackTrackScreen(
                                      childVideo:
                                          CircularProgressIndicator.adaptive(),
                                      childVideoBackground:
                                          CircularProgressIndicator.adaptive(),
                                    );
                        });
                  });
            }
          }),
    );
  }
}

final touch = ValueNotifier<bool>(false);

class StackTrackScreen extends ConsumerWidget {
  const StackTrackScreen(
      {Key? key, required this.childVideo, required this.childVideoBackground})
      : super(key: key);
  final Widget childVideo;
  final Widget childVideoBackground;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageManager = ref.read(pageManagerProvider);

    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails details) {
        if (details.primaryVelocity! > 0) {
          pageManager.previous();
        } else if (details.primaryVelocity! < 0) {
          pageManager.next();
        }
      },
      onTap: () {
        touch.value = !touch.value;
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          childVideoBackground,
          ClipRRect(
              child: BackdropFilter(
                  filter: ImageFilter.blur(
                    tileMode: TileMode.mirror,
                    sigmaY: 100,
                    sigmaX: 100,
                  ),
                  child: ValueListenableBuilder<bool>(
                      valueListenable: touch,
                      builder: (_, touch, __) {
                        return (!touch)
                            ? Container(
                                color: Colors.black,
                              )
                            : const SizedBox();
                      }))),
          Stack(
            fit: StackFit.loose,
            children: [
              Center(child: childVideo),
              ClipRRect(
                child: ValueListenableBuilder<bool>(
                    valueListenable: touch,
                    builder: (_, touch, __) {
                      return (!touch)
                          ? PlayerTrackScreen(
                              title: currentTitle,
                              artist: currentArtist,
                            )
                          : const SizedBox();
                    }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
