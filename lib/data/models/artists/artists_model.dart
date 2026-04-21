import 'package:spotify_me/data/models/song/song_model.dart';
import 'package:spotify_me/domain/entities/artists/artists_entity.dart';
import 'package:spotify_me/domain/entities/song/song.dart';

class ArtistsModel {
  String id;
  String name;
  int track;
  String coverUrl;
  List<SongModel> listSong;

  ArtistsModel({
    required this.id,
    required this.name,
    required this.track,
    required this.coverUrl,
    required this.listSong,
  });

  factory ArtistsModel.fromItunesSearch(Map<String, dynamic> json) {
    return ArtistsModel(
      id: json['artistId']?.toString() ?? '',
      name: json['artistName']?.toString() ?? 'Unknown Artist',
      track: (json['trackCount'] as num?)?.toInt() ?? 0,
      coverUrl: (json['artworkUrl100']?.toString() ?? '').replaceAll('100x100', '600x600'),
      listSong: [],
    );
  }

  factory ArtistsModel.fromItunesLookup(
    Map<String, dynamic> artistJson,
    List<dynamic> trackResults,
  ) {
    final songs = trackResults
        .where((item) => item['wrapperType'] == 'track')
        .map(
          (item) => SongModel(
            id: item['trackId']?.toString() ?? '',
            title: item['trackName'] ?? 'Unknown Title',
            artist: item['artistName'] ?? 'Unknown Artist',
            coverUrl: (item['artworkUrl100']?.toString() ?? '')
                .replaceAll('100x100', '600x600'),
            audioUrl: item['previewUrl']?.toString() ?? '',
            duration: Duration(
              milliseconds: (item['trackTimeMillis'] as num?)?.toInt() ?? 0,
            ),
            releaseDate: item['releaseDate'] != null
                ? DateTime.tryParse(item['releaseDate']) ?? DateTime.now()
                : DateTime.now(),
          ),
        )
        .toList();

    return ArtistsModel(
      id: artistJson['artistId']?.toString() ?? '',
      name: artistJson['artistName']?.toString() ?? 'Unknown Artist',
      track: songs.length,
      coverUrl: (artistJson['artworkUrl100']?.toString() ?? '').replaceAll('100x100', '600x600'),
      listSong: songs,
    );
  }
}

extension ArtistsModelToEntity on ArtistsModel {
  ArtistsEntity toEntity() {
    return ArtistsEntity(
      id: id,
      name: name,
      track: track,
      coverUrl: coverUrl,
      listSong: listSong.map((e) => e.toEntity()).toList(),
    );
  }
}
