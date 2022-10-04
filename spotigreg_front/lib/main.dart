import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:spotigreg_front/audio_service/service_locator.dart';
import 'package:spotigreg_front/provider/music_provider.dart';
import 'package:spotigreg_front/provider/search_provider.dart';
import 'package:spotigreg_front/route/route.dart' as route;
import 'package:spotigreg_front/storage/tracks_hive.dart';

Future<void> main() async {
  // Hive
  await Hive.initFlutter();
  Hive.registerAdapter<TracksHive>(TracksHiveAdapter());
  await Hive.openBox<TracksHive>('tracks');
  // await JustAudioBackground.init(
  //   androidNotificationChannelId: 'com.example.spotigregFront',
  //   androidNotificationChannelName: 'Spotigreg',
  //   androidNotificationOngoing: true,
  // );
  await setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SearchProvider()),
          ChangeNotifierProvider(create: (context) => MusicProvider()),
          ChangeNotifierProvider(
            create: (BuildContext context) {},
            builder: (context, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'SpotiGreg',
                theme: ThemeData.dark(),
                onGenerateRoute: route.controller,
                initialRoute: route.homePage,
              );
            },
          ),
        ],
      );
}
