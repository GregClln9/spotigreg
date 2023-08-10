import 'dart:math';
import 'package:flutter/material.dart';
import 'package:spotigreg_front/screens/settings.dart';
import 'package:spotigreg_front/themes/colors.dart';

class TopAppBar extends StatefulWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const TopAppBar({Key? key, required this.scaffoldKey})
      : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  _TopAppBarState createState() => _TopAppBarState();

  @override
  final Size preferredSize;
}

class _TopAppBarState extends State<TopAppBar> {
  List<String> listOfEmoji = [
    "💖",
    "🥺",
    "😳",
    "🤪",
    "😴",
    "😵‍💫",
    "💔",
    "💜",
    "💕",
    "❤️",
    "🌙",
    "💫",
    "🌞",
    "🥀",
    "👋",
    "✌️",
    "🌗",
    "💥",
    "🌊",
    "🔫",
    "💞",
    "🤍",
    "💙",
    "☺️",
    "😔",
    "🙃",
    "😤",
    "🕺",
    "💃",
    "🌈",
    "📀",
    "💿",
  ];
  @override
  Widget build(BuildContext context) {
    final _random = Random();
    return AppBar(
      actions: [
        IconButton(
          icon: Icon(
            Icons.settings,
            color: secondaryText,
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Settings()));
          },
        ),
      ],
      elevation: 0,
      title: Text(
        "SpotiGreg. " + listOfEmoji[_random.nextInt(listOfEmoji.length)],
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      centerTitle: false,
    );
  }
}
