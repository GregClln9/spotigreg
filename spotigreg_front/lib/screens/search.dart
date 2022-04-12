import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotigreg_front/provider/search_provider.dart';
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
    return StatefulBuilder(builder: (context, setState) {
      double mWidth = MediaQuery.of(context).size.width;
      double mHeight = MediaQuery.of(context).size.height;
      final searchProvider =
          Provider.of<SearchProvider>(context, listen: false);

      if (query.isEmpty) {
        const snackBar = SnackBar(
          content: Text('Query vide...'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return const SizedBox(
          child: Text("Query vide"),
        );
      } else {
        searchProvider.setSearchHistory(query);
        searchYoutube() async {
          var yt = YoutubeExplode();
          // var test = await yt.search.getVideos(
          //   query,
          // );
          // return test.nextPage();
          return await yt.search.getVideos(
            query,
          );
        }

        return FutureBuilder<dynamic>(
            future: searchYoutube(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        child: AspectRatio(
                          aspectRatio: 1.4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AspectRatio(
                                aspectRatio: 1.9,
                                child: Image.network(
                                  snapshot.data[index].thumbnails.mediumResUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(1, 5, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.data[index].author,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      snapshot.data[index].title,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (builder) {
                                return SizedBox(
                                  width: mWidth,
                                  height: mHeight * 0.25,
                                  child: InkWell(
                                    onTap: (() {}),
                                    child: const Text("Télécharger"),
                                  ),
                                );
                              });
                        },
                      );
                    });
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            });
      }
    });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);
    return StatefulBuilder(builder: (context, setState) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text("Recherches récentes"),
              ),
              IconButton(
                  onPressed: () {
                    searchProvider.removeAllSearchHistory();
                    setState(() {});
                  },
                  icon: const Icon(Icons.close))
            ],
          ),
          Expanded(
            child: ListView.builder(
                itemCount: searchProvider.searchHistory.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    background: Container(
                      color: Colors.red,
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
        ],
      );
    });
  }
}
