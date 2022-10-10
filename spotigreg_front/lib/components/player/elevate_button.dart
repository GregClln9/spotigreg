import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotigreg_front/screens/track_view.dart';

class ElevateButton extends ConsumerWidget {
  const ElevateButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      iconSize: 25,
      onPressed: () {
        navigateToLyrics(context);
      },
      icon: const Icon(
        Icons.keyboard_arrow_up_rounded,
      ),
    );
  }
}

void navigateToLyrics(BuildContext context) {
  Navigator.of(context).push(
    PageRouteBuilder(
      transitionDuration: const Duration(microseconds: 300000),
      reverseTransitionDuration: const Duration(microseconds: 300000),
      pageBuilder: (context, animation, secondaryAnimation) {
        return TrackView(
          animation: animation,
        );
      },
      transitionsBuilder: ((context, animation, secondaryAnimation, child) {
        return Opacity(
          opacity: animation.value,
          child: child,
        );
      }),
    ),
  );
}
