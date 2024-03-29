import 'package:video_player/video_player.dart';
import 'dart:io' show Platform;

// final videoHandlerProvider = Provider((ref) => VideoHandler());
late VideoPlayerController videoController;
late Future<void> initializeVideoPlayerFuture;

class VideoHandler {
  Future<bool> initVideoController(String url, bool initState) async {
    if (!initState) await videoController.dispose();
    videoController = VideoPlayerController.network(url,
        videoPlayerOptions: VideoPlayerOptions(
            mixWithOthers: Platform.isAndroid ? true : false,
            allowBackgroundPlayback: Platform.isAndroid ? true : false));
    initializeVideoPlayerFuture = videoController.initialize();
    await videoController.setVolume(0);
    return true;
  }

  void play() async {
    await videoController.play();
  }

  void pause() {
    videoController.pause();
  }

  void speed(double speed) {
    videoController.setPlaybackSpeed(speed);
  }

  void dispose() {
    videoController.dispose();
  }

  void seekTo(Duration position) {
    videoController.seekTo(position);
  }
}
