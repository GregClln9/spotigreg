import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YoutubeUtils {
  static searchYoutube(query) async {
    var yt = YoutubeExplode();
    // var test = await yt.search.getVideos(
    //   query,
    // );
    // return test.nextPage();
    return await yt.search.getVideos(query);
  }

  static Future<String> getUrlYoutube(videoId) async {
    // TEST a suppprimer
    print(videoId);
    //
    var yt = YoutubeExplode();
    StreamManifest manifest =
        await yt.videos.streamsClient.getManifest(videoId);
    return manifest.audioOnly[0].url.toString();
  }
}
