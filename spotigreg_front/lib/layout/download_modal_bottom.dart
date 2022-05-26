import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spotigreg_front/storage/boxes.dart';
import 'package:spotigreg_front/themes/colors.dart';
import 'package:spotigreg_front/utils/tracks_utils.dart';
import '../storage/tracks_hive.dart';

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
    double mHeight = MediaQuery.of(context).size.height;
    Box<TracksHive> box = Boxes.getTracks();
    bool alreadyDownload = false;
    return SizedBox(
      height: mHeight * 0.1,
      child: Center(
        child: IconButton(
            onPressed: (() {
              for (var i = 0; i < box.length; i++) {
                if (box.get(i)?.id == widget.id) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: secondaryText,
                    content: const Text('Already download !'),
                  ));
                  alreadyDownload = true;
                }
              }
              if (!alreadyDownload) {
                TracksUtils.addTrack(
                    widget.id,
                    widget.title,
                    widget.artiste,
                    widget.duration.toString(),
                    widget.cover,
                    widget.url.toString());
                setState(() {});
              }
            }),
            icon: Icon(Icons.download, color: primaryColor)),
      ),
    );
  }
}
