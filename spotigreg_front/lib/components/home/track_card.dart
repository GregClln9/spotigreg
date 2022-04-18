import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:spotigreg_front/provider/music_provider.dart';
import 'package:spotigreg_front/themes/colors.dart';

// ignore: must_be_immutable
class TrackCard extends StatefulWidget {
  TrackCard(
      {Key? key,
      required this.cover,
      required this.artiste,
      required this.title})
      : super(key: key);
  String cover;
  String artiste;
  String title;

  @override
  State<TrackCard> createState() => _TrackCardState();
}

class _TrackCardState extends State<TrackCard> {
  get children => null;

  @override
  Widget build(BuildContext context) {
    double mWidth = MediaQuery.of(context).size.width;
    final musicProvider = Provider.of<MusicProvider>(context, listen: false);
    bool currentStream = false;

    if (musicProvider.currentTitle == widget.title) {
      currentStream = true;
    }
    return SizedBox(
      height: mWidth * 0.12,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(5.0),
                ),
                child: SizedBox(
                  width: mWidth * 0.1,
                  height: mWidth * 0.1,
                  child: Image.network(widget.cover, fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Shimmer.fromColors(
                        period: const Duration(milliseconds: 500),
                        child: Container(
                          width: double.infinity,
                          height: 8.0,
                          color: Colors.white,
                        ),
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!);
                  }, errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: mWidth * 0.1,
                      height: mWidth * 0.1,
                      color: const Color.fromARGB(255, 161, 162, 163),
                    );
                  }),
                )),
          ),
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            width: mWidth * 0.7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  overflow: TextOverflow.ellipsis,
                  style: currentStream
                      ? TextStyle(
                          color: primaryColor, fontWeight: FontWeight.bold)
                      : const TextStyle(color: Colors.white),
                ),
                Text(widget.artiste,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: secondaryText))
              ],
            ),
          ),
          // SizedBox(width: 5,),
          // IconButton(
          //     onPressed: () {},
          //     icon: Icon(
          //       Icons.favorite,
          //       color: primaryColor,
          //     ))
        ],
      ),
    );
  }
}
