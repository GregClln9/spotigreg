import 'package:spotigreg_front/storage/tracks_hive.dart';
import 'package:hive/hive.dart';

class Boxes {
  static Box<TracksHive> getTracks() => Hive.box<TracksHive>('tracks');
}
