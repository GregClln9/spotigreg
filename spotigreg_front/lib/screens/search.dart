import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:spotigreg_front/utils/youtube_config.dart';

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
      getYoutube() async {
        var dio = Dio();
        Response response =
            await dio.get(YoutubeConfig.apiEndpoint, queryParameters: {
          "q": query,
          "key": YoutubeConfig.apiKey,
          "type": "video",
          "maxResults": "${YoutubeConfig.searchResult}",
          "part": "snippet",
        });

        print(response);
      }

      getYoutube();

      return const Text("Result");
    });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Text("suggestions mdr");
  }
}
