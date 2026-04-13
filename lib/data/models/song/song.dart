import 'package:spotify_me/core/configs/constants/app_urls.dart';
import 'package:spotify_me/domain/entities/song/song.dart';

class SongModel {
  final String artist;
  final String title;
  final num duration;
  final DateTime releaseDate;
  final String? coverUrl; // tên file ảnh, ví dụ: "henyeu.jpg"

  SongModel({
    required this.artist,
    required this.duration,
    required this.releaseDate,
    required this.title,
    this.coverUrl,
  });

  factory SongModel.fromJson(Map<String, dynamic> json) {
    return SongModel(
      artist: json['artist'] ?? '',
      title: json['title'] ?? '',
      duration: json['duration'] ?? 0,
      // Supabase dùng snake_case: release_date
      releaseDate: DateTime.tryParse(json['release_date'] ?? '') ?? DateTime.now(),
      coverUrl: json['cover_url'], // tên file ảnh trong bucket Supabase Storage
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'artist': artist,
      'title': title,
      'duration': duration,
      'release_date': releaseDate.toIso8601String(),
      'cover_url': coverUrl,
    };
  }
}

extension SongModelToEntity on SongModel {
  SongEntity toEntity() {
    return SongEntity(
      artist: artist,
      duration: duration,
      releaseDate: releaseDate,
      title: title,
      // Ghép full URL từ base URL + tên file
      coverUrl: coverUrl != null
          ? '${AppUrls.supabaseStorage}/$coverUrl'
          : null,
    );
  }
}