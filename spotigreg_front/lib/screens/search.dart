import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotigreg_front/components/search/youtube_card.dart';
import 'package:spotigreg_front/layout/download_modal_bottom.dart';
import 'package:spotigreg_front/themes/colors.dart';
import 'package:spotigreg_front/utils/youtube_utils.dart';
import '../utils/utils.dart';
import 'package:spotigreg_front/utils/search_utils.dart';

class CustomSearchDelegate extends SearchDelegate {
  CustomSearchDelegate();

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            showResults(context);
          },
          icon: const Icon(Icons.search_rounded))
    ];
  }

  @override
  Widget buildResults(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          return FutureBuilder<dynamic>(
              future: YoutubeUtils.searchYoutube(query, ref),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return RawScrollbar(
                    mainAxisMargin: 50,
                    thickness: 5,
                    radius: const Radius.circular(30),
                    thumbColor: secondaryText,
                    child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            child: AspectRatio(
                              aspectRatio: 1.4,
                              child: YoutubeCard(
                                  author: snapshot.data[index].author,
                                  thumbnails: snapshot
                                      .data[index].thumbnails.mediumResUrl,
                                  title: snapshot.data[index].title),
                            ),
                            onTap: () async {
                              try {
                                var url = await YoutubeUtils.getUrlYoutube(
                                    snapshot.data[index].id);

                                showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (builder) {
                                      return DownloadModalBottom(
                                        id: snapshot.data[index].id.toString(),
                                        title: snapshot.data[index].title,
                                        duration: snapshot.data[index].duration
                                            .toString(),
                                        cover: snapshot.data[index].thumbnails
                                            .mediumResUrl,
                                        url: url,
                                        artiste: snapshot.data[index].author,
                                      );
                                    }).then((value) {});
                              } catch (e) {
                                showSnackBar(
                                    context,
                                    "Oups, cette vidéo n'est pas disponible !",
                                    SnackBarState.info);
                              }
                            },
                          );
                        }),
                  );
                } else {
                  return const Center(
                      child: CircularProgressIndicator(color: Colors.white));
                }
              });
        },
      );
    });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final searchHistory = ref.read(searchProvider);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                    child: Text("Recherches récentes"),
                  ),
                  IconButton(
                      onPressed: () {
                        searchHistory.searchHistoryList!.clear();
                        setState(() {});
                      },
                      icon: const Icon(Icons.close_rounded))
                ],
              ),
              Flexible(
                  child: (searchHistory.searchHistoryList != null)
                      ? ListView.builder(
                          itemCount: searchHistory.searchHistoryList!.length,
                          itemBuilder: (context, index) {
                            return Dismissible(
                              background: Container(
                                color: redDiss,
                              ),
                              key: UniqueKey(),
                              onDismissed: (DismissDirection direction) async {
                                setState(() {
                                  searchHistory.searchHistoryList!
                                      .removeAt(index);
                                });
                              },
                              child: InkWell(
                                onTap: (() {
                                  query =
                                      searchHistory.searchHistoryList![index];
                                }),
                                child: ListTile(
                                  title: Text(
                                    searchHistory.searchHistoryList![index],
                                  ),
                                ),
                              ),
                            );
                          })
                      : const SizedBox())
            ],
          );
        },
      );
    });
  }
}



  // Center(
                  //     child: InkWell(
                  //         onTap: () {
                  //           // searchProvider.removeAllSearchHistory();
                  //           setState(() {});
                  //         },
                  //         child: Container(
                  //           child: const Padding(
                  //             padding: EdgeInsets.fromLTRB(15, 4, 15, 4),
                  //             child: Text(
                  //               'Effacer les recherces récentes',
                  //             ),
                  //           ),
                  //           decoration: BoxDecoration(
                  //               border: Border.all(width: 2, color: secondaryText),
                  //               borderRadius: const BorderRadius.all(
                  //                 Radius.circular(20),
                  //               )),
                  //
                  //       )))