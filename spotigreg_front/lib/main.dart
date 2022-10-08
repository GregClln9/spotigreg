import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:spotigreg_front/audio_service/page_manager.dart';
import 'package:spotigreg_front/route/route.dart' as route;
import 'package:spotigreg_front/storage/tracks_hive.dart';

Future<void> main() async {
  // Hive
  await Hive.initFlutter();
  Hive.registerAdapter<TracksHive>(TracksHiveAdapter());
  await Hive.openBox<TracksHive>('tracks');
  await PageManager.checkUrl();
  await PageManager.initAudioHandler();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SpotiGreg',
      theme: ThemeData.dark(),
      onGenerateRoute: route.controller,
      initialRoute: route.homePage,
    );
  }
}
