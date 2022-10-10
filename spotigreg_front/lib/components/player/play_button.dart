import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotigreg_front/audio_service/page_manager.dart';
import 'package:spotigreg_front/notifiers/play_button_notifier.dart';

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
