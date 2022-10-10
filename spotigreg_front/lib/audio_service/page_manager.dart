import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:spotigreg_front/audio_service/audio_handler.dart';
import 'package:spotigreg_front/audio_service/video_handler.dart';
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
  final currentSongTitleNotifier = ValueNotifier<String>('');
  final currentSongUrlNotifier = ValueNotifier<String>('');
  final playlistNotifier = ValueNotifier<List<MediaItem>>([]);
  final progressNotifier = ProgressNotifier();
  final repeatButtonNotifier = RepeatButtonNotifier();
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
        currentSongTitleNotifier.value = '';
        currentSongUrlNotifier.value = '';
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
      currentSongTitleNotifier.value = mediaItem?.title ?? '';
      currentSongUrlNotifier.value = mediaItem?.extras!["url"] ?? '';
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

  void shuffle() {
    final enable = !isShuffleModeEnabledNotifier.value;
    isShuffleModeEnabledNotifier.value = enable;
    if (enable) {
      _audioHandler.setShuffleMode(AudioServiceShuffleMode.all);
    } else {
      _audioHandler.setShuffleMode(AudioServiceShuffleMode.none);
    }
  }

  add(String id, String album, String title, String url, String cover) async {
    final mediaItem = MediaItem(
      id: id,
      album: album,
      title: title,
      extras: {'url': url},
      artUri: Uri.parse(cover),
    );
    _audioHandler.addQueueItem(mediaItem);
  }

  addMoreRecent(
      String id, String album, String title, String url, String cover) async {
    final mediaItem = MediaItem(
      id: id,
      album: album,
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
