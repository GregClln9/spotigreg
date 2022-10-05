import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:spotigreg_front/components/home/track_card.dart';
import 'package:spotigreg_front/provider/music_provider.dart';
import 'package:spotigreg_front/screens/search.dart';
import 'package:spotigreg_front/utils/tracks_utils.dart';
import '../audio_service/page_manager.dart';
import '../audio_service/service_locator.dart';
import '../layout/player.dart';
import '../layout/topappbar.dart';
import '../storage/boxes.dart';
import '../storage/tracks_hive.dart';
import '../themes/colors.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    getIt<PageManager>().init();
  }

  @override
  void dispose() {
    getIt<PageManager>().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Box<TracksHive> box = Boxes.getTracks();
    final musicProvider = Provider.of<MusicProvider>(context, listen: false);
    return Scaffold(
        appBar: TopAppBar(scaffoldKey: _key),
        bottomNavigationBar: const Player(),
        floatingActionButton: FloatingActionButton(
            backgroundColor: primaryColor,
            onPressed: (() {
              showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(),
                  useRootNavigator: true);
            }),
            child: const Icon(
              Icons.add,
            )),
        body: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        box.length <= 1
                            ? box.length.toString() + " titre"
                            : box.length.toString() + " titres",
                        style: TextStyle(color: secondaryText),
                      ),
                      InkWell(
                        child:
                            Icon(Icons.swap_vert_rounded, color: secondaryText),
                        onTap: () {
                          setState(() {
                            musicProvider.setSortByMoreRecent();
                          });
                        },
                      ),
                    ]),
              ),
              Expanded(
                child: StreamBuilder<PlayerState>(
                    stream: musicProvider.audioPlayer.playerStateStream,
                    builder: (context, snapshot) {
                      return box.length > 0
                          ? ListView.builder(
                              itemCount: box.length,
                              itemBuilder: ((context, index) {
                                if (musicProvider.sortByMoreRecent) {
                                  index = box.length - index - 1;
                                }
                                return InkWell(
                                  onTap: (() {
                                    // TEST a suppprimer
                                    print(box.getAt(index)!.title.toString());
                                    print(box.getAt(index)!.id.toString());
                                    //
                                    if (musicProvider.currentId ==
                                        box.getAt(index)!.id.toString()) {
                                      musicProvider.musicInit(
                                        index.toString(),
                                        box.getAt(index)!.url.toString(),
                                        box.getAt(index)!.duration.toString(),
                                        box.getAt(index)!.id.toString(),
                                        box.getAt(index)!.artiste.toString(),
                                        box.getAt(index)!.title.toString(),
                                        box.getAt(index)!.cover.toString(),
                                      );
                                    } else {
                                      musicProvider.setCurrentTrack(
                                        box.getAt(index)!.title.toString(),
                                        box.getAt(index)!.artiste.toString(),
                                        box.getAt(index)!.cover.toString(),
                                        box.getAt(index)!.url.toString(),
                                        box.getAt(index)!.id.toString(),
                                      );

                                      musicProvider.musicInit(
                                        index.toString(),
                                        box.getAt(index)!.url.toString(),
                                        box.getAt(index)!.duration.toString(),
                                        box.getAt(index)!.id.toString(),
                                        box.getAt(index)!.artiste.toString(),
                                        box.getAt(index)!.title.toString(),
                                        box.getAt(index)!.cover.toString(),
                                      );

                                      Navigator.pushReplacement(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation1,
                                                  animation2) =>
                                              super.widget,
                                          transitionDuration: Duration.zero,
                                          reverseTransitionDuration:
                                              Duration.zero,
                                        ),
                                      );
                                    }
                                  }),
                                  child: Dismissible(
                                    background: Container(
                                      color: redDiss,
                                    ),
                                    key: UniqueKey(),
                                    onDismissed: (DismissDirection direction) {
                                      setState(() {
                                        TracksUtils.deleteTrack(
                                            box.getAt(index)!.id.toString());
                                      });
                                    },
                                    child: TrackCard(
                                      cover: box.getAt(index)!.cover.toString(),
                                      artiste:
                                          box.getAt(index)!.artiste.toString(),
                                      title: box.getAt(index)!.title.toString(),
                                    ),
                                  ),
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
                    }),
              ),
            ],
          ),
        ));
  }
}

// class Playlist extends StatelessWidget {
//   const Playlist({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     final pageManager = getIt<PageManager>();
//     return Expanded(
//       child: 
// ValueListenableBuilder<List<String>>(
//         valueListenable: pageManager.playlistNotifier,
//         builder: (context, playlistTitles, _) {
//           return ListView.builder(
//             itemCount: playlistTitles.length,
//             itemBuilder: (context, index) {
//               return ListTile(
//                 title: Text(playlistTitles[index]),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// class AddRemoveSongButtons extends StatelessWidget {
//   const AddRemoveSongButtons({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return FloatingActionButton(
//         backgroundColor: primaryColor,
//         onPressed: (() {
//           showSearch(
//               context: context,
//               delegate: CustomSearchDelegate(),
//               useRootNavigator: true);
//         }),
//         child: const Icon(
//           Icons.add,
//         ));
//   }
// }

  // @override
  // Widget build(BuildContext context) {
  //   Box<TracksHive> box = Boxes.getTracks();
  //   final musicProvider = Provider.of<MusicProvider>(context, listen: false);

  //   return Scaffold(
  //       appBar: TopAppBar(scaffoldKey: _key),
  //       bottomNavigationBar: const Player(),
  //       floatingActionButton: FloatingActionButton(
  //           backgroundColor: primaryColor,
  //           onPressed: (() {
  //             showSearch(
  //                 context: context,
  //                 delegate: CustomSearchDelegate(),
  //                 useRootNavigator: true);
  //           }),
  //           child: const Icon(
  //             Icons.add,
  //           )),
        // body: 
       
        // );
  // }
