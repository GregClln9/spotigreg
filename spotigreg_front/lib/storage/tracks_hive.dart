import 'package:hive/hive.dart';

part 'tracks_hive.g.dart';

@HiveType(typeId: 1)
class TracksHive {
  TracksHive(
      {required this.id,
      required this.title,
      required this.artiste,
      required this.duration,
      required this.url,
      required this.cover, age});

  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String artiste;

  @HiveField(3)
  String duration;

  @HiveField(4)
  String url;

  @HiveField(5)
  String cover;
}
