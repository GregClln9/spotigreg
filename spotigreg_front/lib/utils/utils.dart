import 'package:flutter/material.dart';
import '../themes/colors.dart';

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
