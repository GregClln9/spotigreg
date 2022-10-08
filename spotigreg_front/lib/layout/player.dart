import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotigreg_front/audio_service/page_manager.dart';
import 'package:spotigreg_front/notifiers/play_button_notifier.dart';
import 'package:spotigreg_front/notifiers/progress_notifier.dart';
import 'package:spotigreg_front/notifiers/repeat_button_notifier.dart';
import 'package:spotigreg_front/themes/colors.dart';

class Player extends ConsumerStatefulWidget {
  const Player({Key? key}) : super(key: key);

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends ConsumerState<Player> {
  @override
  Widget build(BuildContext context) {
    double mHeight = MediaQuery.of(context).size.height;
    final pageManager = ref.read(pageManagerProvider);
    return SizedBox(
        height: mHeight * 0.15,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 0.5,
              child: ValueListenableBuilder<ProgressBarState>(
                valueListenable: pageManager.progressNotifier,
                builder: (_, value, __) {
                  return ProgressBar(
                      thumbRadius: 6.0,
                      thumbGlowRadius: 20.0,
                      thumbColor: Colors.white,
                      progressBarColor: Colors.white,
                      bufferedBarColor: primaryColor.withOpacity(0.5),
                      baseBarColor: secondaryText,
                      progress: value.current,
                      buffered: value.buffered,
                      total: value.total,
                      onSeek: pageManager.seek,
                      timeLabelTextStyle: TextStyle(color: secondaryText));
                },
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  ShuffleButton(),
                  PreviousSongButton(),
                  PlayButton(),
                  NextSongButton(),
                  RepeatButton()
                ],
              ),
            )
          ],
        ));
  }
}

class RepeatButton extends ConsumerWidget {
  const RepeatButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageManager = ref.read(pageManagerProvider);
    return ValueListenableBuilder<RepeatState>(
      valueListenable: pageManager.repeatButtonNotifier,
      builder: (context, value, child) {
        Icon icon;
        switch (value) {
          case RepeatState.repeatPlaylist:
            icon = const Icon(Icons.repeat);
            break;
          case RepeatState.off:
            icon = const Icon(Icons.repeat, color: Colors.grey);
            break;
          case RepeatState.repeatSong:
            icon = const Icon(Icons.repeat_one);
            break;
        }
        return IconButton(
          icon: icon,
          onPressed: pageManager.repeat,
        );
      },
    );
  }
}

class PreviousSongButton extends ConsumerWidget {
  const PreviousSongButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageManager = ref.read(pageManagerProvider);
    return IconButton(
        iconSize: 45,
        onPressed: pageManager.previous,
        icon: const Icon(Icons.skip_previous_rounded));
  }
}

class PlayButton extends ConsumerWidget {
  const PlayButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageManager = ref.read(pageManagerProvider);
    return ValueListenableBuilder<ButtonState>(
      valueListenable: pageManager.playButtonNotifier,
      builder: (_, value, __) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: GestureDetector(
            onTap: (() {
              switch (value) {
                case ButtonState.paused:
                  pageManager.play();
                  break;
                case ButtonState.playing:
                  pageManager.pause();
                  break;
                case ButtonState.loading:
                  break;
              }
            }),
            child: Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.white,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(50))),
              child: Center(
                  child: Icon(
                (value == ButtonState.playing)
                    ? Icons.pause
                    : Icons.play_arrow_rounded,
                size: 45,
                color: const Color.fromARGB(255, 48, 48, 48),
              )),
            ),
          ),
        );
      },
    );
  }
}

class NextSongButton extends ConsumerWidget {
  const NextSongButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageManager = ref.read(pageManagerProvider);
    return IconButton(
        iconSize: 45,
        onPressed: pageManager.next,
        icon: const Icon(
          Icons.skip_next_rounded,
        ));
  }
}

class ShuffleButton extends ConsumerWidget {
  const ShuffleButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageManager = ref.read(pageManagerProvider);
    return ValueListenableBuilder<bool>(
      valueListenable: pageManager.isShuffleModeEnabledNotifier,
      builder: (context, isEnabled, child) {
        return IconButton(
          icon: (isEnabled)
              ? const Icon(Icons.shuffle)
              : const Icon(Icons.shuffle, color: Colors.grey),
          onPressed: pageManager.shuffle,
        );
      },
    );
  }
}
