import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotigreg_front/components/search/youtube_modal_bottom.dart';
import 'package:spotigreg_front/components/search/youtube_results.dart';
import 'package:spotigreg_front/provider/search_provider.dart';
import 'package:spotigreg_front/utils/youtube_utils.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class CustomSearchDelegate extends SearchDelegate {
  CustomSearchDelegate();

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, "close"),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget buildResults(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);
    WidgetsBinding.instance
        ?.addPostFrameCallback((_) => searchProvider.setSearchHistory(query));

    return StatefulBuilder(builder: (context, setState) {
      return FutureBuilder<dynamic>(
          future: YoutubeUtils.searchYoutube(query),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      child: AspectRatio(
                        aspectRatio: 1.4,
                        child: YoutubeResults(
                            author: snapshot.data[index].author,
                            thumbnails:
                                snapshot.data[index].thumbnails.mediumResUrl,
                            title: snapshot.data[index].title),
                      ),
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (builder) {
                              return YoutubeModalBottom(
                                function: () async {
                                  var yt = YoutubeExplode();
                                  var manifest = await yt.videos.streamsClient
                                      .getManifest(snapshot.data[index].id);
                                  print(manifest.audioOnly
                                      .withHighestBitrate()
                                      .url);
                                },
                              );
                            });
                      },
                    );
                  });
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          });
    });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    double mHeight = MediaQuery.of(context).size.height;
    return StatefulBuilder(builder: (context, setState) {
      final searchProvider =
          Provider.of<SearchProvider>(context, listen: false);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
            child: Text("Recherches récentes"),
          ),
          SingleChildScrollView(
            child: SizedBox(
              height: mHeight * 0.8,
              child: ListView.builder(
                  itemCount: searchProvider.searchHistory.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      background: Container(
                        color: const Color.fromARGB(255, 212, 41, 28),
                      ),
                      key: UniqueKey(),
                      onDismissed: (DismissDirection direction) {
                        searchProvider.removeSearchHistory(
                            searchProvider.searchHistory.elementAt(index));
                      },
                      child: ListTile(
                        title: Text(
                          searchProvider.searchHistory.elementAt(index),
                        ),
                      ),
                    );
                  }),
            ),
          ),
          Center(
            child: InkWell(
                onTap: () {
                  searchProvider.removeAllSearchHistory();
                  setState(() {});
                },
                child: const Text('Effacer les recherces récentes')),
          )
        ],
      );
    });
  }
}
