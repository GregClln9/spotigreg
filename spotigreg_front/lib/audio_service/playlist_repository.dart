import 'package:hive_flutter/hive_flutter.dart';
import '../storage/boxes.dart';
import '../storage/tracks_hive.dart';

class PlaylistRepository {
  final Box<TracksHive> box = Boxes.getTracks();

  Future<List<Map<String, String>>> fetchInitialPlaylist() async {
    return List.generate(box.length, (index) => _nextSong());
  }

  Future<Map<String, String>> fetchAnotherSong() async {
    return _nextSong();
  }

  var _songIndex = -1;

  Map<String, String> _nextSong() {
    Box<TracksHive> box = Boxes.getTracks();
    _songIndex += 1;
    int boxIndex = box.keys.elementAt(_songIndex);

    return {
      'id': box.get(boxIndex)!.id.toString(),
      'title': box.get(boxIndex)!.title.toString(),
      'artist': box.get(boxIndex)!.artiste.toString(),
      'album': "SpotiGreg",
      'url': box.get(boxIndex)!.url.toString(),
      'artUri': box.get(boxIndex)!.cover.toString(),
    };
  }
}

class PlaylistRepositorySortByMoreRecent {
  Box<TracksHive> box = Boxes.getTracks();

  Future<List<Map<String, String>>> fetchInitialPlaylist() async {
    return List.generate(box.length, (index) => _nextSong());
  }

  Future<Map<String, String>> fetchAnotherSong() async {
    return _nextSong();
  }

  late int _songIndex = box.length;

  Map<String, String> _nextSong() {
    Box<TracksHive> box = Boxes.getTracks();

    _songIndex -= 1;
    int boxIndex = box.keys.elementAt(_songIndex);

    print(box.get(boxIndex)!.artiste.toString() + " test");

    return {
      'id': box.get(boxIndex)!.id.toString(),
      'title': box.get(boxIndex)!.title.toString(),
      'album': "SpotiGreg",
      'artist': box.get(boxIndex)!.artiste.toString(),
      'url': box.get(boxIndex)!.url.toString(),
      'artUri': box.get(boxIndex)!.cover.toString(),
    };
  }
}
