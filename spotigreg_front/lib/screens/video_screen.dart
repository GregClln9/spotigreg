import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotigreg_front/audio_service/page_manager.dart';
import 'package:spotigreg_front/layout/player.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends ConsumerStatefulWidget {
  const VideoScreen({Key? key}) : super(key: key);

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends ConsumerState<VideoScreen> {
  @override
  void initState() {
    controller.play();
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    return Scaffold(
        bottomNavigationBar: const Player(false),

        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: Colors.black.withOpacity(0.5),
        //   foregroundColor: Colors.green,
        //   child: const PlayButton(),
        //   onPressed: () {},
        // ),
        extendBody: true,
        body: ValueListenableBuilder(
            valueListenable: controller,
            builder: (__, VideoPlayerValue value, _) {
              if (value.isInitialized) {
                return Container(
                  width: size.width,
                  height: size.height,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                  ),
                  child: VideoPlayer(controller),
                );
              } else {
                return const CircularProgressIndicator.adaptive();
              }
            }));
  }
}
