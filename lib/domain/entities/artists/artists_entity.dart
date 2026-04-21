import 'package:spotify_me/domain/entities/song/song.dart';

class ArtistsEntity {
  final String id;
  final String name;
  final int track;
  final String coverUrl;
  final List<SongEntity> listSong;

  ArtistsEntity({
    required this.id,
    required this.name,
    required this.track,
    required this.coverUrl,
    required this.listSong,
  });
}
