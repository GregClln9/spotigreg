import 'package:hive_flutter/hive_flutter.dart';
import '../storage/boxes.dart';
import '../storage/tracks_hive.dart';

abstract class PlaylistRepository {
  Future<List<Map<String, String>>> fetchInitialPlaylist();
  Future<Map<String, String>> fetchAnotherSong();
}

class DemoPlaylist extends PlaylistRepository {
  @override
  Future<List<Map<String, String>>> fetchInitialPlaylist(
      {int length = 1}) async {
    return List.generate(length, (index) => _nextSong());
  }

  @override
  Future<Map<String, String>> fetchAnotherSong() async {
    return _nextSong();
  }

  var _songIndex = -1;
  static const _maxSongNumber = 16;

  Map<String, String> _nextSong() {
    Box<TracksHive> box = Boxes.getTracks();
    _songIndex = (_songIndex % _maxSongNumber) + 1;
    print("_songIndex");
    print(_songIndex);
    print("_songIndex");
    // print(box.getAt(_songIndex)!.duration.toString());
    return {
      'id': box.getAt(_songIndex)!.id.toString(),
      'title': box.getAt(_songIndex)!.title.toString(),
      'album': box.getAt(_songIndex)!.title.toString(),
      'url': box.getAt(_songIndex)!.url.toString(),
      'duration': box.getAt(_songIndex)!.duration.toString(),
    };
  }
}
