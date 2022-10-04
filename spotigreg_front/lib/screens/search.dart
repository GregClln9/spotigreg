import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotigreg_front/layout/download_modal_bottom.dart';
import 'package:spotigreg_front/components/search/youtube_card.dart';
import 'package:spotigreg_front/provider/search_provider.dart';
import 'package:spotigreg_front/themes/colors.dart';
import 'package:spotigreg_front/utils/youtube_utils.dart';
import 'package:spotigreg_front/route/route.dart' as route;

class CustomSearchDelegate extends SearchDelegate {
  CustomSearchDelegate();

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.of(context).pushNamedAndRemoveUntil(
          route.homePage,
          (route) => false,
        );
      },
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
        .addPostFrameCallback((_) => searchProvider.setSearchHistory(query));

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
                        child: YoutubeCard(
                            author: snapshot.data[index].author,
                            thumbnails:
                                snapshot.data[index].thumbnails.mediumResUrl,
                            title: snapshot.data[index].title),
                      ),
                      onTap: () async {
                        var url = await YoutubeUtils.getUrlYoutube(
                            snapshot.data[index].id);
                        showModalBottomSheet(
                            context: context,
                            builder: (builder) {
                              return DownloadModalBottom(
                                id: snapshot.data[index].id.toString(),
                                title: snapshot.data[index].title,
                                duration:
                                    snapshot.data[index].duration.toString(),
                                cover: snapshot
                                    .data[index].thumbnails.mediumResUrl,
                                url: url,
                                artiste: snapshot.data[index].author,
                              );
                            });
                      },
                    );
                  });
            } else {
              return const Center(
                  child: CircularProgressIndicator(color: Colors.white));
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
                        color: redDiss,
                      ),
                      key: UniqueKey(),
                      onDismissed: (DismissDirection direction) {
                        searchProvider.removeSearchHistory(
                            searchProvider.searchHistory.elementAt(index));
                      },
                      child: InkWell(
                        onTap: (() {
                          query = searchProvider.searchHistory.elementAt(index);
                        }),
                        child: ListTile(
                          title: Text(
                            searchProvider.searchHistory.elementAt(index),
                          ),
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
                  child: Container(
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(15, 4, 15, 4),
                      child: Text(
                        'Effacer les recherces récentes',
                      ),
                    ),
                    decoration: BoxDecoration(
                        border: Border.all(width: 2, color: secondaryText),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20),
                        )),
                  )))
        ],
      );
    });
  }
}
