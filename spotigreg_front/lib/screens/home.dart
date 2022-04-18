import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:spotigreg_front/components/home/track_card.dart';
import 'package:spotigreg_front/layout/topappbar.dart';
import 'package:spotigreg_front/provider/music_provider.dart';
import 'package:spotigreg_front/layout/player.dart';
import 'package:spotigreg_front/screens/search.dart';
import 'package:spotigreg_front/storage/boxes.dart';
import 'package:spotigreg_front/storage/tracks_hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spotigreg_front/utils/tracks_utils.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Box<TracksHive> box = Boxes.getTracks();
    final musicProvider = Provider.of<MusicProvider>(context, listen: false);

    return Scaffold(
        appBar: TopAppBar(scaffoldKey: _key),
        bottomNavigationBar: const Player(),
        floatingActionButton: FloatingActionButton(
            onPressed: (() {
              showSearch(context: context, delegate: CustomSearchDelegate());
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
                      Text(box.length <= 1
                          ? box.length.toString() + " titre"
                          : box.length.toString() + " titres"),
                      InkWell(
                        child: const Text("Sort By.."),
                        onTap: () {
                          setState(() {
                            musicProvider.setSortByMoreRecent();
                          });
                        },
                      ),
                      InkWell(
                        child: const Text("Delete All"),
                        onDoubleTap: () {
                          setState(() {
                            TracksUtils.deleteAllTracks();
                          });
                        },
                      )
                    ]),
              ),
              Expanded(
                child: StreamBuilder<PlayerState>(
                    stream: musicProvider.audioPlayer.playerStateStream,
                    builder: (context, snapshot) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: ListView.builder(
                            itemCount: box.length,
                            itemBuilder: ((context, index) {
                              if (musicProvider.sortByMoreRecent) {
                                index = box.length - index - 1;
                              }
                              return InkWell(
                                onTap: (() {
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
                                        pageBuilder:
                                            (context, animation1, animation2) =>
                                                super.widget,
                                        transitionDuration: Duration.zero,
                                        reverseTransitionDuration:
                                            Duration.zero,
                                      ),
                                    );
                                  }
                                }),
                                child: TrackCard(
                                  cover: box.getAt(index)!.cover.toString(),
                                  artiste: box.getAt(index)!.artiste.toString(),
                                  title: box.getAt(index)!.title.toString(),
                                ),
                              );
                            })),
                      );
                    }),
              ),
            ],
          ),
        ));
  }
}
