import 'package:flutter/material.dart';
import 'package:spotigreg_front/utils/tracks_utils.dart';

// ignore: must_be_immutable
class DownloadModalBottom extends StatefulWidget {
  DownloadModalBottom(
      {Key? key,
      required this.id,
      required this.title,
      required this.artiste,
      required this.cover,
      this.duration,
      required this.url})
      : super(key: key);
  String id;
  String title;
  String artiste;
  String? duration;
  String? url;
  String cover;

  @override
  State<DownloadModalBottom> createState() => _DownloadModalBottomState();
}

class _DownloadModalBottomState extends State<DownloadModalBottom> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
            onPressed: (() {
              TracksUtils.addTrack(
                  widget.id,
                  widget.title,
                  widget.artiste,
                  widget.duration.toString(),
                  widget.cover,
                  widget.url.toString());
              setState(() {});
            }),
            icon: const Icon(Icons.download))
      ],
    );
  }
}
