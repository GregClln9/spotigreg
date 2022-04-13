import 'package:flutter/material.dart';

// ignore: must_be_immutable
class YoutubeResults extends StatefulWidget {
  YoutubeResults(
      {Key? key,
      required this.author,
      required this.thumbnails,
      required this.title})
      : super(key: key);
  dynamic thumbnails;
  dynamic author;
  dynamic title;

  @override
  State<YoutubeResults> createState() => _YoutubeResultsState();
}

class _YoutubeResultsState extends State<YoutubeResults> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 1.9,
          child: Image.network(
            widget.thumbnails,
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(1, 5, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.author,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                widget.title,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        )
      ],
    );
  }
}
