import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotigreg_front/audio_service/page_manager.dart';
import 'package:spotigreg_front/audio_service/video_handler.dart';
import 'package:spotigreg_front/layout/player_track_view.dart';
import 'package:video_player/video_player.dart';

class TrackView extends ConsumerStatefulWidget {
  const TrackView({Key? key, required this.animation}) : super(key: key);
  final Animation<double> animation;

  @override
  _TrackViewState createState() => _TrackViewState();
}

String currentTitle = "";
bool touch = false;

class _TrackViewState extends ConsumerState<TrackView> {
  @override
  Widget build(BuildContext context) {
    final pageManager = ref.read(pageManagerProvider);

    final trackBox = FutureBuilder(
        future: initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if ((snapshot.connectionState == ConnectionState.none)) {
            return const CircularProgressIndicator.adaptive();
          } else {
            return ValueListenableBuilder<String>(
                valueListenable: pageManager.currentSongTitleNotifier,
                builder: (_, title, __) {
                  if (currentTitle != title) {
                    currentTitle = title;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {});
                    });
                  }
                  return ValueListenableBuilder(
                      valueListenable: videoController,
                      builder: (__, VideoPlayerValue value, _) {
                        return (value.isBuffering)
                            ? const StackTrackView(
                                child: Center(
                                    child:
                                        CircularProgressIndicator.adaptive()),
                              )
                            : (value.isInitialized)
                                ? StackTrackView(
                                    child: VideoPlayer(videoController),
                                  )
                                : const StackTrackView(
                                    child: Center(
                                        child: CircularProgressIndicator
                                            .adaptive()),
                                  );
                      });
                });
          }
        });

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: AnimatedBuilder(
          animation: widget.animation,
          child: Hero(
            tag: "Lyrics",
            flightShuttleBuilder: ((flightContext, animation, flightDirection,
                fromHeroContext, toHeroContext) {
              return FadeTransition(opacity: animation, child: trackBox);
            }),
            child: GestureDetector(
                onVerticalDragStart: (details) {
                  Navigator.pop(context);
                },
                onTap: () => touch = !touch,
                child: trackBox),
          ),
          builder: (context, child) {
            return FadeTransition(
              opacity: widget.animation,
              child: child,
            );
          }),
    );
  }
}

class StackTrackView extends StatelessWidget {
  const StackTrackView({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Opacity(opacity: touch ? 0.30 : 0.15, child: child),
        ClipRRect(
          child: BackdropFilter(
              filter: ImageFilter.blur(
                  tileMode: TileMode.mirror, sigmaY: 5, sigmaX: 30),
              child: !touch
                  ? PlayerTrackView(
                      title: currentTitle,
                    )
                  : const SizedBox()),
        ),
      ],
    );
  }
}
