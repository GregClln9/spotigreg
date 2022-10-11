import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

bool deviceLandscape = false;

class OrientationButton extends StatelessWidget {
  const OrientationButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (() {
        if (!deviceLandscape) {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeLeft,
          ]);
        } else {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ]);
        }
        deviceLandscape = !deviceLandscape;
      }),
      child: const Icon(Icons.screen_rotation_rounded),
    );
  }
}
