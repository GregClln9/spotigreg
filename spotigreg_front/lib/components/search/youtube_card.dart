import 'package:flutter/material.dart';

class YoutubeCard extends StatefulWidget {
  const YoutubeCard(
      {Key? key,
      required this.author,
      required this.thumbnails,
      required this.title})
      : super(key: key);
  final dynamic thumbnails;
  final dynamic author;
  final dynamic title;

  @override
  State<YoutubeCard> createState() => _YoutubeCardState();
}

class _YoutubeCardState extends State<YoutubeCard> {
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
          padding: const EdgeInsets.fromLTRB(5, 10, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.author,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
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
