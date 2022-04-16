import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';
import 'package:spotigreg_front/provider/player_provider.dart';

class MusicProvider extends ChangeNotifier {
  final _audioPlayer = AudioPlayer();
  late bool _repeat = false;

  AudioPlayer get audioPlayer => _audioPlayer;
  bool get repeat => _repeat;

  Future<void> musicLoadUrl(String url, String duration, String id,
      String album, String artiste, String artUri, context) async {
    final playerProvider = Provider.of<PlayerProvider>(context, listen: false);
    loopAudioSource() {
      List<ClippingAudioSource> list = [];
      for (var i = 0; i < 3; i++) {
        print(i);
        if (i == 1) {
          artUri =
              "https://rr5---sn-25ge7nse.googlevideo.com/videoplayback?expire=1650127381&ei=tZ1aYojlIPH6xN8P_q688Aw&ip=86.246.110.187&id=o-ADXy1C1bj0YaoWwppPMIuADPd5CykRb2tjCgU8Nvsyh7&itag=139&source=youtube&requiressl=yes&mh=hy&mm=31%2C26&mn=sn-25ge7nse%2Csn-4g5edns6&ms=au%2Conr&mv=m&mvi=5&pl=16&gcr=fr&initcwndbps=1313750&vprv=1&mime=audio%2Fmp4&gir=yes&clen=1095162&dur=179.490&lmt=1639471536400576&mt=1650105436&fvip=5&keepalive=yes&fexp=24001373%2C24007246&beids=24200996&c=ANDROID&txp=4532434&sparams=expire%2Cei%2Cip%2Cid%2Citag%2Csource%2Crequiressl%2Cgcr%2Cvprv%2Cmime%2Cgir%2Cclen%2Cdur%2Clmt&sig=AOq0QJ8wRQIhAKZfeotRVrHE6MZ1cPqJLp1QLzXBD17zEdfuMmr85KJDAiA9CmmjQxEs2uPc0L2Ks2zKuyGj-r09LsO9Vfsj8zprDw%3D%3D&lsparams=mh%2Cmm%2Cmn%2Cms%2Cmv%2Cmvi%2Cpl%2Cinitcwndbps&lsig=AG3C_xAwRQIhAK8_iO-O-5jCirIwAmwL4MlLCbcxA90lql4CsbPgdJ-EAiAj-kAmzZGtylEpJQCLfH5HqBS4gNSupyP6DtytsUGOBw%3D%3D";
        }
        list.add(ClippingAudioSource(
            child: ProgressiveAudioSource(Uri.parse(url),
                tag: MediaItem(
                    id: i.toString(),
                    album: album,
                    artist: artiste,
                    artUri: Uri.parse(artUri),
                    title: artiste)),
            start: const Duration(minutes: 0),
            end: parseDuration(duration)));
      }
      return list;
    }

    _audioPlayer.setAudioSource(
      LoopingAudioSource(
        count: 1,
        child: ConcatenatingAudioSource(
          children: loopAudioSource(),
        ),
      ),
      initialIndex: 0,
    );

    // var duration = await _audioPlayer.setUrl(url);
    // print("DURATION2 : " + duration.toString());

    // getUrl(url) {
    //   _audioPlayer
    //       .setAudioSource(ConcatenatingAudioSource(
    //           children: [AudioSource.uri(Uri.parse(url))]))
    //       .catchError((error) async {
    //     await YoutubeUtils.getUrlYoutube(playerProvider.currentId).then(
    //       (newUrl) {
    //         _audioPlayer
    //             .setAudioSource(ConcatenatingAudioSource(
    //                 children: [AudioSource.uri(Uri.parse(newUrl))]))
    //             .then((value) {
    //           TracksUtils.putTrackUrl(playerProvider.currentId, newUrl);
    //         }).catchError((error) {
    //           // ignore: avoid_print
    //           print("error newUrl, snackbar : " + error.toString());
    //         });
    //       },
    //     ).catchError((error));
    //     // ignore: avoid_print
    //     print("error setAudioSource (URL dead or wrong URL) : " +
    //         error.toString());
    //   });
    // }

    notifyListeners();
  }

  musicInit(String url, String duration, String id, String album,
      String artiste, String artUri, context) {
    musicLoadUrl(url, duration, id, album, artiste, artUri, context);
    musicPlay();
    notifyListeners();
  }

  void musicPlay() {
    _audioPlayer.play();
    notifyListeners();
  }

  void musicPause() {
    _audioPlayer.pause();
    notifyListeners();
  }

  void nextTrack() {
    _audioPlayer.seekToNext();
    notifyListeners();
  }

  void previousTrack() {
    _audioPlayer.seekToPrevious();
    notifyListeners();
  }

  void musicRepeat() async {
    _repeat = !repeat;
    if (_repeat == true) {
      await _audioPlayer.setLoopMode(LoopMode.one);
    } else {
      await _audioPlayer.setLoopMode(LoopMode.off);
    }
    notifyListeners();
  }

  Duration parseDuration(String s) {
    int hours = 0;
    int minutes = 0;
    int micros;
    List<String> parts = s.split(':');
    if (parts.length > 2) {
      hours = int.parse(parts[parts.length - 3]);
    }
    if (parts.length > 1) {
      minutes = int.parse(parts[parts.length - 2]);
    }
    micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
    return Duration(hours: hours, minutes: minutes, microseconds: micros);
  }

  void seek(Duration position) {
    _audioPlayer.seek(position);
  }

  final progressNotifier = ValueNotifier<DurationState>(
    const DurationState(
      progress: Duration.zero,
      buffered: Duration.zero,
      total: Duration.zero,
    ),
  );
}

class DurationState {
  const DurationState(
      {required this.progress, required this.buffered, required this.total});
  final Duration progress;
  final Duration buffered;
  final Duration total;
}
