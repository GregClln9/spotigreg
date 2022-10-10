import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotigreg_front/audio_service/page_manager.dart';

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
