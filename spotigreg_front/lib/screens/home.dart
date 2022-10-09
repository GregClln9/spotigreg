import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:spotigreg_front/components/home/track_card.dart';
import 'package:spotigreg_front/layout/player.dart';
import 'package:spotigreg_front/screens/search.dart';
import 'package:spotigreg_front/screens/video_screen.dart';
import 'package:spotigreg_front/utils/search_utils.dart';
import 'package:spotigreg_front/utils/tracks_utils.dart';
import 'package:video_player/video_player.dart';
import '../audio_service/page_manager.dart';
import '../layout/topappbar.dart';
import '../storage/boxes.dart';
import '../storage/tracks_hive.dart';
import '../themes/colors.dart';

class Home extends ConsumerStatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  late String currentUrl = '';

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    final pageManager = ref.read(pageManagerProvider);
    pageManager.init();
    super.initState();
    // if (pageManager.currentSongTitleNotifier)
    pageManager.initVideoController(pageManager.currentSongUrlNotifier.value);
    // _controller.play();
    final searchHistory = ref.read(searchProvider);
    searchHistory.updateSearch(searchHistory.searchHistoryList, ref);
  }

  mySetState() {
    setState(() {});
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    final pageManager = ref.read(pageManagerProvider);
    pageManager.dispose();
    final searchHistory = ref.read(searchProvider);
    searchHistory.saveSearch(searchHistory.searchHistoryList, ref);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchHistory = ref.read(searchProvider);
    searchHistory.saveSearch(searchHistory.searchHistoryList, ref);
    Box<TracksHive> box = Boxes.getTracks();
    return Scaffold(
        key: _key,
        appBar: TopAppBar(scaffoldKey: _key),
        bottomNavigationBar: const Player(true),
        floatingActionButton: FloatingActionButton(
            backgroundColor: primaryColor,
            onPressed: (() {
              showSearch(
                      context: context,
                      delegate: CustomSearchDelegate(),
                      useRootNavigator: true)
                  .then((value) {
                setState(() {});
              });
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
                            // final pageManager = ref.read(pageManagerProvider);
                            // pageManager.sortByMoreRecent =
                            //     !pageManager.sortByMoreRecent;
                            // pageManager.clearPlaylist();
                            // // pageManager.init();
                            // pageManager.loadPlaylist();
                          });
                        },
                      ),
                    ]),
              ),
              // VIDEO
              ValueListenableBuilder(
                  valueListenable: controller,
                  builder: (__, VideoPlayerValue value, _) {
                    // print(value.position);
                    // print(value.isInitialized);
                    // print(value.duration);
                    return SizedBox(
                      height: 200,
                      child: value.isInitialized
                          ? AspectRatio(
                              aspectRatio: controller.value.aspectRatio,
                              child: VideoPlayer(controller),
                            )
                          : const SizedBox(
                              child: CircularProgressIndicator.adaptive(),
                            ),
                    );
                  }),
              // LIST OF SONG
              Expanded(
                  child: box.length > 0
                      ? ListView.builder(
                          itemCount: box.length,
                          itemBuilder: ((context, index) {
                            int indexFake = index;
                            final pageManager = ref.read(pageManagerProvider);
                            if (pageManager.sortByMoreRecent) {
                              indexFake = box.length - index - 1;
                            } else {
                              index = box.length - index - 1;
                            }

                            return InkWell(
                              onTap: (() {
                                final pageManager =
                                    ref.read(pageManagerProvider);
                                pageManager.playFromSong(index);
                              }),
                              child: ValueListenableBuilder(
                                  valueListenable:
                                      pageManager.currentSongTitleNotifier,
                                  builder: (_, title, __) {
                                    return Slidable(
                                      key: UniqueKey(),
                                      dragStartBehavior:
                                          DragStartBehavior.start,
                                      startActionPane: ActionPane(
                                        extentRatio: 0.3,
                                        motion: const ScrollMotion(),
                                        children: [
                                          SlidableAction(
                                            onPressed: ((context) {
                                              if (!(title ==
                                                  box
                                                      .getAt(indexFake)!
                                                      .title
                                                      .toString())) {
                                                final pageManager = ref
                                                    .read(pageManagerProvider);
                                                pageManager
                                                    .playFromSongForVideo(
                                                        index);
                                              }
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const VideoScreen()));
                                            }),
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 44, 42, 42),
                                            foregroundColor: secondaryText,
                                            icon: Icons.play_arrow_rounded,
                                          ),
                                        ],
                                      ),
                                      endActionPane: ActionPane(
                                        extentRatio: 0.2,
                                        motion: const ScrollMotion(),
                                        children: [
                                          SlidableAction(
                                            onPressed: ((context) {
                                              setState(() {
                                                final pageManager = ref
                                                    .read(pageManagerProvider);
                                                pageManager.remove(index);
                                                TracksUtils.deleteTrack(
                                                    box
                                                        .getAt(indexFake)!
                                                        .id
                                                        .toString(),
                                                    context);
                                              });
                                            }),
                                            backgroundColor: redDiss,
                                            foregroundColor: Colors.white,
                                            icon: Icons.delete_outline_rounded,
                                          ),
                                        ],
                                      ),
                                      child: TrackCard(
                                        cover: box
                                            .getAt(indexFake)!
                                            .cover
                                            .toString(),
                                        artiste: box
                                            .getAt(indexFake)!
                                            .artiste
                                            .toString(),
                                        title: box
                                            .getAt(indexFake)!
                                            .title
                                            .toString(),
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
                        )),
            ],
          ),
        ));
  }
}
