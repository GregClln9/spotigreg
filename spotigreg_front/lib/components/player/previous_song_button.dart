import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotigreg_front/audio_service/page_manager.dart';

class PreviousSongButton extends ConsumerWidget {
  const PreviousSongButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageManager = ref.read(pageManagerProvider);
    return GestureDetector(
      onTap: (() {
        pageManager.seek(const Duration(seconds: 0));
      }),
      onDoubleTap: pageManager.previous,
      child: const Icon(Icons.skip_previous_rounded, size: 45),
    );
  }
}
