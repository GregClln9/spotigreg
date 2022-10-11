// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spotigreg_front/storage/boxes.dart';
import 'package:spotigreg_front/storage/tracks_hive.dart';
import 'package:spotigreg_front/utils/utils.dart';

Box<TracksHive> box = Boxes.getTracks();

class TracksUtils {
  static addTrack(String id, String title, String artiste, String duration,
      String cover, String url, BuildContext? context) {
    final track = TracksHive(
      id: id,
      title: title,
      artiste: artiste,
      duration: duration,
      cover: cover,
      url: url,
    );
    box.add(track).catchError((error) {
      if (context != null) {
        showSnackBar(
            context, "Erreur durant l'ajout de " + title, SnackBarState.error);
      }
    }).then((value) {
      if (context != null) {
        showSnackBar(context, title + " est ajouté dans la playlist",
            SnackBarState.success);
      }
    });
  }

  static putTrackUrl(String id, String url) {
    TracksHive? track;
    for (int key in box.keys) {
      if (box.get(key)!.id == id) {
        track = box.get(key);
        track!.url = url;
        box.put(key, track).catchError((error) {
          print("Error when updated " + id + " track");
        }).then((value) {
          print("Track with id: " + id + " UPDATED.");
        });
      }
    }
  }

  static deleteTrack(String id, BuildContext context) {
    for (int key in box.keys) {
      if (box.get(key)!.id == id) {
        box.delete(key).catchError((error) {
          showSnackBar(context, "Erreur", SnackBarState.error);
        }).then((value) {
          showSnackBar(
              context, "Le track " + id + " est supprimé", SnackBarState.info);
        });
      }
    }
  }

  static deleteAllTracks(BuildContext context) {
    box.clear().catchError((error) {
      showSnackBar(context, "Erreur", SnackBarState.error);
    }).then((value) {
      showSnackBar(context, "Les tracks sont supprimées", SnackBarState.info);
    });
  }
}
