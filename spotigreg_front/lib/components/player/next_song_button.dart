import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotigreg_front/audio_service/page_manager.dart';

class NextSongButton extends ConsumerWidget {
  const NextSongButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageManager = ref.read(pageManagerProvider);
    return GestureDetector(
      onTap: pageManager.next,
      child: const Icon(Icons.skip_next_rounded, size: 45),
    );
  }
}
