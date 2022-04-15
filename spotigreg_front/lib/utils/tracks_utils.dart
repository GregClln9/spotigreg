// ignore_for_file: avoid_print

import 'package:hive_flutter/hive_flutter.dart';
import 'package:spotigreg_front/storage/boxes.dart';
import 'package:spotigreg_front/storage/tracks_hive.dart';

Box<TracksHive> box = Boxes.getTracks();

class TracksUtils {
  static addTrack(String id, String title, String artiste, String duration,
      String cover, String url) {
    final track = TracksHive(
      id: id,
      title: title,
      artiste: artiste,
      duration: duration,
      cover: cover,
      url: url,
    );
    box.add(track);
    print(title + " downloaded.");
  }

  static deleteTrack(String id) {
    for (var i = 0; i < box.length; i++) {
      if (box.get(i)!.id == id) {
        box.delete(i);
      }
    }
    print("Track with id: " + id + " deleted.");
  }

  static deleteAllTracks() {
    box.clear();
    print("All tracks are deleteted.");
  }
}
