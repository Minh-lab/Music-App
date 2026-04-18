import 'package:spotify_me/core/configs/constants/app_urls.dart';
import 'package:spotify_me/domain/entities/song/song.dart';

class SongModel {
  final String id;
  final String artist;
  final String title;
  final num duration;
  final DateTime releaseDate;
  final String? audioUrl;
  final String? coverUrl; // tên file ảnh, ví dụ: "henyeu.jpg"

  SongModel({
    required this.id,
    required this.artist,
    required this.duration,
    required this.releaseDate,
    required this.title,
    this.audioUrl,
    this.coverUrl,
  });

  factory SongModel.fromJson(Map<String, dynamic> json) {
    return SongModel(
      id: json['id'].toString(),
      artist: json['artist'] ?? '',
      title: json['title'] ?? '',
      duration: json['duration'] ?? 0,
      // Supabase dùng snake_case: release_date
      releaseDate:
          DateTime.tryParse(json['release_date'] ?? '') ?? DateTime.now(),
      audioUrl: json['audio_url'], // tên file ảnh trong bucket Supabase Storage
      coverUrl: json['cover_url'], // tên file ảnh trong bucket Supabase Storage
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'artist': artist,
      'title': title,
      'duration': duration,
      'release_date': releaseDate.toIso8601String(),
      'cover_url': coverUrl,
      'audio_url': audioUrl,
    };
  }
}

extension SongModelToEntity on SongModel {
  SongEntity toEntity() {
    return SongEntity(
      id: id,
      artist: artist,
      duration: duration,
      releaseDate: releaseDate,
      title: title,
      // Ghép full URL từ base URL + tên file
      coverUrl: coverUrl != null
          ? '${AppUrls.supabaseCoversStorage}/$coverUrl'
          : null,
      audioUrl: audioUrl != null
          ? '${AppUrls.supabaseSongsStorage}/$audioUrl'
          : null,
    );
  }
}
