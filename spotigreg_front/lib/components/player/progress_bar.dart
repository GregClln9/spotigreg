import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotigreg_front/audio_service/page_manager.dart';
import 'package:spotigreg_front/notifiers/progress_notifier.dart';
import 'package:spotigreg_front/themes/colors.dart';

class MyProgressBar extends ConsumerWidget {
  const MyProgressBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageManager = ref.read(pageManagerProvider);
    return ValueListenableBuilder<ProgressBarState>(
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
    );
  }
}
