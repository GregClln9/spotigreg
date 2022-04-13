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
}
