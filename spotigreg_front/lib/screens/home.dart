import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:spotigreg_front/audio_service/video_handler.dart';
import 'package:spotigreg_front/layout/track_list.dart';
import 'package:spotigreg_front/screens/search.dart';
import 'package:spotigreg_front/utils/search_utils.dart';
import 'package:spotigreg_front/utils/tracks_utils.dart';
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

late bool loadHome = false;
final GlobalKey<ScaffoldState> _key = GlobalKey();

class _HomeState extends ConsumerState<Home> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
    // init audioController
    final pageManager = ref.read(pageManagerProvider);
    pageManager.init();
    // init VideoController with first song
    final videoHandler = VideoHandler();
    Box<TracksHive> box = Boxes.getTracks();
    if (box.length > 0) {
      videoHandler.initVideoController(box.values.last.url, true);
      loadHome = true;
    } else {
      loadWelcomeTrack();
    }

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

  loadWelcomeTrack() async {
    addWelcomeTrack().then((successLoaded) async {
      if (successLoaded) {
        await videoHandler.initVideoController(box.values.last.url, true);
        loadHome = true;
        setState(() {});
      } else {
        loadHome = false;
      }
    });
  }

  Future<bool> addWelcomeTrack() async {
    final pageManager = ref.read(pageManagerProvider);
    try {
      Box<TracksHive> box = Boxes.getTracks();
      await pageManager.addMoreRecent(
        "iMtleEaMeyQ",
        "Welcome To",
        "Welcome To",
        box.values.first.url,
        box.values.first.url,
        "SpotiGreg !",
      );
      await PageManager.checkUrl();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    double mHeight = MediaQuery.of(context).size.height;

    final searchHistory = ref.read(searchProvider);
    searchHistory.saveSearch(searchHistory.searchHistoryList, ref);
    Box<TracksHive> box = Boxes.getTracks();
    return Scaffold(
      key: _key,
      appBar: TopAppBar(scaffoldKey: _key),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: (loadHome)
          ? SizedBox(
              height: mHeight * 0.75,
              child: Padding(
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
                                style:
                                    Theme.of(context).textTheme.displayMedium),
                            InkWell(
                              // child: Icon(Icons.swap_vert_rounded,
                              //     color: secondaryText),
                              child: Icon(Icons.add, color: primaryColor),

                              onTap: () {
                                setState(() {
                                  // final pageManager = ref.read(pageManagerProvider);
                                  // pageManager.sortByMoreRecent =
                                  //     !pageManager.sortByMoreRecent;
                                  // pageManager.clearPlaylist();
                                  // // pageManager.init();
                                  // pageManager.loadPlaylist();
                                  showSearch(
                                          context: context,
                                          delegate: CustomSearchDelegate(),
                                          useRootNavigator: true)
                                      .then((value) {
                                    setState(() {});
                                  });
                                });
                              },
                            ),
                          ]),
                    ),
                    // LIST OF TRACK
                    Expanded(child: Tracklist(callback: () {
                      setState(() {});
                    })),
                  ],
                ),
              ),
            )
          : const Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}
