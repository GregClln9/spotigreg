import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifiers/play_button_notifier.dart';
import '../notifiers/progress_notifier.dart';
import '../notifiers/repeat_button_notifier.dart';
import 'package:audio_service/audio_service.dart';

final pageManagerProvider = Provider((ref) => VideoService());

class VideoService {
  late bool sortByMoreRecent = true;
  final currentSongTitleNotifier = ValueNotifier<String>('');
  final playlistNotifier = ValueNotifier<List<MediaItem>>([]);
  final progressNotifier = ProgressNotifier();
  final repeatButtonNotifier = RepeatButtonNotifier();
  final isFirstSongNotifier = ValueNotifier<bool>(true);
  final playButtonNotifier = PlayButtonNotifier();
  final isLastSongNotifier = ValueNotifier<bool>(true);
  final isShuffleModeEnabledNotifier = ValueNotifier<bool>(false);

  // Events: Calls coming from the UI
  // void init() async {
  //   // isLoading = true;
  //   await loadPlaylist();
  //   _listenToChangesInPlaylist();
  //   _listenToPlaybackState();
  //   _listenToCurrentPosition();
  //   _listenToBufferedPosition();
  //   _listenToTotalDuration();
  //   listenToChangesInSong();
  // }
}
