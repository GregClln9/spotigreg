import 'package:hive_flutter/hive_flutter.dart';
import '../storage/boxes.dart';
import '../storage/tracks_hive.dart';

abstract class PlaylistRepository {
  Future<List<Map<String, String>>> fetchInitialPlaylist();
  Future<Map<String, String>> fetchAnotherSong();
}

class DemoPlaylist extends PlaylistRepository {
  final Box<TracksHive> box = Boxes.getTracks();

  @override
  Future<List<Map<String, String>>> fetchInitialPlaylist() async {
    return List.generate(box.length, (index) => _nextSong());
  }

  @override
  Future<Map<String, String>> fetchAnotherSong() async {
    return _nextSong();
  }

  var _songIndex = -1;

  Map<String, String> _nextSong() {
    Box<TracksHive> box = Boxes.getTracks();
    _songIndex += 1;
    return {
      'id': box.getAt(_songIndex)!.id.toString(),
      'title': box.getAt(_songIndex)!.title.toString(),
      'album': box.getAt(_songIndex)!.title.toString(),
      'url': box.getAt(_songIndex)!.url.toString(),
    };
  }
}
