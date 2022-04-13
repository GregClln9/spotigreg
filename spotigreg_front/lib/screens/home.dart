import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotigreg_front/components/topappbar.dart';
import 'package:spotigreg_front/provider/tracks_provider.dart';
import 'package:spotigreg_front/screens/search.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final tracksProvider = Provider.of<TracksProvider>(context, listen: false);

    return Scaffold(
        appBar: TopAppBar(scaffoldKey: _key),
        floatingActionButton: FloatingActionButton(
          onPressed: (() {}),
          child: IconButton(
              onPressed: () {
                showSearch(context: context, delegate: CustomSearchDelegate());
              },
              icon: const Icon(
                Icons.add,
              )),
        ),
        body: SafeArea(
            child: ListView.builder(
                itemCount: tracksProvider.tracks.length,
                itemBuilder: ((context, index) {
                  return Row(
                    children: [
                      Text(tracksProvider.tracks[index]["title"]),
                      IconButton(
                          onPressed: (() {}),
                          icon: const Icon(Icons.play_arrow))
                    ],
                  );
                }))));
  }
}
