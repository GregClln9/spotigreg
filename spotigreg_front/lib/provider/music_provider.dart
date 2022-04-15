import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:spotigreg_front/provider/player_provider.dart';

class MusicProvider extends ChangeNotifier {
  final _audioPlayer = AudioPlayer();
  late bool _repeat = false;

  AudioPlayer get audioPlayer => _audioPlayer;
  bool get repeat => _repeat;

  void musicLoadUrl(String url, context) {
    final playerProvider = Provider.of<PlayerProvider>(context, listen: false);

    _audioPlayer.setAudioSource(
      // Loop child 4 times
      LoopingAudioSource(
        count: 2,
        // Play children one after the other
        child: ConcatenatingAudioSource(
          children: [
            // Play a regular media file
            ProgressiveAudioSource(Uri.parse(url)),
            // Play a DASH stream
            ProgressiveAudioSource(Uri.parse(
                "https://rr4---sn-25glenes.googlevideo.com/videoplayback?expire=1650067465&ei=qbNZYrDiCLH4xN8P1p6UmAM&ip=86.246.110.187&id=o-ADf0FNlvRO4s_kXAsnctiSYKsSl3sAItP2tr91t_rL9x&itag=139&source=youtube&requiressl=yes&mh=jn&mm=31%2C26&mn=sn-25glenes%2Csn-4g5lznez&ms=au%2Conr&mv=m&mvi=4&pl=16&initcwndbps=1132500&vprv=1&mime=audio%2Fmp4&gir=yes&clen=611164&dur=100.077&lmt=1649973639250199&mt=1650045429&fvip=4&keepalive=yes&fexp=24001373%2C24007246&c=ANDROID&txp=4532434&sparams=expire%2Cei%2Cip%2Cid%2Citag%2Csource%2Crequiressl%2Cvprv%2Cmime%2Cgir%2Cclen%2Cdur%2Clmt&sig=AOq0QJ8wRQIhAMFIIH0acsHRShC24Nhcd4uR5zPpHeLJ4u0YzElcutPcAiAxMgooSSdyPslhHTEnGhLnbQ03zxdE0ev1_DOLbeDqCA%3D%3D&lsparams=mh%2Cmm%2Cmn%2Cms%2Cmv%2Cmvi%2Cpl%2Cinitcwndbps&lsig=AG3C_xAwRQIgN2rIidbqSn5xIJbjSVMk0xf6T9VBABBgxex7XwxF1LwCIQCO1ug32Amr93FZ7d65scJVGRsRBgYsQniXUNAWzfRjpA%3D%3D")),
          ],
        ),
      ),
    );

    // _audioPlayer
    //     .setAudioSource(ConcatenatingAudioSource(
    //         children: [AudioSource.uri(Uri.parse(url))]))
    //     .catchError((error) async {
    //   await YoutubeUtils.getUrlYoutube(playerProvider.currentId).then(
    //     (newUrl) {
    //       _audioPlayer
    //           .setAudioSource(ConcatenatingAudioSource(
    //               children: [AudioSource.uri(Uri.parse(newUrl))]))
    //           .then((value) {
    //         TracksUtils.putTrackUrl(playerProvider.currentId, newUrl);
    //       }).catchError((error) {
    //         // ignore: avoid_print
    //         print("error newUrl, snackbar : " + error.toString());
    //       });
    //     },
    //   ).catchError((error));
    //   // ignore: avoid_print
    //   print(
    //       "error setAudioSource (URL dead or wrong URL) : " + error.toString());
    // });
    notifyListeners();
  }

  void musicInit(String url, context) {
    musicLoadUrl(url, context);
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

  void musicRepeat() async {
    _repeat = !repeat;
    if (_repeat == true) {
      await _audioPlayer.setLoopMode(LoopMode.one);
    } else {
      await _audioPlayer.setLoopMode(LoopMode.off);
    }
    notifyListeners();
  }
}
