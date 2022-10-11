import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:spotigreg_front/layout/player_home.dart';
import 'package:spotigreg_front/screens/home.dart';
import 'package:spotigreg_front/screens/track_screen.dart';

final _navigatorKey2 = GlobalKey();

class MenuBottom extends StatelessWidget {
  const MenuBottom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double mHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: MiniplayerWillPopScope(
        onWillPop: () async {
          final NavigatorState navigator =
              _navigatorKey2.currentState as NavigatorState;
          if (!navigator.canPop()) return true;
          navigator.pop();

          return false;
        },
        child: Stack(
          children: [
            Navigator(
              key: _navigatorKey2,
              onGenerateRoute: (RouteSettings settings) => MaterialPageRoute(
                settings: settings,
                builder: (BuildContext context) => const Home(),
              ),
            ),
            Miniplayer(
                minHeight: mHeight * 0.15,
                maxHeight: mHeight,
                builder: (height, percentage) {
                  if (percentage < 0.5) {
                    SystemChrome.setPreferredOrientations([
                      DeviceOrientation.portraitUp,
                      DeviceOrientation.portraitDown,
                    ]);
                  }
                  if (percentage > 0.5) {
                    return const TrackScreen();
                  } else {
                    return const PlayerHome();
                  }
                }),
          ],
        ),
      ),
    );
  }
}
