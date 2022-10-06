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
    box.add(track).catchError((error) {
      print("Error when added " + title + " track");
    }).then((value) {
      print(title + " ADDED.");
    });
  }

  static putTrackUrl(String id, String url) {
    TracksHive? track;
    for (int key in box.keys) {
      if (box.get(key)!.id == id) {
        track = box.get(key);
        track!.url = url;
        box.putAt(key, track).catchError((error) {
          print("Error when updated " + id + " track");
        }).then((value) {
          print("Track with id: " + id + " UPDATED.");
        });
      }
    }
  }

  static deleteTrack(String id) {
    for (int key in box.keys) {
      if (box.get(key)!.id == id) {
        box.delete(key).catchError((error) {
          print("Error when deleted " + id + " track");
        }).then((value) {
          print("Track with id: " + id + " DELETED.");
        });
      }
    }
  }

  static deleteAllTracks() {
    box.clear().catchError((error) {
      print("Error when deleted all tracks");
    }).then((value) {
      print("All tracks are DELETED.");
    });
  }
}
