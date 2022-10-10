import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:spotigreg_front/audio_service/video_handler.dart';
import 'package:video_player/video_player.dart';

class TrackView extends StatelessWidget {
  const TrackView({
    Key? key,
    required this.animation,
  }) : super(key: key);

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final trackBox = SizedBox(
      width: size.width,
      height: size.height,
      child: FutureBuilder(
          future: initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if ((snapshot.connectionState == ConnectionState.none)) {
              return const CircularProgressIndicator.adaptive();
            } else {
              return ValueListenableBuilder(
                  valueListenable: videoController,
                  builder: (__, VideoPlayerValue value, _) {
                    return SizedBox(
                        child: (value.isBuffering)
                            ? const SizedBox(
                                child: CircularProgressIndicator.adaptive())
                            : (value.isInitialized)
                                ?
                                //  value.aspectRatio,
                                FittedBox(
                                    fit: BoxFit.none,
                                    child: SizedBox(
                                        width: size.width,
                                        height: size.height,
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            Opacity(
                                                opacity: 0.15,
                                                child: VideoPlayer(
                                                    videoController)),
                                            ClipRRect(
                                              child: BackdropFilter(
                                                filter: ImageFilter.blur(
                                                    sigmaX: 80, sigmaY: 80),
                                                child: Container(
                                                  color: Colors.grey
                                                      .withOpacity(0.1),
                                                  alignment: Alignment.center,
                                                  child: const Text('TEST'),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )))
                                : const SizedBox(
                                    child: Text("No inizialized"),
                                  ));
                  });
            }
          }),
    );
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          AnimatedBuilder(
              animation: animation,
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: const Text("Title"),
              ),
              builder: (context, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                          begin: const Offset(0, -1), end: const Offset(0, 0))
                      .animate(animation),
                  child: child,
                );
              }),
          Expanded(
            child: AnimatedBuilder(
                animation: animation,
                child: Hero(
                  tag: "Lyrics",
                  flightShuttleBuilder: ((flightContext, animation,
                      flightDirection, fromHeroContext, toHeroContext) {
                    return FadeTransition(opacity: animation, child: trackBox);
                  }),
                  child: trackBox,
                ),
                builder: (context, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                }),
          ),
          AnimatedBuilder(
              animation: animation,
              child: Container(
                  height: 120, color: const Color.fromRGBO(244, 67, 54, 1)),
              builder: (context, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                          begin: const Offset(0, 1), end: const Offset(0, 0))
                      .animate(animation),
                  child: child,
                );
              })
        ],
      ),
    );
  }
}
