import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:spotigreg_front/audio_service/audio_handler.dart';
import 'package:spotigreg_front/audio_service/video_handler.dart';
import 'package:spotigreg_front/models/track_model.dart';
import 'package:spotigreg_front/notifiers/speed_button_notifier.dart';
import 'package:spotigreg_front/utils/tracks_utils.dart';
import 'package:spotigreg_front/utils/youtube_utils.dart';
import '../notifiers/play_button_notifier.dart';
import '../notifiers/progress_notifier.dart';
import '../notifiers/repeat_button_notifier.dart';
import 'package:audio_service/audio_service.dart';
import './playlist_repository.dart';

late MyAudioHandler _audioHandler;

final pageManagerProvider = Provider((ref) => PageManager());
final _audioPlayer = AudioPlayer();
final videoHandler = VideoHandler();

class PageManager {
  late bool sortByMoreRecent = true;
  final currentSongNotifier = ValueNotifier<TrackModel>(TrackModel(
      album: "", artist: "", id: "", duration: "", title: "", url: ""));
  final playlistNotifier = ValueNotifier<List<MediaItem>>([]);
  final progressNotifier = ProgressNotifier();
  final repeatButtonNotifier = RepeatButtonNotifier();
  final speedButtonNotifier = SpeedButtonNotifier();
  final isFirstSongNotifier = ValueNotifier<bool>(true);
  final playButtonNotifier = PlayButtonNotifier();
  final isLastSongNotifier = ValueNotifier<bool>(true);
  final isShuffleModeEnabledNotifier = ValueNotifier<bool>(false);

  static Future<void> initAudioHandler() async {
    _audioHandler = await AudioService.init(
      builder: () => MyAudioHandler(),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.mycompany.myapp.audio',
        androidNotificationChannelName: 'Audio Service Demo',
        androidNotificationOngoing: true,
        androidStopForegroundOnPause: true,
      ),
    );
    _audioHandler.setRepeatMode(AudioServiceRepeatMode.all);
  }

  static Future<void> checkUrl() async {
    for (int key in box.keys) {
      await _audioPlayer
          .setAudioSource(ClippingAudioSource(
        child: AudioSource.uri(Uri.parse(box.get(key)!.url.toString())),
      ))
          .catchError((onError) async {
        await YoutubeUtils.getUrlYoutube(box.get(key)!.id.toString())
            .then((newUrlValue) {
          TracksUtils.putTrackUrl(box.get(key)!.id.toString(), newUrlValue);
        });
      });
    }
    _audioPlayer.dispose();
  }

  // Events: Calls coming from the UI
  void init() async {
    await loadPlaylist();
    _listenToChangesInPlaylist();
    _listenToPlaybackState();
    _listenToCurrentPosition();
    _listenToBufferedPosition();
    _listenToTotalDuration();
    listenToChangesInSong();
  }

  Future<void> loadPlaylist() async {
    var playlist =
        await PlaylistRepositorySortByMoreRecent().fetchInitialPlaylist();
    if (!sortByMoreRecent) {
      playlist = await PlaylistRepository().fetchInitialPlaylist();
    }

    final mediaItems = playlist
        .map((song) => MediaItem(
              id: song['id'] ?? '',
              album: song['album'] ?? '',
              artist: song['artist'] ?? '',
              title: song['title'] ?? '',
              extras: {'url': song['url']},
              artUri: Uri.parse(song['artUri'] ?? ''),
            ))
        .toList();
    playlistNotifier.value = mediaItems;
    _audioHandler.addQueueItems(mediaItems);
  }

  void _listenToChangesInPlaylist() {
    _audioHandler.queue.listen((playlist) {
      if (playlist.isEmpty) {
        playlistNotifier.value = [];
        currentSongNotifier.value = TrackModel(
            album: "", artist: "", id: "", duration: "", title: "", url: "");
      } else {
        final newList = playlist.map((item) => item).toList();
        playlistNotifier.value = newList;
      }
    });
  }

  void _listenToPlaybackState() {
    _audioHandler.playbackState.listen((playbackState) {
      final isPlaying = playbackState.playing;
      final processingState = playbackState.processingState;
      if (processingState == AudioProcessingState.loading ||
          processingState == AudioProcessingState.buffering) {
        playButtonNotifier.value = ButtonState.loading;
      } else if (!isPlaying) {
        playButtonNotifier.value = ButtonState.paused;
      } else if (processingState != AudioProcessingState.completed) {
        playButtonNotifier.value = ButtonState.playing;
      } else {
        _audioHandler.seek(Duration.zero);
        _audioHandler.pause();
        videoHandler.seekTo(Duration.zero);
        videoHandler.pause();
      }
    });
  }

  void _listenToCurrentPosition() {
    AudioService.position.listen((position) {
      if (position > const Duration(seconds: 9) &&
              position < const Duration(seconds: 10) ||
          position > const Duration(seconds: 30) &&
              position < const Duration(seconds: 31) ||
          position > const Duration(seconds: 60) &&
              position < const Duration(seconds: 61) ||
          position > const Duration(seconds: 90) &&
              position < const Duration(seconds: 91) ||
          position > const Duration(seconds: 120) &&
              position < const Duration(seconds: 121)) {
        videoHandler.seekTo(position);
      }

      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });
  }

  void _listenToBufferedPosition() {
    _audioHandler.playbackState.listen((playbackState) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: playbackState.bufferedPosition,
        total: oldState.total,
      );
    });
  }

  void _listenToTotalDuration() {
    _audioHandler.mediaItem.listen((mediaItem) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: mediaItem?.duration ?? Duration.zero,
      );
    });
  }

  void listenToChangesInSong() {
    _audioHandler.mediaItem.listen((mediaItem) {
      TrackModel currentTrack = TrackModel(
        id: mediaItem?.id ?? '',
        title: mediaItem?.title ?? '',
        album: mediaItem?.album ?? '',
        url: mediaItem?.extras!['url'] ?? '',
        duration: mediaItem?.duration.toString() ?? '',
        artist: mediaItem?.artist ?? '',
      );
      currentSongNotifier.value = currentTrack;
    });
  }

  void playFromSong(int? index) async {
    await videoHandler.initVideoController(
        playlistNotifier.value[index ?? 0].extras!["url"], false);
    _audioHandler.play();
    videoHandler.play();
    _audioHandler.skipToQueueItem(index ?? 0);
  }

  void play() {
    _audioHandler.play();
    videoHandler.play();
  }

  void pause() {
    _audioHandler.pause();
    videoHandler.pause();
  }

  void seek(Duration position) {
    _audioHandler.seek(position);
    videoHandler.seekTo(position);
  }

  void previous() => _audioHandler.skipToPrevious();
  void next() => _audioHandler.skipToNext();

  void repeat() {
    repeatButtonNotifier.nextState();
    final repeatMode = repeatButtonNotifier.value;
    switch (repeatMode) {
      case RepeatState.off:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.none);
        break;
      case RepeatState.repeatSong:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.one);
        break;
      case RepeatState.repeatPlaylist:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.all);
        break;
    }
  }

  void repeatAll() {
    _audioHandler.setRepeatMode(AudioServiceRepeatMode.all);
  }

  void speed(SpeedState speed) {
    speedButtonNotifier.nextState(speed);
    switch (speed) {
      case SpeedState.x1:
        _audioHandler.setSpeedMode(SpeedState.x1);
        break;
      case SpeedState.x2:
        _audioHandler.setSpeedMode(SpeedState.x2);
        break;
      case SpeedState.x0v5:
        _audioHandler.setSpeedMode(SpeedState.x0v5);
        break;
      case SpeedState.x0v25:
        _audioHandler.setSpeedMode(SpeedState.x0v25);
        break;
      case SpeedState.x0v75:
        _audioHandler.setSpeedMode(SpeedState.x0v75);
        break;
      case SpeedState.x1v25:
        _audioHandler.setSpeedMode(SpeedState.x1v25);
        break;
      case SpeedState.x1v5:
        _audioHandler.setSpeedMode(SpeedState.x1v5);
        break;
      case SpeedState.x1v75:
        _audioHandler.setSpeedMode(SpeedState.x1v75);
        break;
    }
  }

  void shuffle() {
    final enable = !isShuffleModeEnabledNotifier.value;
    isShuffleModeEnabledNotifier.value = enable;
    if (enable) {
      _audioHandler.setShuffleMode(AudioServiceShuffleMode.all);
    } else {
      _audioHandler.setShuffleMode(AudioServiceShuffleMode.none);
    }
  }

  add(String id, String album, String title, String url, String cover,
      String artist) async {
    final mediaItem = MediaItem(
      id: id,
      album: album,
      title: title,
      artist: artist,
      extras: {'url': url},
      artUri: Uri.parse(cover),
    );
    _audioHandler.addQueueItem(mediaItem);
  }

  addMoreRecent(String id, String album, String title, String url, String cover,
      String artist) async {
    final mediaItem = MediaItem(
      id: id,
      album: album,
      artist: artist,
      title: title,
      extras: {'url': url},
      artUri: Uri.parse(cover),
    );
    _audioHandler.addQueueItemMorerecent(mediaItem);
  }

  void remove(int index) {
    videoHandler.pause();
    if (index < 0) return;
    _audioHandler.removeQueueItemAt(index);
  }

  clearPlaylist() {
    while (_audioHandler.queue.value.isNotEmpty) {
      _audioHandler.queue.value.removeLast();
    }
  }

  void dispose() {
    _audioHandler.customAction('dispose');
  }

  void stop() {
    _audioHandler.stop();
  }
}
