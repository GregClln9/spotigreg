import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:spotigreg_front/audio_service/video_handler.dart';
import 'package:spotigreg_front/layout/player.dart';
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
    addWelcomeTrack().then((successLoaded) {
      if (successLoaded) {
        videoHandler.initVideoController(box.values.last.url, true);
        loadHome = true;
        setState(() {});
      } else {
        loadHome = false;
      }
    });
  }

  Future<bool> addWelcomeTrack() async {
    final pageManager = ref.read(pageManagerProvider);
    String url =
        "https://rr2---sn-25glenlz.googlevideo.com/videoplayback?expire=1665470501&ei=xbtEY73rCc2DvdIPns6fmAM&ip=109.219.159.175&id=o-ACUEYt8dW4gMFGSqxXRRb3YMC4qvNIVRtHeV-hy1EOKt&itag=18&source=youtube&requiressl=yes&mh=x_&mm=31%2C29&mn=sn-25glenlz%2Csn-25ge7nzk&ms=au%2Crdu&mv=m&mvi=2&pl=20&gcr=fr&initcwndbps=1336250&vprv=1&xtags=heaudio%3Dtrue&mime=video%2Fmp4&cnr=14&ratebypass=yes&dur=168.623&lmt=1664680912212840&mt=1665448402&fvip=4&fexp=24001373%2C24007246&c=ANDROID&txp=4530434&sparams=expire%2Cei%2Cip%2Cid%2Citag%2Csource%2Crequiressl%2Cgcr%2Cvprv%2Cxtags%2Cmime%2Ccnr%2Cratebypass%2Cdur%2Clmt&sig=AOq0QJ8wRAIgGFQv2dQVxw-8gO8ZFnOoMm2nW4O7_5z_RAFnUyvz8r8CIHAd4cb0l1qPqKiBshqON1gnqgbnLUYBJZwP1uOtSNDf&lsparams=mh%2Cmm%2Cmn%2Cms%2Cmv%2Cmvi%2Cpl%2Cinitcwndbps&lsig=AG3C_xAwRAIgJuJ9aKmXg6n4lCmalBKBTI4q-McuLAKTN0FvQ4KAq-kCIAtpyQ0vc_whaDyp1yzyiz6aejLbAzE1YyWjZDZ96v2n";
    try {
      await TracksUtils.addTrack(
          "79DijItQXMM",
          "Welcome To",
          "SpotiGreg !",
          const Duration(minutes: 2, seconds: 48).toString(),
          url,
          url,
          context);

      await pageManager.addMoreRecent(
        "79DijItQXMM",
        "Welcome To",
        "Welcome To",
        url,
        url,
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
      body: (loadHome)
          ? Padding(
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
                              style: Theme.of(context).textTheme.headline2),
                          InkWell(
                            child: Icon(Icons.swap_vert_rounded,
                                color: secondaryText),
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
                  // FutureBuilder(
                  //     future: initializeVideoPlayerFuture,
                  //     builder: (context, snapshot) {
                  //       if ((snapshot.connectionState == ConnectionState.none)) {
                  //         return const CircularProgressIndicator.adaptive();
                  //       } else {
                  //         return ValueListenableBuilder(
                  //             valueListenable: videoController,
                  //             builder: (__, VideoPlayerValue value, _) {
                  //               return SizedBox(
                  //                   height: 200,
                  //                   child: (value.isBuffering)
                  //                       ? const SizedBox(
                  //                           child: CircularProgressIndicator
                  //                               .adaptive())
                  //                       : (value.isInitialized)
                  //                           ? AspectRatio(
                  //                               aspectRatio: value.aspectRatio,
                  //                               child: VideoPlayer(videoController),
                  //                             )
                  //                           : const SizedBox(
                  //                               child: Text("No inizialized"),
                  //                             ));
                  //             });
                  //       }
                  //     }),
                  // LIST OF TRACK
                  Expanded(child: Tracklist(callback: () {
                    setState(() {});
                  })),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}
