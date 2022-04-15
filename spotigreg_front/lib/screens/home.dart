import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotigreg_front/components/home/track_card.dart';
import 'package:spotigreg_front/components/topappbar.dart';
import 'package:spotigreg_front/provider/player_provider.dart';
import 'package:spotigreg_front/components/home/player.dart';
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
  void initState() {
    super.initState();
    // for (var i = 5; i < box.length; i++) {
    //   if (box.get(i)?.url != null) {
    //     _audioPlayer
    //         .setAudioSource(ConcatenatingAudioSource(
    //             children: [AudioSource.uri(Uri.parse(box.get(i)!.url))]))
    //         .catchError((error) {
    //       print(error.toString());
    //     });
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    Box<TracksHive> box = Boxes.getTracks();
    final playerProvider = Provider.of<PlayerProvider>(context, listen: false);

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
                        child: const Text("Delete All"),
                        onDoubleTap: () {
                          TracksUtils.deleteAllTracks();
                          setState(() {});
                        },
                      )
                    ]),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: box.length,
                    itemBuilder: ((context, index) {
                      return Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                          child: InkWell(
                            onTap: (() {
                              playerProvider.setCurrentTrack(
                                box.getAt(index)!.title.toString(),
                                box.getAt(index)!.artiste.toString(),
                                box.getAt(index)!.cover.toString(),
                                box.getAt(index)!.url.toString(),
                              );

                              Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation1, animation2) =>
                                          super.widget,
                                  transitionDuration: Duration.zero,
                                  reverseTransitionDuration: Duration.zero,
                                ),
                              );
                            }),
                            // onDoubleTap: () {
                            //   TracksUtils.deleteTrack(
                            //     box.getAt(index)!.id.toString(),
                            //   );
                            // },
                            child: TrackCard(
                              cover: box.getAt(index)!.cover.toString(),
                              artiste: box.getAt(index)!.artiste.toString(),
                              title: box.getAt(index)!.title.toString(),
                            ),
                          ));
                    })),
              ),
            ],
          ),
        ));
  }
}
