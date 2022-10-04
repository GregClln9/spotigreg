import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:spotigreg_front/notifiers/play_button_notifier.dart';
import 'package:spotigreg_front/notifiers/progress_notifier.dart';
import 'package:spotigreg_front/notifiers/repeat_button_notifier.dart';
import 'package:spotigreg_front/screens/search.dart';

import '../audio_service/page_manager.dart';
import '../audio_service/service_locator.dart';
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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: const [
            CurrentSongTitle(),
            Playlist(),
            AddRemoveSongButtons(),
            AudioProgressBar(),
            AudioControlButtons(),
          ],
        ),
      ),
    );
  }
}

class CurrentSongTitle extends StatelessWidget {
  const CurrentSongTitle({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();
    return ValueListenableBuilder<String>(
      valueListenable: pageManager.currentSongTitleNotifier,
      builder: (_, title, __) {
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(title, style: const TextStyle(fontSize: 40)),
        );
      },
    );
  }
}

class Playlist extends StatelessWidget {
  const Playlist({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();
    return Expanded(
      child: ValueListenableBuilder<List<String>>(
        valueListenable: pageManager.playlistNotifier,
        builder: (context, playlistTitles, _) {
          return ListView.builder(
            itemCount: playlistTitles.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(playlistTitles[index]),
              );
            },
          );
        },
      ),
    );
  }
}

class AddRemoveSongButtons extends StatelessWidget {
  const AddRemoveSongButtons({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
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
          FloatingActionButton(
            onPressed: pageManager.add,
            child: const Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: pageManager.remove,
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}

class AudioProgressBar extends StatelessWidget {
  const AudioProgressBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();
    return ValueListenableBuilder<ProgressBarState>(
      valueListenable: pageManager.progressNotifier,
      builder: (_, value, __) {
        // print(value.total);
        return ProgressBar(
          progress: value.current,
          buffered: value.buffered,
          total: value.total,
          onSeek: pageManager.seek,
        );
      },
    );
  }
}

class AudioControlButtons extends StatelessWidget {
  const AudioControlButtons({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          RepeatButton(),
          PreviousSongButton(),
          PlayButton(),
          NextSongButton(),
          ShuffleButton(),
        ],
      ),
    );
  }
}

class RepeatButton extends StatelessWidget {
  const RepeatButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();
    return ValueListenableBuilder<RepeatState>(
      valueListenable: pageManager.repeatButtonNotifier,
      builder: (context, value, child) {
        Icon icon;
        switch (value) {
          case RepeatState.off:
            icon = const Icon(Icons.repeat, color: Colors.grey);
            break;
          case RepeatState.repeatSong:
            icon = const Icon(Icons.repeat_one);
            break;
          case RepeatState.repeatPlaylist:
            icon = const Icon(Icons.repeat);
            break;
        }
        return IconButton(
          icon: icon,
          onPressed: pageManager.repeat,
        );
      },
    );
  }
}

class PreviousSongButton extends StatelessWidget {
  const PreviousSongButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();
    return ValueListenableBuilder<bool>(
      valueListenable: pageManager.isFirstSongNotifier,
      builder: (_, isFirst, __) {
        return IconButton(
          icon: const Icon(Icons.skip_previous),
          onPressed: (isFirst) ? null : pageManager.previous,
        );
      },
    );
  }
}

class PlayButton extends StatelessWidget {
  const PlayButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();
    return ValueListenableBuilder<ButtonState>(
      valueListenable: pageManager.playButtonNotifier,
      builder: (_, value, __) {
        switch (value) {
          case ButtonState.loading:
            return Container(
              margin: const EdgeInsets.all(8.0),
              width: 32.0,
              height: 32.0,
              child: const CircularProgressIndicator(),
            );
          case ButtonState.paused:
            return IconButton(
              icon: const Icon(Icons.play_arrow),
              iconSize: 32.0,
              onPressed: pageManager.play,
            );
          case ButtonState.playing:
            return IconButton(
              icon: const Icon(Icons.pause),
              iconSize: 32.0,
              onPressed: pageManager.pause,
            );
        }
      },
    );
  }
}

class NextSongButton extends StatelessWidget {
  const NextSongButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();
    return ValueListenableBuilder<bool>(
      valueListenable: pageManager.isLastSongNotifier,
      builder: (_, isLast, __) {
        return IconButton(
          icon: const Icon(Icons.skip_next),
          onPressed: (isLast) ? null : pageManager.next,
        );
      },
    );
  }
}

class ShuffleButton extends StatelessWidget {
  const ShuffleButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();
    return ValueListenableBuilder<bool>(
      valueListenable: pageManager.isShuffleModeEnabledNotifier,
      builder: (context, isEnabled, child) {
        return IconButton(
          icon: (isEnabled)
              ? const Icon(Icons.shuffle)
              : const Icon(Icons.shuffle, color: Colors.grey),
          onPressed: pageManager.shuffle,
        );
      },
    );
  }
}
  

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
  //       body: Padding(
  //         padding: const EdgeInsets.only(top: 10),
  //         child: Column(
  //           children: [
  //             Padding(
  //               padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
  //               child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Text(
  //                       box.length <= 1
  //                           ? box.length.toString() + " titre"
  //                           : box.length.toString() + " titres",
  //                       style: TextStyle(color: secondaryText),
  //                     ),
  //                     InkWell(
  //                       child:
  //                           Icon(Icons.swap_vert_rounded, color: secondaryText),
  //                       onTap: () {
  //                         setState(() {
  //                           musicProvider.setSortByMoreRecent();
  //                         });
  //                       },
  //                     ),
  //                   ]),
  //             ),
  //             Expanded(
  //               child: StreamBuilder<PlayerState>(
  //                   stream: musicProvider.audioPlayer.playerStateStream,
  //                   builder: (context, snapshot) {
  //                     return box.length > 0
  //                         ? ListView.builder(
  //                             itemCount: box.length,
  //                             itemBuilder: ((context, index) {
  //                               if (musicProvider.sortByMoreRecent) {
  //                                 index = box.length - index - 1;
  //                               }
  //                               return InkWell(
  //                                 onTap: (() {
  //                                   // TEST a suppprimer
  //                                   print(box.getAt(index)!.title.toString());
  //                                   print(box.getAt(index)!.id.toString());
  //                                   //
  //                                   if (musicProvider.currentId ==
  //                                       box.getAt(index)!.id.toString()) {
  //                                     musicProvider.musicInit(
  //                                       index.toString(),
  //                                       box.getAt(index)!.url.toString(),
  //                                       box.getAt(index)!.duration.toString(),
  //                                       box.getAt(index)!.id.toString(),
  //                                       box.getAt(index)!.artiste.toString(),
  //                                       box.getAt(index)!.title.toString(),
  //                                       box.getAt(index)!.cover.toString(),
  //                                     );
  //                                   } else {
  //                                     musicProvider.setCurrentTrack(
  //                                       box.getAt(index)!.title.toString(),
  //                                       box.getAt(index)!.artiste.toString(),
  //                                       box.getAt(index)!.cover.toString(),
  //                                       box.getAt(index)!.url.toString(),
  //                                       box.getAt(index)!.id.toString(),
  //                                     );

  //                                     musicProvider.musicInit(
  //                                       index.toString(),
  //                                       box.getAt(index)!.url.toString(),
  //                                       box.getAt(index)!.duration.toString(),
  //                                       box.getAt(index)!.id.toString(),
  //                                       box.getAt(index)!.artiste.toString(),
  //                                       box.getAt(index)!.title.toString(),
  //                                       box.getAt(index)!.cover.toString(),
  //                                     );

  //                                     Navigator.pushReplacement(
  //                                       context,
  //                                       PageRouteBuilder(
  //                                         pageBuilder: (context, animation1,
  //                                                 animation2) =>
  //                                             super.widget,
  //                                         transitionDuration: Duration.zero,
  //                                         reverseTransitionDuration:
  //                                             Duration.zero,
  //                                       ),
  //                                     );
  //                                   }
  //                                 }),
  //                                 child: Dismissible(
  //                                   background: Container(
  //                                     color: redDiss,
  //                                   ),
  //                                   key: UniqueKey(),
  //                                   onDismissed: (DismissDirection direction) {
  //                                     setState(() {
  //                                       TracksUtils.deleteTrack(
  //                                           box.getAt(index)!.id.toString());
  //                                     });
  //                                   },
  //                                   child: TrackCard(
  //                                     cover: box.getAt(index)!.cover.toString(),
  //                                     artiste:
  //                                         box.getAt(index)!.artiste.toString(),
  //                                     title: box.getAt(index)!.title.toString(),
  //                                   ),
  //                                 ),
  //                               );
  //                             }))
  //                         : Padding(
  //                             padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
  //                             child: Center(
  //                               child: Text(
  //                                 "Aucun titre sauvargdé, cliquez sur + pour en ajouter.",
  //                                 style: TextStyle(color: secondaryText),
  //                                 textAlign: TextAlign.center,
  //                               ),
  //                             ),
  //                           );
  //                   }),
  //             ),
  //           ],
  //         ),
  //       ));
  // }
