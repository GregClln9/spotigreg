import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:spotigreg_front/audio_service/page_manager.dart';
import 'package:spotigreg_front/route/route.dart' as route;
import 'package:spotigreg_front/storage/boxes.dart';
import 'package:spotigreg_front/storage/tracks_hive.dart';
import 'package:spotigreg_front/themes/colors.dart';
import 'package:spotigreg_front/utils/tracks_utils.dart';

Future<void> main() async {
  // Hive
  await Hive.initFlutter();
  Hive.registerAdapter<TracksHive>(TracksHiveAdapter());
  await Hive.openBox<TracksHive>('tracks');
  Box<TracksHive> box = Boxes.getTracks();
  if (box.length <= 0) {
    String url =
        "https://rr2---sn-25glenlz.googlevideo.com/videoplayback?expire=1665470501&ei=xbtEY73rCc2DvdIPns6fmAM&ip=109.219.159.175&id=o-ACUEYt8dW4gMFGSqxXRRb3YMC4qvNIVRtHeV-hy1EOKt&itag=18&source=youtube&requiressl=yes&mh=x_&mm=31,29&mn=sn-25glenlz,sn-25ge7nzk&ms=au,rdu&mv=m&mvi=2&pl=20&gcr=fr&initcwndbps=1336250&vprv=1&xtags=heaudio=true&mime=video/mp4&cnr=14&ratebypass=yes&dur=168.623&lmt=1664680912212840&mt=1665448402&fvip=4&fexp=24001373,24007246&c=ANDROID&txp=4530434&sparams=expi";
    await TracksUtils.addTrack("iMtleEaMeyQ", "Welcome To", "SpotiGreg",
        const Duration(minutes: 2, seconds: 48).toString(), url, url, null);
  }
  await PageManager.checkUrl();
  await PageManager.initAudioHandler();

  runApp(const ProviderScope(child: MyApp()));
}

final _navigatorKey = GlobalKey();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: _navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'SpotiGreg',
      theme: themedataDark,
      onGenerateRoute: route.controller,
      initialRoute: route.menuBottom,
    );
  }
}
