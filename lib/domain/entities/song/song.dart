
class SongEntity {
  final String artist;
  final String title;
  final num duration;
  final DateTime releaseDate;
  final String? coverUrl;
  SongEntity({
    required this.artist,
    required this.duration,
    required this.releaseDate,
    required this.title,
    this.coverUrl,
  });
}
