import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotigreg_front/utils/search_utils.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YoutubeUtils {
  static searchYoutube(query, WidgetRef ref) async {
    final searchHistory = ref.read(searchProvider);
    if (searchHistory.searchHistoryList != null) {
      searchHistory.searchHistoryList!.add(query);
    }
    var yt = YoutubeExplode();
    // var test = await yt.search.getVideos(
    //   query,
    // );
    // return test.nextPage();

    return yt.search.search(query);
  }

  static Future<String> getUrlYoutube(videoId) async {
    var yt = YoutubeExplode();
    StreamManifest manifest =
        await yt.videos.streamsClient.getManifest(videoId);
    return manifest.audio[1].url.toString();
  }
}
