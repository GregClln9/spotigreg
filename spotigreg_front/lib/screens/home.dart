import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:spotigreg_front/audio_service/video_handler.dart';
import 'package:spotigreg_front/layout/player.dart';
import 'package:spotigreg_front/layout/track_list.dart';
import 'package:spotigreg_front/screens/search.dart';
import 'package:spotigreg_front/utils/search_utils.dart';
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
    // init audioController
    final pageManager = ref.read(pageManagerProvider);
    pageManager.init();
    // init VideoController with first song
    final videoHandler = VideoHandler();
    Box<TracksHive> box = Boxes.getTracks();
    videoHandler.initVideoController(box.values.last.url, true);
    final searchHistory = ref.read(searchProvider);
    searchHistory.updateSearch(searchHistory.searchHistoryList, ref);
  }

  @override
  void dispose() {
    final pageManager = ref.read(pageManagerProvider);
    pageManager.dispose();
    final videoHandler = VideoHandler();
    videoHandler.dispose();
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
        bottomNavigationBar: const PlayerHome(),
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
              FutureBuilder(
                  future: initializeVideoPlayerFuture,
                  builder: (context, snapshot) {
                    if ((snapshot.connectionState == ConnectionState.none)) {
                      return const CircularProgressIndicator.adaptive();
                    } else {
                      return ValueListenableBuilder(
                          valueListenable: videoController,
                          builder: (__, VideoPlayerValue value, _) {
                            return SizedBox(
                                height: 200,
                                child: (value.isBuffering)
                                    ? const SizedBox(
                                        child: CircularProgressIndicator
                                            .adaptive())
                                    : (value.isInitialized)
                                        ? AspectRatio(
                                            aspectRatio: value.aspectRatio,
                                            child: VideoPlayer(videoController),
                                          )
                                        : const SizedBox(
                                            child: Text("No inizialized"),
                                          ));
                          });
                    }
                  }),
              // LIST OF TRACK
              Expanded(child: Tracklist(callback: () {
                setState(() {});
              })),
            ],
          ),
        ));
  }
}
