import 'package:flutter/material.dart';

class YoutubeModalBottom extends StatefulWidget {
  const YoutubeModalBottom({Key? key, required this.function})
      : super(key: key);
  final void Function()? function;

  @override
  State<YoutubeModalBottom> createState() => _YoutubeModalBottomState();
}

class _YoutubeModalBottomState extends State<YoutubeModalBottom> {
  get children => null;

  @override
  Widget build(BuildContext context) {
    double mWidth = MediaQuery.of(context).size.width;
    double mHeight = MediaQuery.of(context).size.height;
    return SizedBox(
        width: mWidth,
        height: mHeight * 0.25,
        child: Column(
          children: [
            const Text("Télécharger la musique"),
            IconButton(
                onPressed: widget.function, icon: const Icon(Icons.download))
          ],
        ));
  }
}
