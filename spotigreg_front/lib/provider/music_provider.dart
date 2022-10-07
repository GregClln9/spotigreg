// import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:just_audio_background/just_audio_background.dart';
// import 'package:spotigreg_front/utils/tracks_utils.dart';
// import 'package:spotigreg_front/utils/youtube_utils.dart';

// class MusicProvider extends ChangeNotifier {
//   final _audioPlayer = AudioPlayer();
//   late bool _repeat = false;
//   late bool _sortByMoreRecent = false;

//   // Current track
//   late String _currentTitle = "currentTitle";
//   late String _currentArtiste = "currentArtiste";
//   late String _currentCover = "currentCover";
//   late String _currentId = "currentId";
//   late String _currentUrl = "currentUrl";
//   late String _currentIdPosition = "currentIdPosition";

//   AudioPlayer get audioPlayer => _audioPlayer;
//   bool get repeat => _repeat;
//   bool get sortByMoreRecent => _sortByMoreRecent;

//   // Current track (get)
//   String get currentTitle => _currentTitle;
//   String get currentArtiste => _currentArtiste;
//   String get currentCover => _currentCover;
//   String get currentUrl => _currentUrl;
//   String get currentId => _currentId;
//   String get currentIdPosition => _currentIdPosition;

//   // Current track (set)
//   void setCurrentTrack(newTtile, newArtiste, newCover, newUrl, newId) {
//     _currentTitle = newTtile;
//     _currentArtiste = newArtiste;
//     _currentCover = newCover;
//     _currentUrl = newUrl;
//     _currentId = newId;
//     notifyListeners();
//   }

//   void setSortByMoreRecent() {
//     _sortByMoreRecent = !sortByMoreRecent;
//     notifyListeners();
//   }

//   Future<void> musicLoadUrl(String idPosition, String url, String duration,
//       String id, String title, String artiste, String artUri) async {
//     _currentIdPosition = idPosition;

//     _audioPlayer
//         .setAudioSource(ClippingAudioSource(
//             child: AudioSource.uri(Uri.parse(url)),
//             tag: MediaItem(
//                 id: id,
//                 artist: artiste,
//                 artUri: Uri.parse(artUri),
//                 title: title),
//             start: const Duration(minutes: 0),
//             end: parseDuration(duration)))
//         .catchError((error) async {
//       await YoutubeUtils.getUrlYoutube(id).then(
//         (newUrl) {
//           _audioPlayer
//               .setAudioSource(ClippingAudioSource(
//                   child: AudioSource.uri(Uri.parse(newUrl)),
//                   tag: MediaItem(
//                       id: id,
//                       artist: artiste,
//                       artUri: Uri.parse(artUri),
//                       title: title),
//                   start: const Duration(minutes: 0),
//                   end: parseDuration(duration)))
//               .then((value) {
//             TracksUtils.putTrackUrl(id, newUrl);
//           }).catchError((error) {
//             // ignore: avoid_print
//             print("error newUrl, snackbar : " + error.toString());
//           });
//         },
//       ).catchError((error));
//       // ignore: avoid_print
//       print(
//           "error setAudioSource (URL dead or wrong URL) : " + error.toString());
//     });
//     notifyListeners();
//   }

//   musicInit(String idPosition, String url, String duration, String id,
//       String title, String artiste, String artUri) {
//     musicLoadUrl(idPosition, url, duration, id, title, artiste, artUri);
//     musicPlay();
//     notifyListeners();
//   }

//   void musicPlay() {
//     _audioPlayer.play();
//     notifyListeners();
//   }

//   void musicPause() {
//     _audioPlayer.pause();
//     notifyListeners();
//   }

//   nextTrack() {
//     nextAndPrevious(int.parse(_currentIdPosition) + 1);
//     notifyListeners();
//   }

//   previousTrack() {
//     nextAndPrevious(int.parse(_currentIdPosition) - 1);
//     notifyListeners();
//   }

//   nextAndPrevious(int index) {
//     if (_repeat) {
//       audioPlayer.seekToNext();
//     } else {
//       try {
//         box.getAt(index)!.title.toString();
//       } catch (e) {
//         return;
//       }
//       setCurrentTrack(
//         box.getAt(index)!.title.toString(),
//         box.getAt(index)!.artiste.toString(),
//         box.getAt(index)!.cover.toString(),
//         box.getAt(index)!.url.toString(),
//         box.getAt(index)!.id.toString(),
//       );
//       musicInit(
//         (index).toString(),
//         box.getAt(index)!.url.toString(),
//         box.getAt(index)!.duration.toString(),
//         box.getAt(index)!.id.toString(),
//         box.getAt(index)!.artiste.toString(),
//         box.getAt(index)!.title.toString(),
//         box.getAt(index)!.cover.toString(),
//       );
//     }
//   }

//   void musicRepeat() async {
//     _repeat = !repeat;
//     if (_repeat == true) {
//       await _audioPlayer.setLoopMode(LoopMode.one);
//     } else {
//       await _audioPlayer.setLoopMode(LoopMode.off);
//     }
//     notifyListeners();
//   }

//   Duration parseDuration(String s) {
//     int hours = 0;
//     int minutes = 0;
//     int micros;
//     List<String> parts = s.split(':');
//     if (parts.length > 2) {
//       hours = int.parse(parts[parts.length - 3]);
//     }
//     if (parts.length > 1) {
//       minutes = int.parse(parts[parts.length - 2]);
//     }
//     micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
//     return Duration(hours: hours, minutes: minutes, microseconds: micros);
//   }

//   void seek(Duration position) {
//     _audioPlayer.seek(position);
//   }

//   final progressNotifier = ValueNotifier<DurationState>(
//     const DurationState(
//       progress: Duration.zero,
//       buffered: Duration.zero,
//       total: Duration.zero,
//     ),
//   );
// }

// class DurationState {
//   const DurationState(
//       {required this.progress, required this.buffered, required this.total});
//   final Duration progress;
//   final Duration buffered;
//   final Duration total;
// }
