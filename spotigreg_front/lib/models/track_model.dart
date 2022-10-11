// ignore_for_file: non_constant_identifier_artists

class TrackModel {
  final String id;
  final String album;
  final String artist;
  final String duration;
  final String url;
  final String title;

  TrackModel({
    required this.id,
    required this.url,
    required this.artist,
    required this.title,
    required this.album,
    required this.duration,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'album': album,
      'duration': duration,
      'url': url,
      'title': title,
      'artist': artist,
    };
  }

  factory TrackModel.fromMap(Map<String, dynamic> map) {
    return TrackModel(
      id: map['id'] ?? '',
      album: map['album'] ?? '',
      duration: map['duration'] ?? '',
      url: map['url'] ?? '',
      title: map['title'] ?? '',
      artist: map['artist'] ?? '',
    );
  }
}
