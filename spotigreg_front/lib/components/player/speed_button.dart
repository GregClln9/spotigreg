import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotigreg_front/audio_service/page_manager.dart';
import 'package:spotigreg_front/notifiers/speed_button_notifier.dart';
import 'package:spotigreg_front/themes/colors.dart';

class SpeedButton extends ConsumerWidget {
  const SpeedButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageManager = ref.read(pageManagerProvider);
    return ValueListenableBuilder<SpeedState>(
        valueListenable: pageManager.speedButtonNotifier,
        builder: (context, speed, child) {
          List<String> allValue = SpeedButtonNotifier().speedState();

          return DropdownButton(
              dropdownColor: greyDark.withOpacity(0.5),
              value: speed.name.toString(),
              items: allValue.map((String item) {
                return DropdownMenuItem(
                  value: item,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      item,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (changeSpeed) {
                switch (changeSpeed) {
                  case "x1":
                    pageManager.speed(SpeedState.x1);
                    break;
                  case "x2":
                    pageManager.speed(SpeedState.x2);
                    break;
                  case "x3":
                    pageManager.speed(SpeedState.x3);
                    break;
                  default:
                    pageManager.speed(SpeedState.x1);
                    break;
                }
              });
        });

    // return IconButton(
    //     onPressed: () {
    //       print(speed);
    //       // pageManager.speed(speed);
    //     },
    //     icon: const Icon(Icons.speed_rounded));
    // return IconButton(
    //   icon: ()
    //       ? const Icon(Icons.shuffle)
    //       : const Icon(Icons.shuffle, color: Colors.grey),
    //   onPressed: pageManager.shuffle,
    // );
  }
}
