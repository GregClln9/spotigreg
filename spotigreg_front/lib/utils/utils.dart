import 'package:flutter/material.dart';
import '../themes/colors.dart';

// Duration parseDuration(String s) {
//   int hours = 0;
//   int minutes = 0;
//   int micros;
//   List<String> parts = s.split(':');
//   if (parts.length > 2) {
//     hours = int.parse(parts[parts.length - 3]);
//   }
//   if (parts.length > 1) {
//     minutes = int.parse(parts[parts.length - 2]);
//   }
//   micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
//   return Duration(hours: hours, minutes: minutes, microseconds: micros);
// }

enum SnackBarState {
  error,
  success,
  info,
}

showSnackBar(BuildContext context, String text, SnackBarState snackBarState) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 2),
      elevation: 15,
      backgroundColor: snackBarState == SnackBarState.error
          ? redDiss
          : snackBarState == SnackBarState.success
              ? primaryColor
              : snackBarState == SnackBarState.info
                  ? Colors.white
                  : primaryColor,
      behavior: SnackBarBehavior.floating,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(text,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  color: snackBarState == SnackBarState.info
                      ? Colors.black
                      : Colors.white,
                )),
          ),
        ],
      ),
    ),
  );
}
