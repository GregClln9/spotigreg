import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YoutubeUtils {
  static searchYoutube(query) async {
    var yt = YoutubeExplode();
    // var test = await yt.search.getVideos(
    //   query,
    // );
    // return test.nextPage();
    return yt.search.search(query);
  }

  static Future<String> getUrlYoutube(videoId) async {
    print("getUrlYoutube");
    var yt = YoutubeExplode();
    StreamManifest manifest =
        await yt.videos.streamsClient.getManifest(videoId);
    return manifest.audio[1].url.toString();
  }
}
