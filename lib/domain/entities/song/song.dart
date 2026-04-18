
class SongEntity {
  final String id;
  final String artist;
  final String title;
  final num duration;
  final DateTime releaseDate;
  final String? coverUrl;
  final String? audioUrl;
  SongEntity({
    required this.id,
    required this.artist,
    required this.duration,
    required this.releaseDate,
    required this.title,
    this.audioUrl,
    this.coverUrl,

  });
}
