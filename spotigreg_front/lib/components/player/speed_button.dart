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
              menuMaxHeight: 250,
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
                  case "x0v5":
                    pageManager.speed(SpeedState.x0v5);
                    break;
                  case "x0v25":
                    pageManager.speed(SpeedState.x0v25);
                    break;
                  case "x0v75":
                    pageManager.speed(SpeedState.x0v75);
                    break;
                  case "x1v25":
                    pageManager.speed(SpeedState.x1v25);
                    break;
                  case "x1v5":
                    pageManager.speed(SpeedState.x1v5);
                    break;
                  case "x1v75":
                    pageManager.speed(SpeedState.x1v75);
                    break;

                  default:
                    pageManager.speed(SpeedState.x1);
                    break;
                }
              });
        });
  }
}
