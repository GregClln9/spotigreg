import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:spotigreg_front/audio_service/page_manager.dart';
import 'package:spotigreg_front/models/track_model.dart';

class TrackCard extends ConsumerStatefulWidget {
  const TrackCard(
      {Key? key,
      required this.callback,
      required this.cover,
      required this.artiste,
      required this.title})
      : super(key: key);
  final String cover;
  final String artiste;
  final String title;
  final VoidCallback callback;

  @override
  _TrackCardState createState() => _TrackCardState();
}

String currentTitle = "";

class _TrackCardState extends ConsumerState<TrackCard> {
  @override
  Widget build(BuildContext context) {
    final pageManager = ref.read(pageManagerProvider);
    bool currentStream = false;

    double mWidth = MediaQuery.of(context).size.width;

    return ValueListenableBuilder<TrackModel>(
        valueListenable: pageManager.currentSongNotifier,
        builder: (_, currentTrack, __) {
          if (currentTrack.title == widget.title) {
            currentStream = true;
          }
          if (currentTitle != currentTrack.title) {
            currentTitle = currentTrack.title;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              widget.callback();
            });
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
                            ? Theme.of(context).textTheme.headline3
                            : Theme.of(context).textTheme.headline1,
                      ),
                      Text(widget.artiste,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headline2)
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
        });
  }
}
