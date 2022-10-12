import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:spotigreg_front/audio_service/page_manager.dart';
import 'package:spotigreg_front/components/home/track_card.dart';
import 'package:spotigreg_front/models/track_model.dart';
import 'package:spotigreg_front/themes/colors.dart';
import 'package:spotigreg_front/utils/tracks_utils.dart';

class Tracklist extends ConsumerWidget {
  const Tracklist({Key? key, required this.callback}) : super(key: key);
  final VoidCallback callback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    deleteTrack(int index, int indexFake) {
      final pageManager = ref.read(pageManagerProvider);
      pageManager.remove(index);
      TracksUtils.deleteTrack(box.getAt(indexFake)!.id.toString(), context);
      callback();
    }

    clickTrack(int index) {
      final pageManager = ref.read(pageManagerProvider);
      pageManager.playFromSong(index);
      callback();
    }

    watchTrack(int index, int indexFake, String currentTitle) {
      if (!(currentTitle == box.getAt(indexFake)!.title.toString())) {
        final pageManager = ref.read(pageManagerProvider);
        pageManager.playFromSong(index);
      }
      // Navigator.push(context,
      //         MaterialPageRoute(builder: (context) => const VideoScreen()))
      //     .then((value) => callback());
    }

    return box.length > 0
        ? ListView.builder(
            itemCount: box.length,
            itemBuilder: ((context, index) {
              // set index for MoreRecent track first
              int indexFake = index;
              final pageManager = ref.read(pageManagerProvider);
              if (pageManager.sortByMoreRecent) {
                indexFake = box.length - index - 1;
              } else {
                index = box.length - index - 1;
              }
              return InkWell(
                onTap: (() {
                  clickTrack(index);
                }),
                child: ValueListenableBuilder<TrackModel>(
                    valueListenable: pageManager.currentSongNotifier,
                    builder: (_, currentTrack, __) {
                      return Slidable(
                        key: UniqueKey(),
                        // startActionPane: ActionPane(
                        //   extentRatio: 0.3,
                        //   motion: const ScrollMotion(),
                        //   children: [
                        //     SlidableAction(
                        //       onPressed: ((context) => watchTrack(
                        //           index, indexFake, currentTrack.title)),
                        //       backgroundColor: greyDark,
                        //       foregroundColor: secondaryText,
                        //       icon: Icons.play_arrow_rounded,
                        //     ),
                        //   ],
                        // ),
                        endActionPane: ActionPane(
                          extentRatio: 0.2,
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: ((context) =>
                                  deleteTrack(index, indexFake)),
                              backgroundColor: redDiss,
                              foregroundColor: Colors.white,
                              icon: Icons.delete_outline_rounded,
                            ),
                          ],
                        ),
                        child: TrackCard(
                          callback: (() {
                            callback();
                          }),
                          cover: box.getAt(indexFake)!.cover.toString(),
                          artiste: box.getAt(indexFake)!.artiste.toString(),
                          title: box.getAt(indexFake)!.title.toString(),
                        ),
                      );
                    }),
              );
            }))
        : Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: Center(
              child: Text(
                "Aucun titre sauvargdé, cliquez sur + pour en ajouter.",
                style: TextStyle(color: secondaryText),
                textAlign: TextAlign.center,
              ),
            ),
          );
  }
}
